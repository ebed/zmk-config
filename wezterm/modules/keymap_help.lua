-- =============================================================================
-- KEYMAP HELP MODULE
-- =============================================================================
--
-- Muestra una ventana de ayuda con todos los atajos de teclado configurados
-- Se activa con Cmd+Shift+?
--
-- Author: ralbertomerinocolipe
-- Last update: 2026-03-31

local wezterm = require('wezterm')
local act = wezterm.action

local M = {}

-- Contenido de la ayuda con todos los keymaps organizados por categoría
local help_text = [[
╔═══════════════════════════════════════════════════════════════════════════╗
║                    WEZTERM - ATAJOS DE TECLADO                           ║
╚═══════════════════════════════════════════════════════════════════════════╝

┌─────────────────────────────────────────────────────────────────────────┐
│ 📑 GESTIÓN DE TABS                                                       │
├─────────────────────────────────────────────────────────────────────────┤
│  Cmd+T                    → Nuevo tab                                   │
│  Cmd+W                    → Cerrar tab                                  │
│  Cmd+1-9                  → Ir a tab específico (1-8, 9=último)         │
│  Cmd+[                    → Tab anterior                                │
│  Cmd+]                    → Tab siguiente                               │
│  Cmd+Shift+[              → Mover tab a la izquierda                    │
│  Cmd+Shift+]              → Mover tab a la derecha                      │
│  Cmd+Shift+M              → Launcher (mover tabs entre ventanas)        │
│  Cmd+Shift+E              → Navegador visual de tabs                    │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ ⚡ GESTIÓN DE PANELES (SPLITS)                                           │
├─────────────────────────────────────────────────────────────────────────┤
│  Cmd+D / Cmd+Enter        → Dividir horizontal                          │
│  Cmd+Shift+D / Cmd+Shift+Enter → Dividir vertical                       │
│  Opt+D                    → Dividir horizontal (alternativo)            │
│  Opt+Shift+D              → Dividir vertical (alternativo)              │
│  Cmd+\ o Cmd+|            → Dividir horizontal/vertical                 │
│                                                                          │
│  Cmd+W / Cmd+X            → Cerrar panel                                │
│  Opt+X                    → Cerrar panel (alternativo)                  │
│                                                                          │
│  Cmd+Flechas              → Navegar entre paneles                       │
│  Opt+Flechas              → Navegar entre paneles (alternativo)         │
│  Opt+H/J/K/L              → Navegar estilo Vim                          │
│                                                                          │
│  Cmd+Z / Opt+Z            → Maximizar/restaurar panel (zoom)            │
│  Cmd+Shift+P              → Selector interactivo de paneles             │
│  Cmd+Shift+Opt+P          → Selector para intercambiar paneles          │
│                                                                          │
│  Cmd+Opt+Flechas          → Redimensionar panel                         │
│  Cmd+Shift+R              → Rotar paneles (sentido horario)             │
│  Cmd+Shift+Opt+R          → Rotar paneles (antihorario)                 │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 🏢 WORKSPACES Y SESIONES                                                 │
├─────────────────────────────────────────────────────────────────────────┤
│  Cmd+Shift+O              → Selector de workspaces                      │
│  Cmd+Shift+N              → Crear nuevo workspace                       │
│  Cmd+Shift+Opt+S          → Guardar sesión con nombre                   │
│  Cmd+Shift+Opt+L          → Listar y restaurar sesiones                 │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 📝 TEXTO Y CLIPBOARD                                                     │
├─────────────────────────────────────────────────────────────────────────┤
│  Cmd+C                    → Copiar                                      │
│  Cmd+V                    → Pegar                                       │
│  Cmd+F                    → Buscar en el terminal                       │
│  Cmd+K                    → Limpiar pantalla                            │
│  Cmd+Shift+S              → Quick select (seleccionar paths, URLs)      │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│ 🔧 UTILIDADES                                                            │
├─────────────────────────────────────────────────────────────────────────┤
│  Cmd+Shift+P              → Command Palette (paleta de comandos)        │
│  Cmd+Shift+R              → Recargar configuración                      │
│  Cmd+Shift+F              → Pantalla completa                           │
│  Cmd+ +/-/0               → Aumentar/reducir/resetear tamaño fuente     │
│  F1 / Cmd+Shift+H         → Mostrar esta ayuda                          │
└─────────────────────────────────────────────────────────────────────────┘

  Presiona ESC o Q, o cierra el tab con Cmd+W para salir
]]

-- Guardar archivo de ayuda permanente
local function save_help_file()
  local help_file = wezterm.home_dir .. '/.config/wezterm/KEYMAPS.txt'
  local f = io.open(help_file, "w")
  if f then
    f:write(help_text)
    f:close()
  end
  return help_file
end

-- Crear un nuevo tab temporal con la ayuda
local function show_help(window, pane)
  -- Guardar archivo de ayuda
  local help_file = save_help_file()

  -- Abrir el archivo en un nuevo tab con less
  window:perform_action(
    act.SpawnCommandInNewTab {
      args = { 'less', '-R', help_file },
    },
    pane
  )
end

function M.apply_to_config(config)
  -- Agregar el keymap para mostrar la ayuda
  config.keys = config.keys or {}

  -- F1 - El atajo universal para ayuda
  table.insert(config.keys, {
    key = 'F1',
    mods = '',
    action = wezterm.action_callback(show_help),
  })

  -- Cmd+Shift+H - Alternativa (H de Help)
  table.insert(config.keys, {
    key = 'H',
    mods = 'CMD|SHIFT',
    action = wezterm.action_callback(show_help),
  })

  wezterm.log_info('Keymap help module loaded')
end

return M
