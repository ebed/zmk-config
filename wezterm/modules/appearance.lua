local wezterm = require('wezterm')
local utils = require('utils.helpers')

local M = {}

-- =============================================================================
-- COLOR SCHEME
-- =============================================================================
local function configure_colors(config)
  -- Desactivo temporalmente color_scheme para que inactive_pane_hsb funcione
  -- config.color_scheme = 'Catppuccin Frappe'

  config.colors = {
    tab_bar = {
      background = "rgba(30, 58, 138, 0.5)",  -- Tab bar más transparente (antes 0.8)
      active_tab = { bg_color = "rgba(59, 130, 246, 0.7)", fg_color = "#ffffff" },  -- Tab activo semi-transparente
      inactive_tab = { bg_color = "rgba(30, 58, 138, 0.3)", fg_color = "#d8dee9" },  -- Tabs inactivos más transparentes
    },
    -- Bordes de paneles - color brillante y muy visible
    split = "#3b82f6",  -- Azul brillante para bordes de paneles

    -- Colores básicos del terminal - Mayor opacidad para mejor legibilidad
    foreground = "#eceff4",  -- Texto más brillante (blanco-azulado)
    background = "rgba(46, 52, 64, 0.95)",  -- Fondo más opaco (95%) para mejor contraste
  }
end

-- =============================================================================
-- FONTS
-- =============================================================================
local function configure_fonts(config)
  -- Terminal buffer font con peso más visible
  config.font = wezterm.font_with_fallback({
    { family = 'JetBrains Mono', weight = 'DemiBold' },  -- Peso más grueso para mejor legibilidad
    { family = 'JetBrainsMono Nerd Font', weight = 'DemiBold' },
  })
  config.font_size = 20.0

  -- Tab bar and window title font
  config.window_frame = {
    font = wezterm.font_with_fallback({
      { family = 'JetBrains Mono', weight = 'Bold' },
      { family = 'JetBrainsMono Nerd Font', weight = 'Bold' },
    }),
    font_size = 20.0,  -- Unified font size
    -- Titlebar con opacidad consistente (95%)
    active_titlebar_bg = "rgba(46, 52, 64, 0.95)",
    inactive_titlebar_bg = "rgba(59, 66, 82, 0.95)",
    active_titlebar_fg = "#eceff4",
    inactive_titlebar_fg = "#d8dee9",
    active_titlebar_border_bottom = "rgba(94, 129, 172, 0.5)",
    inactive_titlebar_border_bottom = "rgba(76, 86, 106, 0.5)",
    button_fg = "#eceff4",
    button_bg = "rgba(46, 52, 64, 0.95)",
  }

  config.harfbuzz_features = { 'calt=1', 'liga=1' }
end

-- =============================================================================
-- WINDOW APPEARANCE
-- =============================================================================
local function configure_window(config)
  -- Decoraciones integradas - botones arriba, tabs abajo
  config.window_decorations = "INTEGRATED_BUTTONS|RESIZE"

  config.window_padding = { left = 80, right = 12, top = 8, bottom = 12 }  -- Más espacio para botones
  config.window_background_opacity = 0.95  -- Mayor opacidad para mejor legibilidad del texto
  config.macos_window_background_blur = 20  -- Blur moderado

  -- Forzar que el fondo de la ventana use transparencia
  config.text_background_opacity = 1.0  -- Texto 100% opaco para legibilidad
  config.initial_cols = 120
  config.initial_rows = 30
  config.default_cursor_style = "SteadyBlock"
  config.cursor_blink_rate = 500

  -- Configuración de tab bar
  -- IMPORTANTE: fancy_tab_bar = true permite custom formatting
  -- Con false, WezTerm usa pane.title directamente (ignora format-tab-title)
  config.use_fancy_tab_bar = true   -- Habilitar custom tab formatting
  config.tab_bar_at_bottom = true   -- Tabs abajo
  config.enable_tab_bar = true
  config.show_tabs_in_tab_bar = true
  config.show_new_tab_button_in_tab_bar = true
  config.hide_tab_bar_if_only_one_tab = false

  -- Resaltar panel activo vs inactivos
  -- VALORES ULTRA EXTREMOS para asegurar que se note
  config.inactive_pane_hsb = {
    hue = 1.0,
    saturation = 0.0, -- TOTALMENTE sin color (blanco y negro)
    brightness = 0.2, -- CASI NEGRO
  }

  -- Configuración de selección de paneles (muestra bordes al cambiar)
  config.pane_select_bg_color = "#3b82f6"
  config.pane_select_fg_color = "#ffffff"
end

-- =============================================================================
-- TEXT RENDERING
-- =============================================================================
local function configure_text_rendering(config)
  config.freetype_render_target = "HorizontalLcd"
  config.freetype_load_target = "Normal"  -- Renderizado más nítido
  config.allow_square_glyphs_to_overflow_width = "WhenFollowedBySpace"
  config.treat_east_asian_ambiguous_width_as_wide = false

  -- Mejorar contraste y nitidez del texto
  config.bold_brightens_ansi_colors = true  -- Texto bold más brillante
  config.custom_block_glyphs = true  -- Mejor renderizado de caracteres de bloque
end

function M.apply_to_config(config)
  configure_colors(config)
  configure_fonts(config)
  configure_window(config)
  configure_text_rendering(config)
end

return M
