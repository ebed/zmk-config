-- =============================================================================
-- WEZTERM CONFIGURATION
-- =============================================================================
--
-- Main configuration entry point for WezTerm
-- Author: ralbertomerinocolipe
-- Last update: 2026-01-26
--
-- Structure follows best practices from WezTerm documentation:
-- https://wezfurlong.org/wezterm/config/files.html

-- Load the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration
local config = wezterm.config_builder()

-- CRÍTICO: Prevenir que el shell sobrescriba títulos de tabs
config.automatically_reload_config = true
config.use_fancy_tab_bar = true  -- Forzar fancy tabs que usan format-tab-title

-- Ignorar secuencias OSC de cambio de título desde el shell
config.set_environment_variables = {
  DISABLE_AUTO_TITLE = "true",
}

-- =============================================================================
-- MOUSE BINDINGS - Abrir archivos en Neovim con click
-- =============================================================================

-- Variable global para rastrear qué modificador se usó
local open_file_mode = 'tab'  -- 'split', 'tab', 'window'

-- Eventos para setear el modo antes de abrir
wezterm.on('set-open-mode-split', function(window, pane)
  open_file_mode = 'split'
end)

wezterm.on('set-open-mode-tab', function(window, pane)
  open_file_mode = 'tab'
end)

wezterm.on('set-open-mode-window', function(window, pane)
  open_file_mode = 'window'
end)

config.mouse_bindings = {
  -- Click simple SIN modificadores: Selección normal, NO abrir links
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = wezterm.action.CompleteSelection('ClipboardAndPrimarySelection'),
  },

  -- CMD+Click: Abrir en panel lateral (split)
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD',
    action = wezterm.action.Multiple {
      wezterm.action.EmitEvent('set-open-mode-split'),
      wezterm.action.OpenLinkAtMouseCursor,
    },
  },

  -- CMD+SHIFT+Click: Abrir en nuevo tab
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD|SHIFT',
    action = wezterm.action.Multiple {
      wezterm.action.EmitEvent('set-open-mode-tab'),
      wezterm.action.OpenLinkAtMouseCursor,
    },
  },

  -- CMD+CTRL+Click: Abrir en nueva ventana
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'CMD|CTRL',
    action = wezterm.action.Multiple {
      wezterm.action.EmitEvent('set-open-mode-window'),
      wezterm.action.OpenLinkAtMouseCursor,
    },
  },
}

