-- =============================================================================
-- ENHANCED STATUSLINE MODULE
-- =============================================================================
--
-- Advanced status line with project info, git status, system metrics
--
-- Author: ralbertomerinocolipe
-- Last update: 2026-01-26

local wezterm = require('wezterm')
local icons = require('modules.icons')
local project_detection = require('modules.project_detection')

local M = {}

-- =============================================================================
-- CLAUDE CODE TRACKING (Variable global compartida)
-- =============================================================================

-- Tabla GLOBAL para rastrear el estado de Claude en cada panel
-- Esto permite que tab_style.lua también acceda a esta información
if not _G.claude_states then
  _G.claude_states = {}
end
local claude_states = _G.claude_states

-- Verificar si un proceso es Claude Code (principal, no subagents)
local function is_claude_process(process_name)
  if not process_name then return false end

  local lower = process_name:lower()

  -- Solo contar el proceso principal de Claude, no subagents
  -- Filtrar procesos que contienen "agent", "spawn", o proyectos con "claude" en el nombre
  if lower:match('agent') or
     lower:match('spawn') or
     lower:match('dashboard') or
     lower:match('tsx') or
     lower:match('next') then
    return false
  end

  return lower:match('claude')
end

-- Limpiar estados antiguos de paneles que ya no existen
local function cleanup_old_states(window)
  local valid_pane_ids = {}

  -- Obtener todos los pane_ids válidos
  for _, tab in ipairs(window:mux_window():tabs()) do
    for _, pane_info in ipairs(tab:panes_with_info()) do
      valid_pane_ids[pane_info.pane:pane_id()] = true
    end
  end

  -- Limpiar estados de paneles que ya no existen
  for pane_id, _ in pairs(claude_states) do
    if not valid_pane_ids[pane_id] then
      claude_states[pane_id] = nil
    end
  end
end

-- Obtener conteo de Claudes activos
local function get_active_claude_count()
  local count = 0
  local now = os.time()

  for pane_id, state in pairs(claude_states) do
    -- Solo contar si está trabajando y no es muy antiguo (máx 1 hora)
    if state.working then
      local age = now - state.started
      if age < 3600 then  -- 1 hora en segundos
        count = count + 1
      else
        -- Limpiar estado muy antiguo
        claude_states[pane_id] = nil
      end
    end
  end
  return count
end

-- Battery info cache
local BATTERY_CACHE = {
  data = nil,
  last_update = 0,
  ttl = 60, -- Update every 60 seconds (instead of every callback)
}

-- Get battery information (macOS) with aggressive caching
local function get_battery_info()
  local now = os.time()

  -- Return cached value if still valid
  if BATTERY_CACHE.data and (now - BATTERY_CACHE.last_update) < BATTERY_CACHE.ttl then
    return BATTERY_CACHE.data
  end

  -- Only update if cache expired
  local success, output, stderr = wezterm.run_child_process({
    'pmset', '-g', 'batt'
  })

  if not success then
    return BATTERY_CACHE.data -- Return last known value on error
  end

  -- Parse battery percentage
  local percent = output:match('(%d+)%%')
  local charging = output:match('AC Power') or output:match('charging')

  if not percent then
    return BATTERY_CACHE.data -- Return last known value if parse fails
  end

  percent = tonumber(percent)

  -- Select battery icon based on level
  local icon_idx = 1
  if percent > 80 then
    icon_idx = 5
  elseif percent > 60 then
    icon_idx = 4
  elseif percent > 40 then
    icon_idx = 3
  elseif percent > 20 then
    icon_idx = 2
  end

  -- Update cache
  BATTERY_CACHE.data = {
    percent = percent,
    charging = charging ~= nil,
    icon = icons.battery[icon_idx],
  }
  BATTERY_CACHE.last_update = now

  return BATTERY_CACHE.data
end

-- Get current time
local function get_time()
  return wezterm.strftime('%H:%M')
end

-- Get current date
local function get_date()
  return wezterm.strftime('%Y-%m-%d')
end

-- Format git status for display
local function format_git_status(git_info)
  if not git_info then return '' end

  local parts = {}
  table.insert(parts, icons.branch .. ' ' .. (git_info.branch or 'unknown'))

  if git_info.dirty then
    table.insert(parts, icons.dirty)
  end

  if git_info.ahead and git_info.ahead > 0 then
    table.insert(parts, icons.ahead .. git_info.ahead)
  end

  if git_info.behind and git_info.behind > 0 then
    table.insert(parts, icons.behind .. git_info.behind)
  end

  return table.concat(parts, ' ')
end

