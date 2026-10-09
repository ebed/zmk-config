-- =============================================================================
-- KEYBINDINGS MODULE
-- =============================================================================
--
-- Controls all keyboard shortcuts for WezTerm:
-- - Tab navigation and management
-- - Pane management
-- - Font size adjustment
-- - Copy/paste operations
-- - General terminal operations
--
-- Author: ralbertomerinocolipe
-- Last update: 2024-01-08

local wezterm = require('wezterm')
local act = wezterm.action
local M = {}

-- =============================================================================
-- KEY TABLES
-- =============================================================================

-- Optional leader key setup - uncomment to use
-- local leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- =============================================================================
-- TAB MANAGEMENT KEYS
-- =============================================================================

-- Keys for tab navigation and management
local function configure_tab_keys()
  local keys = {
    -- Tab selection by number
    { key = '1', mods = 'CMD', action = act.ActivateTab(0) },
    { key = '2', mods = 'CMD', action = act.ActivateTab(1) },
    { key = '3', mods = 'CMD', action = act.ActivateTab(2) },
    { key = '4', mods = 'CMD', action = act.ActivateTab(3) },
    { key = '5', mods = 'CMD', action = act.ActivateTab(4) },
    { key = '6', mods = 'CMD', action = act.ActivateTab(5) },
    { key = '7', mods = 'CMD', action = act.ActivateTab(6) },
    { key = '8', mods = 'CMD', action = act.ActivateTab(7) },
    { key = '9', mods = 'CMD', action = act.ActivateTab(-1) }, -- Last tab

    -- Tab navigation
    { key = '[', mods = 'CMD', action = act.ActivateTabRelative(-1) },
    { key = ']', mods = 'CMD', action = act.ActivateTabRelative(1) },

    -- Tab management
    -- CMD+T: prompt de nombre. "texto" → shell simple, "s:texto" → sesión tmux (s) texto
    {
      key = 't', mods = 'CMD',
      action = act.PromptInputLine {
        description = 'Nuevo tab — nombre (s:nombre para sesión tmux persistente)',
        action = wezterm.action_callback(function(window, pane, line)
          if not line then return end
          line = line:match('^%s*(.-)%s*$')
          if line == '' then return end

          local is_session = line:match('^s:') ~= nil
          local name = is_session and line:sub(3):match('^%s*(.-)%s*$') or line
          if name == '' then name = is_session and 'session' or 'shell' end

          local tab_title = is_session and ('(s) ' .. name) or name
          local args
          if is_session then
            args = { '/opt/homebrew/bin/tmux', 'new-session', '-A', '-s', name }
          else
            local shell = os.getenv('SHELL') or 'zsh'
            args = { shell, '-l' }
          end

          local tab = window:mux_window():spawn_tab({ args = args })
          if tab then tab:set_title(tab_title) end
        end),
      },
    },
    -- CMD+, → renombrar tab actual (mismo mnemónico que tmux prefix+,)
    {
      key = ',', mods = 'CMD',
      action = act.PromptInputLine {
        description = 'Renombrar tab',
        action = wezterm.action_callback(function(window, pane, line)
          if line and line ~= '' then
            window:mux_window():active_tab():set_title(line:match('^%s*(.-)%s*$'))
          end
        end),
      },
    },
    { key = 'w', mods = 'CMD',       action = act.CloseCurrentTab { confirm = true } },

    -- Tab reordering (mover tabs izquierda/derecha)
    { key = '[', mods = 'CMD|SHIFT', action = act.MoveTabRelative(-1) },
    { key = ']', mods = 'CMD|SHIFT', action = act.MoveTabRelative(1) },

    -- Launcher para mover tabs entre ventanas o crear nueva ventana
    -- Usa este launcher para seleccionar dónde mover el tab
    { key = 'm', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|TABS|WORKSPACES' } },

    -- Alternative: Atajo más simple para mostrar lista de tabs
    { key = 'e', mods = 'CMD|SHIFT', action = act.ShowTabNavigator },

    -- Workspace management (usando combinaciones sin conflictos)
    { key = '9', mods = 'CMD|SHIFT', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
    { key = '[', mods = 'CMD|CTRL', action = act.SwitchWorkspaceRelative(-1) },
    { key = ']', mods = 'CMD|CTRL', action = act.SwitchWorkspaceRelative(1) },
  }

  return keys
end

-- =============================================================================
-- PANE MANAGEMENT KEYS
-- =============================================================================

-- Keys for pane splitting, navigation and management
local function configure_pane_keys()
  local keys = {
    -- PRIMARY SPLIT KEYS (Most reliable on macOS)
    -- Using OPT (Alt/Option) instead of CMD to avoid system conflicts
    { key = 'd', mods = 'OPT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'D', mods = 'OPT|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- ALTERNATIVE 1: Using CTRL (works reliably)
    { key = 'd', mods = 'CTRL|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'D', mods = 'CTRL|SHIFT|ALT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- ALTERNATIVE 2: Using | and _ characters (like tmux)
    { key = '|', mods = 'CMD|SHIFT', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '_', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- ALTERNATIVE 3: Using numbers on numpad or regular
    { key = '\\', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '|', mods = 'CMD', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Keep CMD+D as backup (may work after disabling defaults)
    { key = 'd', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'D', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Enter-based splits (highly reliable)
    { key = 'Enter', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'Enter', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'Return', mods = 'CMD', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = 'Return', mods = 'CMD|SHIFT', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },

    -- Close pane
    { key = 'w', mods = 'CMD|SHIFT', action = act.CloseCurrentPane { confirm = true } },
    { key = 'x', mods = 'CMD', action = act.CloseCurrentPane { confirm = true } },
    { key = 'x', mods = 'OPT', action = act.CloseCurrentPane { confirm = true } },

    -- Pane navigation with arrows
    { key = 'LeftArrow', mods = 'CMD', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'CMD', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'CMD', action = act.ActivatePaneDirection 'Down' },

    -- Alternative arrow navigation with OPT
    { key = 'LeftArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'OPT', action = act.ActivatePaneDirection 'Down' },

    -- Vim-style navigation (HJKL)
    { key = 'h', mods = 'OPT', action = act.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'OPT', action = act.ActivatePaneDirection 'Right' },
    { key = 'k', mods = 'OPT', action = act.ActivatePaneDirection 'Up' },
    { key = 'j', mods = 'OPT', action = act.ActivatePaneDirection 'Down' },

    -- Pane zooming (maximize/restore)
    { key = 'z', mods = 'CMD', action = act.TogglePaneZoomState },
    { key = 'z', mods = 'OPT', action = act.TogglePaneZoomState },

    -- Pane rotation (rotate layout positions)
    { key = 'r', mods = 'CMD|SHIFT', action = act.RotatePanes 'Clockwise' },
    { key = 'r', mods = 'CMD|CTRL', action = act.RotatePanes 'CounterClockwise' },

    -- Pane swapping (swap current pane with adjacent pane)
    { key = 'LeftArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow', mods = 'CMD|SHIFT', action = act.ActivatePaneDirection 'Down' },

    -- Pane selector (interactive pane selection)
    { key = 'p', mods = 'CMD|SHIFT', action = act.PaneSelect },
    { key = 'p', mods = 'CMD|CTRL', action = act.PaneSelect { mode = 'SwapWithActive' } },

    -- Pane resizing
    { key = 'LeftArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Left', 5 } },
    { key = 'RightArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Right', 5 } },
    { key = 'UpArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Up', 5 } },
    { key = 'DownArrow', mods = 'CMD|OPT', action = act.AdjustPaneSize { 'Down', 5 } },
  }

  return keys
end

-- =============================================================================
-- TEXT MANIPULATION KEYS
-- =============================================================================

-- Keys for copy/paste, search, and text manipulation
local function configure_text_keys()
  local keys = {
    -- Clipboard
    { key = 'c', mods = 'CMD',       action = act.CopyTo 'Clipboard' },
    { key = 'c', mods = 'CMD|SHIFT', action = act.CopyTo 'Clipboard' },
    { key = 'v', mods = 'CMD', action = act.PasteFrom 'Clipboard' },

    -- Clear terminal (changed to CMD+K with SHIFT to avoid conflict with vim nav)
    { key = 'k', mods = 'CMD|SHIFT', action = act.ClearScrollback 'ScrollbackAndViewport' },

    -- Search
    { key = 'f', mods = 'CMD', action = act.Search 'CurrentSelectionOrEmptyString' },

    -- Font size
    { key = '=', mods = 'CMD', action = act.IncreaseFontSize },
    { key = '-', mods = 'CMD', action = act.DecreaseFontSize },
    { key = '0', mods = 'CMD', action = act.ResetFontSize },

    -- Opacity controls (transparencia de ventana)
    { key = '=', mods = 'CMD|CTRL', action = act.EmitEvent 'increase-opacity' },
    { key = '-', mods = 'CMD|CTRL', action = act.EmitEvent 'decrease-opacity' },
    { key = '0', mods = 'CMD|CTRL', action = act.EmitEvent 'reset-opacity' },
  }

  return keys
end

-- =============================================================================
-- UTILITY KEYS
-- =============================================================================

-- Miscellaneous utility keys
local function configure_utility_keys()
  local keys = {
    -- Reload configuration
    { key = 'r', mods = 'CMD|SHIFT', action = act.ReloadConfiguration },

    -- Full screen
    { key = 'f', mods = 'CMD|SHIFT', action = act.ToggleFullScreen },

    -- Command palette
    { key = 'p', mods = 'CMD|SHIFT', action = act.ActivateCommandPalette },

    -- Quick select mode para archivos - Abrir en Neovim
    {
      key = 'o',
      mods = 'CMD|SHIFT',
      action = act.QuickSelectArgs {
        label = 'Abrir archivo en Neovim',
        patterns = {
          -- Archivos con ruta absoluta o relativa
          '[~./][a-zA-Z0-9_\\-\\.]+/[a-zA-Z0-9_/\\-\\.]+\\.[a-zA-Z0-9]+',
          -- Archivos con número de línea (archivo:123)
          '[~./]?[a-zA-Z0-9_/\\-\\.]+\\.[a-zA-Z0-9]+:[0-9]+',
          -- Solo nombre de archivo con extensión
          '[a-zA-Z0-9_\\-]+\\.[a-zA-Z0-9]+',
        },
        action = wezterm.action_callback(function(window, pane)
          local url = window:get_selection_text_for_pane(pane)
          if url then
            local file, line = url:match('^(.+):(%d+)')
            if not file then
              file = url
            end

            -- Expandir ~ si es necesario
            if file:match('^~') then
              file = wezterm.home_dir .. file:sub(2)
            elseif not file:match('^/') then
              -- Path relativo - usar el CWD del pane
              local cwd = pane:get_current_working_dir()
              if cwd and cwd.file_path then
                file = cwd.file_path .. '/' .. file
              end
            end

            -- Construir comando con path completo de nvim
            local nvim_cmd
            if line then
              nvim_cmd = string.format('/opt/homebrew/bin/nvim +%s "%s"', line, file)
            else
              nvim_cmd = string.format('/opt/homebrew/bin/nvim "%s"', file)
            end

            window:perform_action(
              act.SpawnCommandInNewTab {
                args = { 'zsh', '-l', '-c', nvim_cmd },
              },
              pane
            )
          end
        end),
      },
    },

    -- Quick select general (texto, paths, URLs)
    { key = 's', mods = 'CMD|SHIFT', action = act.QuickSelect },

    -- Limpiar contador de Claude manualmente (Cmd+Ctrl+C)
    {
      key = 'c',
      mods = 'CMD|CTRL',
      action = wezterm.action_callback(function(window, pane)
        -- Limpiar todos los estados de Claude
        if _G.claude_states then
          _G.claude_states = {}
        end

        -- Forzar re-render de todos los tabs
        for _, tab in ipairs(window:mux_window():tabs()) do
          tab:set_title(tab:get_title())
        end

        window:toast_notification('wezterm', '✅ Contador de Claude reiniciado', nil, 2000)
      end),
    },

    -- DEBUG: Mostrar proceso actual del panel (TEMPORAL - F12)
    {
      key = 'F12',
      action = wezterm.action_callback(function(window, pane)
        local foreground = pane:get_foreground_process_name()
        if not foreground then
          window:toast_notification('Debug', 'Sin proceso', nil, 3000)
          return
        end

        local lower = foreground:lower()
        local is_claude = lower:match('claude') and
                         not lower:match('agent') and
                         not lower:match('spawn') and
                         not lower:match('dashboard') and
                         not lower:match('tsx') and
                         not lower:match('next')

        local msg = 'Proceso: ' .. foreground .. '\nEs Claude: ' .. (is_claude and 'SI' or 'NO')
        window:toast_notification('Debug', msg, nil, 5000)
      end),
    },

    -- Ensure Alt combinations for special characters work
    -- Avoid assigning shortcuts that may interfere with accented characters
  }

  return keys
end

-- =============================================================================
-- APPLY ALL KEYBINDINGS
-- =============================================================================

function M.apply_to_config(config)
  -- Combine all key tables
  local keys = {}

  -- Add keys from each category
  for _, key in ipairs(configure_tab_keys()) do table.insert(keys, key) end
  for _, key in ipairs(configure_pane_keys()) do table.insert(keys, key) end
  for _, key in ipairs(configure_text_keys()) do table.insert(keys, key) end
  for _, key in ipairs(configure_utility_keys()) do table.insert(keys, key) end

  -- Add workspace launcher keybinding (using simplified version)
  local workspace_launcher = require("modules.workspace_launcher_simple")
  table.insert(keys, workspace_launcher.get_keybinding())

  -- Add Claude optimized workspace keybinding (CMD+CTRL+L)
  local claude_optimized = require("workspaces.claude_optimized_workspace")
  table.insert(keys, claude_optimized.get_keybinding())

  -- Apply keys to config
  config.keys = keys

  -- Uncomment to use leader key
  -- config.leader = leader
end

return M