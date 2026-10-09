-- WezTerm Workspace optimizado para Claude Code con Chat History visible
-- Layout: Claude + Chat History arriba, Neovim workspace abajo
-- Uso: wezterm start --workspace ClaudeOptimized

local wezterm = require("wezterm")
local mux = wezterm.mux

local M = {}

-- Detectar ubicación del chat history
local function get_chat_history_path()
  local home = wezterm.home_dir

  -- Posibles ubicaciones del chat history (ordenadas por probabilidad)
  local locations = {
    home .. "/.config/wezterm/.claude/chat_history.md", -- Claude Code en wezterm
    home .. "/.claude/chat_history.md",
    home .. "/.local/share/claude/chat_history.md",
    home .. "/.local/state/claude/chat_history.md",
  }

  -- Buscar el archivo que existe
  for _, path in ipairs(locations) do
    local file = io.open(path, "r")
    if file then
      file:close()
      wezterm.log_info("Found chat history at: " .. path)
      return path
    end
  end

  -- Fallback: usar la ubicación más común
  wezterm.log_warn("Chat history not found, using default location")
  return home .. "/.config/wezterm/.claude/chat_history.md"
end

-- Setup del workspace optimizado
function M.setup_claude_optimized_workspace(project_dir)
  project_dir = project_dir or wezterm.home_dir

  wezterm.on("gui-startup", function(cmd)
    local args = cmd or {}
    if args.workspace and args.workspace == "ClaudeOptimized" then
      M.create_workspace(project_dir)
    end
  end)
end

function M.create_workspace(project_dir)
  -- Crear ventana principal
  local tab, pane_claude, window = mux.spawn_window({
    workspace = "ClaudeOptimized",
    cwd = project_dir,
  })
  tab:set_title("🤖 Claude Dev")

  -- ===================================================================
  -- LAYOUT SUPERIOR: Claude Code (izq) + Chat History (der)
  -- ===================================================================

  -- Split vertical (izquierda/derecha) - 50/50
  local pane_chat_history = pane_claude:split({
    direction = "Right",
    size = 0.5,
    cwd = project_dir,
  })

  -- Lanzar nvim con chat history en el pane derecho
  local chat_history_path = get_chat_history_path()
  pane_chat_history:send_text(string.format("nvim '%s'\n", chat_history_path))

  -- ===================================================================
  -- LAYOUT INFERIOR: Neovim Workspace
  -- ===================================================================

  -- Split horizontal (arriba/abajo) desde el pane de Claude
  local pane_nvim = pane_claude:split({
    direction = "Bottom",
    size = 0.5,
    cwd = project_dir,
  })

  -- Lanzar nvim en el pane inferior
  pane_nvim:send_text("nvim\n")

  -- Activar el pane de Claude (arriba izquierda)
  pane_claude:activate()

  wezterm.log_info("Claude Optimized Workspace created successfully")
end

-- Keybinding para lanzar el workspace rápidamente
-- CMD+CTRL+L (L de Layout)
function M.get_keybinding()
  return {
    key = "L",
    mods = "CMD|CTRL",
    action = wezterm.action_callback(function(window, pane)
      -- Obtener el directorio actual
      local cwd = pane:get_current_working_dir()
      local project_dir = wezterm.home_dir

      if cwd and cwd.file_path then
        project_dir = cwd.file_path:gsub("^file://[^/]*", "")
      end

      -- Crear el workspace con el directorio actual
      M.create_workspace(project_dir)
    end),
  }
end

-- Comando para crear workspace desde launcher
function M.launcher_item(project_name, project_path)
  project_name = project_name or "Default"
  project_path = project_path or wezterm.home_dir

  return {
    label = "🎯 Claude Optimized: " .. project_name,
    args = { "bash", "-c", string.format("cd '%s' && exec $SHELL", project_path) },
    workspace = "ClaudeOptimized_" .. project_name,
  }
end

return M