-- Configure statusline
local function configure_statusline(config)
  -- Trackear el estado de Claude en los paneles
  wezterm.on('update-status', function(window, pane)
    local pane_id = pane:pane_id()
    local foreground = pane:get_foreground_process_name()

    -- Verificar si Claude está corriendo AHORA
    local current_is_claude = foreground and is_claude_process(foreground)
    local was_working = claude_states[pane_id] and claude_states[pane_id].working

    if current_is_claude then
      -- Claude está corriendo
      if not was_working then
        -- Claude acaba de empezar
        claude_states[pane_id] = {
          started = os.time(),
          working = true,
          process = foreground,
        }
      end
    else
      -- Claude NO está corriendo en este panel
      if was_working then
        -- Claude ACABA de terminar
        local duration = os.time() - claude_states[pane_id].started

        -- Mostrar notificación solo si duró más de 5 segundos
        if duration > 5 then
          local minutes = math.floor(duration / 60)
          local seconds = math.floor(duration % 60)

          window:toast_notification(
            'Claude Code',
            string.format('✅ Tarea completada (duración: %dm %ds)', minutes, seconds),
            nil,
            8000
          )
        end

        -- Limpiar INMEDIATAMENTE
        claude_states[pane_id] = nil

        -- Forzar actualización de todos los tabs
        for _, tab in ipairs(window:mux_window():tabs()) do
          tab:set_title(tab:get_title())
        end
      elseif claude_states[pane_id] then
        -- Hay estado pero ya no está trabajando, limpiar
        claude_states[pane_id] = nil
      end
    end
  end)

  -- Cache del último workspace visto para detectar cambios
  local last_workspace = nil

  -- Statusline derecho (información del proyecto)
  -- Nota: left_status (Claude counter) se maneja en workspaces.lua
  wezterm.on('update-right-status', function(window, pane)
    local elements = {}

    -- Workspace name (clickeable para cambiar)
    local workspace = window:active_workspace()

    -- Detectar cambio de workspace y forzar actualización inmediata
    if workspace ~= last_workspace then
      last_workspace = workspace
      wezterm.log_info("Workspace changed to: " .. (workspace or "default"))
    end
    if workspace and workspace ~= "default" then
      -- Hacer el workspace clickeable (clic derecho abre selector)
      table.insert(elements, { Foreground = { Color = '#eceff4' } })
      table.insert(elements, { Background = { Color = '#2e3440' } })
      table.insert(elements, { Text = ' ' })

      -- Workspace clickeable
      table.insert(elements, { Foreground = { Color = '#88c0d0' } }) -- Color distintivo
      table.insert(elements, { Background = { Color = '#3b4252' } }) -- Fondo ligeramente diferente
      table.insert(elements, {
        Attribute = {
          Underline = 'Single'  -- Subrayado para indicar que es clickeable
        }
      })
      table.insert(elements, {
        Text = ' 🚀 ' .. workspace .. ' ',
      })

      -- Hacer clickeable - clic derecho abre selector de workspaces
      table.insert(elements, {
        Attribute = {
          Hyperlink = 'wezterm://switch-workspace'
        }
      })

      -- Reset attributes
      table.insert(elements, 'ResetAttributes')
      table.insert(elements, { Foreground = { Color = '#eceff4' } })
      table.insert(elements, { Background = { Color = '#2e3440' } })
      table.insert(elements, { Text = '  |  ' })
    end

    -- Get project information (con protección de errores)
    local ok, project = pcall(project_detection.get_project_info, pane)

    -- Solo usar project si pcall tuvo éxito
    if ok and project then
      -- Project/Tech info
      if project.tech then
        table.insert(elements, { Text = project.tech.icon .. ' ' .. project.tech.key .. '  |  ' })
      end

      -- Git status
      if project.git then
        local git_status = format_git_status(project.git)
        if git_status ~= '' then
          table.insert(elements, { Text = git_status .. '  |  ' })
        end
      end
    end

    -- Time (simple, sin batería — la barra de macOS ya la muestra)
    table.insert(elements, { Foreground = { Color = '#6c7086' } })
    table.insert(elements, { Text = get_time() .. ' ' })

    -- Set right status with formatted elements
    window:set_right_status(wezterm.format(elements))
  end)
end

-- Limpiar estado cuando se cierra un panel
wezterm.on('pane-closed', function(pane_id)
  if claude_states[pane_id] then
    claude_states[pane_id] = nil
  end
end)

-- Capturar clics en el workspace para abrir selector
wezterm.on('open-uri', function(window, pane, uri)
  if uri == 'wezterm://switch-workspace' then
    -- Abrir selector de workspaces
    window:perform_action(
      wezterm.action.ShowLauncherArgs({ flags = 'FUZZY|WORKSPACES' }),
      pane
    )
    -- Prevenir que se abra como URL normal
    return false
  end
  -- Dejar que otros URIs se manejen normalmente
  return true
end)

-- Forzar actualización del statusline en varios eventos

-- Cuando cambia el foco de ventana
wezterm.on('window-focus-changed', function(window, pane)
  if window and pane then
    -- Forzar recalculo del statusline
    wezterm.time.call_after(0.1, function()
      window:set_right_status('')
    end)
  end
end)

-- Cuando se recarga la configuración
wezterm.on('window-config-reloaded', function(window, pane)
  if window then
    wezterm.time.call_after(0.1, function()
      window:set_right_status('')
    end)
  end
end)

-- Cuando cambia el tab activo (puede indicar cambio de workspace)
wezterm.on('active-tab-changed', function(tab, pane)
  local window = tab:window()
  if window then
    wezterm.time.call_after(0.1, function()
      window:set_right_status('')
    end)
  end
end)

function M.apply_to_config(config)
  configure_statusline(config)
end

return M
