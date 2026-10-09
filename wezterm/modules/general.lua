-- =============================================================================
-- GENERAL SETTINGS MODULE
-- =============================================================================
--
-- Contains general configuration options for WezTerm:
-- - Terminal behavior settings
-- - Default programs and domains
-- - Performance and rendering options
-- - Miscellaneous settings
--
-- Author: ralbertomerinocolipe
-- Last update: 2024-01-08

local wezterm = require('wezterm')
local utils = require('utils.helpers')

local M = {}

-- =============================================================================
-- TERMINAL BEHAVIOR
-- =============================================================================

-- Configure general terminal behavior
local function configure_terminal_behavior(config)
  -- Default shell program
  -- Uncomment to override default shell:
  -- config.default_prog = { '/bin/bash', '-l' }

  -- Audible bell (disabled by default)
  config.audible_bell = "Disabled"

  -- Visual bell (flash)
  config.visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
    target = "CursorColor",
  }

  -- Enable scroll bar
  config.enable_scroll_bar = true

  -- Scroll behavior
  config.scrollback_lines = 5000

  -- Terminal input/output settings - using standard configurations
  config.enable_kitty_keyboard = false
  config.enable_kitty_graphics = true  -- Habilitado para yazi y image.nvim
  config.term = "xterm-256color"  -- Compatible con la mayoría de apps

  -- Key bindings and mouse settings - defaults
  config.send_composed_key_when_left_alt_is_pressed = true
  config.send_composed_key_when_right_alt_is_pressed = true
  config.disable_default_key_bindings = false
  config.bypass_mouse_reporting_modifiers = "SHIFT"
  config.disable_default_mouse_bindings = false
  config.allow_win32_input_mode = false

  -- Specialized configuration for macOS and international characters

  -- Fix Alt key behavior on macOS
  config.macos_forward_to_ime_modifier_mask = "NONE"
  config.use_ime = true

  -- Enable dead keys recognition for accents
  config.use_dead_keys = true

  -- Set hyperlink rules (orden importa - primero las más específicas)
  config.hyperlink_rules = {
    -- Standard URLs
    {
      regex = [[\b(https?://[\w-]+\.[a-z]{2,}[^\s]*)\b]],
      format = "$0",
    },
    -- PRIORIDAD: Paths con ~ (home directory) CON línea: ~/.../file.ext:123
    {
      regex = [[~[^\s:]+:[0-9]+]],
      format = "$0",
    },
    -- PRIORIDAD: Paths con ~ (home directory) SIN línea: ~/.../file.ext
    {
      regex = [[~[^\s:]+\.[a-zA-Z0-9]+]],
      format = "$0",
    },
    -- PRIORIDAD: Paths absolutos CON línea: /path/to/file.ext:123
    {
      regex = [[/[^\s:]+\.[a-zA-Z0-9]+:[0-9]+]],
      format = "$0",
    },
    -- PRIORIDAD: Paths absolutos SIN línea: /path/to/file
    {
      regex = [[/[^\s:]+\.[a-zA-Z0-9]+]],
      format = "$0",
    },
    -- Paths relativos con subdirectorios y línea: path/to/file.ext:123
    {
      regex = [[([a-zA-Z0-9_\-\.]+/[a-zA-Z0-9_/\-\.]+\.[a-zA-Z0-9]+):([0-9]+)]],
      format = "$0",
    },
    -- Paths relativos con subdirectorios: path/to/file.ext
    {
      regex = [[([a-zA-Z0-9_\-\.]+/[a-zA-Z0-9_/\-\.]+\.[a-zA-Z0-9]+)]],
      format = "$0",
    },
    -- Archivos simples con línea: filename.ext:123
    {
      regex = [[\b([a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9]+):([0-9]+)\b]],
      format = "$0",
    },
    -- Archivos simples: filename.ext (ÚLTIMA PRIORIDAD)
    {
      regex = [[\b([a-zA-Z0-9_\-\.]+\.[a-zA-Z0-9]+)\b]],
      format = "$0",
    },
  }
end

-- =============================================================================
-- PERFORMANCE AND RENDERING
-- =============================================================================

-- Configure performance-related settings
local function configure_performance(config)
  -- Animation and rendering performance
  config.animation_fps = 60
  config.max_fps = 120

  -- GPU rendering options
  config.front_end = "WebGpu"
  config.webgpu_power_preference = "HighPerformance"

  -- Cursor blink rate (0 to disable blinking)
  config.cursor_blink_rate = 500

  -- Text rendering refinements
  config.freetype_load_target = "HorizontalLcd"
end

-- =============================================================================
-- DOMAINS AND DEFAULT PROGRAMS
-- =============================================================================

-- Configure domains and default programs
local function configure_domains(config)
  -- Example for different domains (uncomment to use)
  -- config.unix_domains = {
  --   {
  --     name = "unix",
  --   },
  -- }

  -- Default domain
  -- config.default_domain = "unix"
end

-- =============================================================================
-- LAUNCH MENU — Tab types (CMD+SHIFT+T)
-- =============================================================================
-- Tres tipos de tab con roles distintos. Splits los hace WezTerm dentro de cada tab.
-- Regla: no mezclar splits de WezTerm y tmux en la misma tab.
--
--   Tab Local  → tmux local: sesiones que sobreviven al reinicio de WezTerm
--   Tab Remote → shell limpio: el usuario escribe `ssh host` y luego `tmux attach`
--   Tab Quick  → shell nativo: comandos one-off, git, sin overhead de tmux
--
local function configure_launch_menu(config)
  local shell = os.getenv("SHELL") or "zsh"
  config.launch_menu = {
    {
      label = "  Local — tmux (sesión persistente)",
      args  = { "tmux", "new-session", "-A", "-s", "local" },
    },
    {
      label = "  Remote — shell para SSH + tmux remoto",
      args  = { shell, "-l" },
    },
    {
      label = "  Quick shell — temporal, sin tmux",
      args  = { shell, "-l" },
    },
  }
end

-- =============================================================================
-- MISC OPTIONS
-- =============================================================================

-- Configure miscellaneous options
local function configure_misc(config)
  -- Show update notifications
  config.show_update_window = true

  -- When to close panes/tabs
  config.exit_behavior = "Close"  -- Always close, ignore exit codes
  -- Consider Ctrl+C (exit code 130) as clean exit
  config.clean_exit_codes = { 130 }

  -- Adjust underline position
  config.underline_position = -4

  -- Status update interval (milisegundos)
  -- Actualizar más frecuentemente para capturar cambios de workspace
  config.status_update_interval = 500  -- 0.5 segundos (default es 1000)

  -- Tab navigation wrapping (when you reach the end)
  config.tab_bar_style = {
    new_tab = wezterm.format({
      { Background = { Color = "#1e3a8a" } },
      { Foreground = { Color = "#ffffff" } },
      { Text = " + " },
    }),
  }
end

-- =============================================================================
-- SESIÓN PERSISTENTE
-- =============================================================================

-- Configurar la persistencia automática de sesiones
local function configure_session_persistence(config)
  -- Guardar automáticamente el estado de tabs y paneles
  -- Wezterm guarda la sesión en ~/.local/share/wezterm/
  config.automatically_reload_config = true

  -- Habilitar persistencia del estado del multiplexer (tabs, paneles, workspaces)
  -- Esto permite que wezterm recuerde todos los tabs y paneles al reiniciar
  config.mux_output_parser_buffer_size = 8192
end

-- =============================================================================
-- APPLY ALL GENERAL SETTINGS
-- =============================================================================

function M.apply_to_config(config)
  configure_terminal_behavior(config)
  configure_performance(config)
  configure_domains(config)
  configure_launch_menu(config)
  configure_misc(config)
  configure_session_persistence(config)
end

return M