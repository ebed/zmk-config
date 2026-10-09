-- =============================================================================
-- WORKSPACE MANAGEMENT MODULE
-- =============================================================================
--
-- Save and restore workspace layouts for different projects
-- Allows quick switching between project contexts
--
-- Author: ralbertomerinocolipe
-- Last update: 2026-01-26

local wezterm = require('wezterm')
local act = wezterm.action
local mux = wezterm.mux

local M = {}

-- =============================================================================
-- SESIÓN PERSISTENTE - Restaurar tabs y paneles al abrir
-- =============================================================================

-- Evento que se ejecuta al inicio de wezterm.
-- Solo abre el tab "local" (tmux persistente). Los demás se crean con CMD+T.
-- Regla: no mezclar splits de WezTerm y tmux en la misma tab.
wezterm.on('gui-startup', function(cmd)
  -- Tab 1 — tmux local: sesión persistente que sobrevive al reinicio de WezTerm
  -- Ruta absoluta: el PATH en gui-startup no incluye /opt/homebrew/bin
  local tab1, _p1, _window = mux.spawn_window(cmd or {
    args = { '/opt/homebrew/bin/tmux', 'new-session', '-A', '-s', 'local' },
  })
  tab1:set_title('local')
  tab1:activate()
end)

-- Workspace configuration
local function configure_workspaces(config)
  -- Enable workspace support
  config.default_workspace = 'default'

  -- Workspace keybindings
  local workspace_keys = {
    -- Switch to workspace selector (changed from CMD+SHIFT+W to CMD+SHIFT+O to avoid conflict)
    {
      key = 'o',
      mods = 'CMD|SHIFT',
      action = act.ShowLauncherArgs({
        flags = 'FUZZY|WORKSPACES',
      }),
    },

    -- Create new workspace
    {
      key = 'n',
      mods = 'CMD|SHIFT',
      action = act.PromptInputLine({
        description = 'Enter name for new workspace:',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },

    -- Guardar sesión actual con nombre personalizado
    {
      key = 's',
      mods = 'CMD|CTRL',
      action = act.PromptInputLine({
        description = 'Guardar sesión como:',
        action = wezterm.action_callback(function(window, pane, line)
          if line then
            -- Wezterm guarda automáticamente, solo mostramos confirmación
            window:toast_notification('wezterm', 'Sesión guardada: ' .. line, nil, 4000)
            window:perform_action(
              act.SwitchToWorkspace({
                name = line,
              }),
              pane
            )
          end
        end),
      }),
    },

    -- Mostrar lista de todas las sesiones/workspaces guardadas
    {
      key = 'l',
      mods = 'CMD|CTRL',
      action = act.ShowLauncherArgs({
        flags = 'FUZZY|WORKSPACES',
        title = 'Seleccionar workspace guardado',
      }),
    },
  }

  -- Add workspace keys to existing keybindings
  config.keys = config.keys or {}
  for _, key in ipairs(workspace_keys) do
    table.insert(config.keys, key)
  end
end

-- Configure workspace title display
local function configure_workspace_display(config)
  wezterm.on('update-status', function(window, pane)
    -- Obtener workspace y contador de Claude
    local workspace = window:active_workspace()
    local claude_count = 0
    local now = os.time()  -- Usar os.time() en lugar de wezterm.time.now()

    -- Contar Claudes activos desde el estado global (con limpieza)
    if _G.claude_states then
      for pane_id, state in pairs(_G.claude_states) do
        if state.working then
          -- Solo contar si no es muy antiguo (máx 1 hora)
          local age = now - state.started
          if age < 3600 then
            claude_count = claude_count + 1
          else
            -- Limpiar estado muy antiguo
            _G.claude_states[pane_id] = nil
          end
        end
      end
    end

    -- El indicador de Claude va en el color del tab (verde). Left status solo muestra workspace no-default.
    if workspace ~= 'default' then
      window:set_left_status(wezterm.format({
        { Foreground = { Color = '#ffffff' } },
        { Background = { Color = '#5e81ac' } },
        { Attribute = { Intensity = 'Bold' } },
        { Text = ' 󰲋 ' .. workspace .. ' ' },
      }))
    else
      window:set_left_status('')
    end
  end)
end

function M.apply_to_config(config)
  configure_workspaces(config)
  configure_workspace_display(config)
  wezterm.log_info('Workspace management loaded')
end

return M