-- Función helper para encontrar pane con Neovim en el tab actual
local function find_nvim_pane(window, current_pane)
  local tab = window:mux_window():active_tab()
  local panes = tab:panes()

  wezterm.log_info('Searching for nvim pane in ' .. #panes .. ' panes')

  for _, p in ipairs(panes) do
    -- Get both foreground and title to detect nvim more reliably
    local process_name = p:get_foreground_process_name()
    local title = p:get_title()

    wezterm.log_info('Pane ' .. p:pane_id() .. ' process: ' .. (process_name or 'unknown') .. ', title: ' .. (title or 'unknown'))

    -- Check both process name AND title for nvim
    if (process_name and process_name:match('nvim')) or
       (title and title:match('nvim')) or
       (title and title:match('%.md')) then  -- Check for .md files (likely nvim editing claude response)
      wezterm.log_info('Found nvim pane: ' .. p:pane_id())
      return p
    end
  end

  wezterm.log_info('No nvim pane found')
  return nil
end

-- Handler personalizado para abrir enlaces de archivos en Neovim
wezterm.on('open-uri', function(window, pane, uri)
  wezterm.log_info('open-uri called with: ' .. uri .. ' in mode: ' .. open_file_mode)

  -- Detectar si es un archivo local (no URL http/https)
  if not uri:match('^https?://') then
    local file = uri
    local line = nil

    -- Extraer número de línea si tiene formato archivo:linea
    local match_file, match_line = uri:match('^(.+):(%d+)$')
    if match_file then
      file = match_file
      line = match_line
    end

    -- Obtener CWD del pane
    local cwd = pane:get_current_working_dir()
    local cwd_path = ''
    if cwd then
      cwd_path = cwd.file_path or tostring(cwd)
      -- Limpiar el file:// prefix
      cwd_path = cwd_path:gsub('^file://[^/]*', '')
    end

    wezterm.log_info('CWD: ' .. cwd_path)
    wezterm.log_info('File from URI: ' .. file)

    -- Resolver el path y determinar si necesitamos cd
    local nvim_file = file
    local needs_cd = false

    if file:match('^~') then
      -- Expandir ~ al home directory (path absoluto)
      nvim_file = wezterm.home_dir .. file:sub(2)
      needs_cd = false
    elseif file:match('^/') then
      -- Path ya absoluto
      nvim_file = file
      needs_cd = false
    else
      -- Path relativo - necesitamos cd al CWD
      nvim_file = file
      needs_cd = true
    end

    wezterm.log_info('Original: ' .. file)
    wezterm.log_info('Nvim will open: ' .. nvim_file)
    wezterm.log_info('Needs cd: ' .. tostring(needs_cd))

    -- Construir comando
    local nvim_cmd
    if needs_cd then
      -- Path relativo - hacer cd primero
      if line then
        nvim_cmd = string.format('cd "%s" && /opt/homebrew/bin/nvim +%s "%s"', cwd_path, line, nvim_file)
      else
        nvim_cmd = string.format('cd "%s" && /opt/homebrew/bin/nvim "%s"', cwd_path, nvim_file)
      end
    else
      -- Path absoluto - no necesitamos cd
      if line then
        nvim_cmd = string.format('/opt/homebrew/bin/nvim +%s "%s"', line, nvim_file)
      else
        nvim_cmd = string.format('/opt/homebrew/bin/nvim "%s"', nvim_file)
      end
    end

    wezterm.log_info('Command: ' .. nvim_cmd)

    -- Ejecutar según el modo
    if open_file_mode == 'split' then
      -- Buscar pane con nvim existente en el tab actual
      local nvim_pane = find_nvim_pane(window, pane)

      if nvim_pane then
        wezterm.log_info('Using existing nvim pane to open file')

        -- NUEVO: Detectar socket del proyecto actual (si existe)
        local success, stdout, stderr = wezterm.run_child_process({ 'bash', '-c', string.format('echo "%s" | md5 | cut -c1-8', cwd_path) })
        local project_hash = stdout and stdout:gsub('%s+', '') or ''
        local nvim_socket = '/tmp/claude-nvim-' .. project_hash .. '.sock'

        wezterm.log_info('Checking for nvim socket: ' .. nvim_socket)

        -- Verificar si el socket existe
        local check_success, check_stdout, check_stderr = wezterm.run_child_process({ 'bash', '-c', string.format('test -S "%s" && echo "yes" || echo "no"', nvim_socket) })
        local socket_exists = check_stdout and check_stdout:match('yes')

        if socket_exists then
          wezterm.log_info('Found nvim socket, using --remote')

          -- Usar nvim --remote para abrir en la instancia existente
          local remote_cmd
          if needs_cd then
            if line then
              remote_cmd = string.format('cd "%s" && /opt/homebrew/bin/nvim --server "%s" --remote-send "<Esc>:e +%s %s<CR>"',
                cwd_path, nvim_socket, line, nvim_file)
            else
              remote_cmd = string.format('cd "%s" && /opt/homebrew/bin/nvim --server "%s" --remote "%s"',
                cwd_path, nvim_socket, nvim_file)
            end
          else
            if line then
              remote_cmd = string.format('/opt/homebrew/bin/nvim --server "%s" --remote-send "<Esc>:e +%s %s<CR>"',
                nvim_socket, line, nvim_file)
            else
              remote_cmd = string.format('/opt/homebrew/bin/nvim --server "%s" --remote "%s"',
                nvim_socket, nvim_file)
            end
          end

          wezterm.log_info('Remote command: ' .. remote_cmd)

          -- Ejecutar comando en background
          wezterm.background_child_process({ 'zsh', '-c', remote_cmd })

          -- Activar el pane de nvim para mostrar el cambio
          -- El pane de nvim ya está visible, no necesitamos cambiar el foco
          wezterm.log_info('File opened in existing nvim via socket')
        else
          wezterm.log_info('No socket found, using send_text method')

          -- Fallback: método original con send_text
          local nvim_open_cmd
          if line then
            nvim_open_cmd = string.format(':e +%s %s\n', line, nvim_file)
          else
            nvim_open_cmd = string.format(':e %s\n', nvim_file)
          end

          nvim_pane:send_text('\x1b')
          nvim_pane:send_text(nvim_open_cmd)
        end
      else
        wezterm.log_info('No nvim pane found, creating new split')

        -- No hay nvim existente, crear nuevo split inferior
        window:perform_action(
          wezterm.action.SplitVertical {
            args = { 'zsh', '-l', '-c', nvim_cmd },
          },
          pane
        )
      end
    elseif open_file_mode == 'window' then
      -- Abrir en nueva ventana
      window:perform_action(
        wezterm.action.SpawnCommandInNewWindow {
          args = { 'zsh', '-l', '-c', nvim_cmd },
        },
        pane
      )
    else  -- mode == 'tab' (default)
      -- Abrir en nuevo tab
      window:perform_action(
        wezterm.action.SpawnCommandInNewTab {
          args = { 'zsh', '-l', '-c', nvim_cmd },
        },
        pane
      )
    end

    -- Resetear el modo para la próxima vez
    open_file_mode = 'tab'
    -- Retornar false para prevenir el comportamiento default
    return false
  end

  -- Para URLs http/https, dejar que el comportamiento default las abra en el navegador
  return true
end)

-- =============================================================================
-- CONFIGURATION MODULES
-- =============================================================================
-- Each module handles a specific aspect of the terminal configuration

-- Load utility functions
local utils_ok, utils = pcall(require, 'utils.helpers')

-- Helper function to safely load and apply modules
local function load_module(name)
  local ok, module = pcall(require, name)
  if ok and type(module) == 'table' and type(module.apply_to_config) == 'function' then
    wezterm.log_info('Successfully loaded module: ' .. name)
    pcall(module.apply_to_config, config)
  else
    wezterm.log_error('Failed to load module: ' .. name)
  end
end

-- Load core modules
load_module('modules.appearance')
load_module('modules.general')
load_module('modules.keybindings')

-- Load UI modules
-- load_module('modules.tabs')  -- Desactivado: conflicto con appearance.lua y tab_style.lua
-- load_module('modules.tab_titles')  -- Desactivado: conflicto con tab_style.lua
load_module('modules.window_title')
-- load_module('modules.claude_notifications')  -- Desactivado: duplica enhanced_statusline.lua
-- load_module('modules.tab_style')  -- Desactivado: handler ahora en wezterm.lua principal

-- Load enhanced features
load_module('modules.project_detection')
-- Choose one statusline option:
load_module('modules.enhanced_statusline')  -- Full featured (optimized) + Claude tracking
-- load_module('modules.statusline_lite')   -- Ultra lightweight (only time)
load_module('modules.workspaces')
load_module('modules.keymap_help')
-- load_module('modules.process_notifications')  -- Conflicto con enhanced_statusline

-- Load Claude optimized workspace
local claude_workspace = require('workspaces.claude_optimized_workspace')
claude_workspace.setup_claude_optimized_workspace(wezterm.home_dir)

-- =============================================================================
-- DEVELOPMENT/DEBUG OPTIONS
-- =============================================================================
-- Uncomment to enable development and debugging features
-- config.debug_key_events = true  -- Enable only when debugging keyboard issues
-- Use ./debug.sh check to verify configuration
-- Use ./debug.sh logs to view recent logs

-- =============================================================================
-- ENABLE AUTOMATIC UPDATES
-- =============================================================================

-- Check for and apply updates automatically
config.check_for_updates = true
config.check_for_updates_interval_seconds = 86400 -- Check daily

-- =============================================================================
-- AUTOMATICALLY RELOAD CONFIGURATION
-- =============================================================================

config.automatically_reload_config = true

-- =============================================================================
-- TAB FORMATTING - Registrado AQUÍ para asegurar que funciona
-- =============================================================================

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local pane = tab.active_pane
  if not pane then
    return { { Text = '?' } }
  end

  -- Título explícito (seteado con tab:set_title) tiene prioridad.
  -- Para tabs sin título (nuevos CMD+T) mostramos "quick", numerados si hay varios.
  local label = tab.tab_title
  if not label or label == '' then
    local unnamed_idx = 0
    local unnamed_total = 0
    for _, t in ipairs(tabs) do
      if not t.tab_title or t.tab_title == '' then
        unnamed_total = unnamed_total + 1
        if t.tab_id == tab.tab_id then
          unnamed_idx = unnamed_total
        end
      end
    end
    label = unnamed_total > 1 and ('quick ' .. unnamed_idx) or 'quick'
  end

  -- Detectar Claude activo por el título OSC del pane
  local pane_title = pane.title or ''
  local is_claude_active = pane_title:match('🤖') ~= nil

  if is_claude_active then
    label = '🤖 ' .. label
  end

  local text = ' ' .. label .. ' '

  -- Tab activo
  if tab.is_active then
    if is_claude_active then
      return {
        { Background = { Color = '#10b981' } },
        { Foreground = { Color = '#ffffff' } },
        { Text = text },
      }
    else
      return {
        { Background = { Color = '#3b82f6' } },
        { Foreground = { Color = '#ffffff' } },
        { Text = text },
      }
    end
  else
    if is_claude_active then
      return {
        { Background = { Color = '#059669' } },
        { Foreground = { Color = '#ffffff' } },
        { Text = text },
      }
    else
      return {
        { Background = { Color = 'rgba(43, 47, 64, 0.7)' } },
        { Foreground = { Color = '#c6d0f5' } },
        { Text = text },
      }
    end
  end
end)

-- =============================================================================
-- OPACITY CONTROLS - Eventos de teclado
-- =============================================================================

-- Aumentar opacidad (menos transparencia)
wezterm.on('increase-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity or config.window_background_opacity or 1.0

  -- Aumentar en incrementos de 0.05, máximo 1.0
  opacity = math.min(1.0, opacity + 0.05)
  overrides.window_background_opacity = opacity
  window:set_config_overrides(overrides)

  wezterm.log_info(string.format("Opacity: %.0f%%", opacity * 100))
end)

-- Disminuir opacidad (más transparencia)
wezterm.on('decrease-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  local opacity = overrides.window_background_opacity or config.window_background_opacity or 1.0

  -- Disminuir en incrementos de 0.05, mínimo 0.1 (para no ser invisible)
  opacity = math.max(0.1, opacity - 0.05)
  overrides.window_background_opacity = opacity
  window:set_config_overrides(overrides)

  wezterm.log_info(string.format("Opacity: %.0f%%", opacity * 100))
end)

-- Resetear opacidad al valor default
wezterm.on('reset-opacity', function(window, pane)
  local overrides = window:get_config_overrides() or {}
  overrides.window_background_opacity = nil  -- Remover override, usa valor default
  window:set_config_overrides(overrides)

  local default_opacity = config.window_background_opacity or 1.0
  wezterm.log_info(string.format("Opacity reset to: %.0f%%", default_opacity * 100))
end)

-- Return the configuration
return config
