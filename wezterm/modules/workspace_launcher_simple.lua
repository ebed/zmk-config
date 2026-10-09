-- Workspace Launcher - Simplified Version
-- Creates workspaces by opening tabs with keyboard shortcuts

local wezterm = require("wezterm")
local act = wezterm.action

local M = {}

-- Workspace templates with simple tab definitions
M.workspace_templates = {
  {
    name = "Claude Dev",
    icon = "🤖",
    description = "3 tabs: Claude Code + Neovim + Tests",
    tab_count = 3,
    tab_titles = { "🤖 Claude", "💻 Code", "🧪 Test" },
    tab_commands = { nil, "nvim", nil },
  },
  {
    name = "Full Stack",
    icon = "🚀",
    description = "4 tabs: Backend + Frontend + Database + Logs",
    tab_count = 4,
    tab_titles = { "🔧 Backend", "🎨 Frontend", "🗄️  Database", "📊 Logs" },
    tab_commands = { nil, nil, nil, nil },
  },
  {
    name = "Simple Dev",
    icon = "💻",
    description = "2 tabs: Editor + Terminal",
    tab_count = 2,
    tab_titles = { "💻 Editor", "🖥️  Terminal" },
    tab_commands = { "nvim", nil },
  },
  {
    name = "DevOps",
    icon = "⚙️",
    description = "3 tabs: Deploy + Monitor + Logs",
    tab_count = 3,
    tab_titles = { "🚀 Deploy", "📊 Monitor", "📝 Logs" },
    tab_commands = { nil, nil, nil },
  },
}

-- Recent projects
M.recent_projects = {
  { name = "Config", path = wezterm.home_dir .. "/.config" },
  { name = "Home", path = wezterm.home_dir },
}

-- Load recent projects from file
function M.load_recent_projects()
  local config_dir = wezterm.home_dir .. "/.config/wezterm"
  local recent_file = config_dir .. "/.recent_projects"

  local f = io.open(recent_file, "r")
  if f then
    local projects = {}
    for line in f:lines() do
      local name, path = line:match("^(.+)|(.+)$")
      if name and path then
        table.insert(projects, { name = name, path = path })
      end
    end
    f:close()

    if #projects > 0 then
      M.recent_projects = projects
    end
  end
end

-- Save recent project
function M.save_recent_project(name, path)
  local config_dir = wezterm.home_dir .. "/.config/wezterm"
  local recent_file = config_dir .. "/.recent_projects"

  M.load_recent_projects()

  local exists = false
  for _, proj in ipairs(M.recent_projects) do
    if proj.path == path then
      exists = true
      break
    end
  end

  if not exists then
    table.insert(M.recent_projects, 1, { name = name, path = path })
    while #M.recent_projects > 10 do
      table.remove(M.recent_projects)
    end

    local f = io.open(recent_file, "w")
    if f then
      for _, proj in ipairs(M.recent_projects) do
        f:write(proj.name .. "|" .. proj.path .. "\n")
      end
      f:close()
    end
  end
end

-- Create workspace using simple approach
function M.create_workspace(window, pane, template, project_dir)
  local mux = wezterm.mux

  -- Set workspace name
  local dir_name = project_dir:match("([^/]+)$") or "Project"
  local workspace_name = dir_name .. " (" .. template.name .. ")"

  wezterm.log_info("Creating workspace: " .. workspace_name)

  -- Get current window and tab info
  local current_mux_window = window:mux_window()
  local current_tab = current_mux_window:active_tab()
  local current_tab_id = current_tab:tab_id()

  -- Create first tab in NEW workspace
  local tab1, pane1, new_window = mux.spawn_tab({
    workspace = workspace_name,
    cwd = project_dir,
  })

  if not tab1 then
    wezterm.log_error("Failed to create first tab")
    return
  end

  -- Set title for first tab
  tab1:set_title(template.tab_titles[1])

  -- Send command for first tab
  if template.tab_commands[1] then
    pane1:send_text("cd " .. wezterm.shell_quote_arg(project_dir) .. "\n")
    pane1:send_text(template.tab_commands[1] .. "\n")
  else
    pane1:send_text("cd " .. wezterm.shell_quote_arg(project_dir) .. "\nclear\n")
  end

  wezterm.log_info("Created tab 1: " .. template.tab_titles[1])

  -- Create remaining tabs in the same window
  for i = 2, template.tab_count do
    local tab, new_pane = new_window:spawn_tab({ cwd = project_dir })

    if tab and new_pane then
      -- Set tab title
      tab:set_title(template.tab_titles[i])

      -- Send command if specified
      if template.tab_commands[i] then
        new_pane:send_text("cd " .. wezterm.shell_quote_arg(project_dir) .. "\n")
        new_pane:send_text(template.tab_commands[i] .. "\n")
      else
        new_pane:send_text("cd " .. wezterm.shell_quote_arg(project_dir) .. "\nclear\n")
      end

      wezterm.log_info("Created tab " .. i .. ": " .. template.tab_titles[i])
    else
      wezterm.log_error("Failed to create tab " .. i)
    end
  end

  -- Activate first tab
  tab1:activate()

  -- Close the original tab from the old workspace (después de crear todo)
  wezterm.time.call_after(0.5, function()
    -- Find and close the old tab
    for _, tab in ipairs(current_mux_window:tabs()) do
      if tab:tab_id() == current_tab_id then
        pcall(function()
          tab:close()
        end)
        break
      end
    end
  end)

  -- Save to recent
  M.save_recent_project(dir_name, project_dir)

  wezterm.log_info("Workspace created successfully: " .. workspace_name)
end

-- Show workspace selector
function M.show_workspace_selector()
  return act.InputSelector({
    title = "🚀 WezTerm Workspace Launcher",
    choices = {
      { label = "📂 Choose Recent Project" },
      { label = "➕ New Project (choose directory)" },
      { label = "🏠 Current Directory" },
      { label = "❌ Cancel (default terminal)" },
    },
    fuzzy = false,
    action = wezterm.action_callback(function(window, pane, id, label)
      if label == "📂 Choose Recent Project" then
        M.show_recent_projects_selector(window, pane)
      elseif label == "➕ New Project (choose directory)" then
        M.show_new_project_prompt(window, pane)
      elseif label == "🏠 Current Directory" then
        local cwd_uri = pane:get_current_working_dir()
        local cwd = cwd_uri and (cwd_uri.file_path or cwd_uri.path or tostring(cwd_uri)) or wezterm.home_dir
        M.show_template_selector(window, pane, cwd)
      end
    end),
  })
end

-- Show recent projects
function M.show_recent_projects_selector(window, pane)
  M.load_recent_projects()

  local choices = {}
  for _, proj in ipairs(M.recent_projects) do
    table.insert(choices, {
      label = proj.name .. " (" .. proj.path .. ")",
      id = proj.path,
    })
  end

  if #choices == 0 then
    table.insert(choices, { label = "No recent projects found" })
  end

  window:perform_action(
    act.InputSelector({
      title = "📂 Recent Projects",
      choices = choices,
      fuzzy = true,
      action = wezterm.action_callback(function(window, pane, id, label)
        if id then
          M.show_template_selector(window, pane, id)
        end
      end),
    }),
    pane
  )
end

-- Show template selector
function M.show_template_selector(window, pane, project_dir)
  local choices = {}
  for _, template in ipairs(M.workspace_templates) do
    table.insert(choices, {
      label = template.icon .. " " .. template.name .. " - " .. template.description,
      id = template.name,
    })
  end

  window:perform_action(
    act.InputSelector({
      title = "🎨 Choose Workspace Template",
      choices = choices,
      fuzzy = false,
      action = wezterm.action_callback(function(window, pane, id, label)
        if id then
          for _, template in ipairs(M.workspace_templates) do
            if template.name == id then
              M.create_workspace(window, pane, template, project_dir)
              break
            end
          end
        end
      end),
    }),
    pane
  )
end

-- Show new project prompt
function M.show_new_project_prompt(window, pane)
  window:perform_action(
    act.PromptInputLine({
      description = "Enter project path:",
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= "" then
          local path = line:gsub("^~", wezterm.home_dir)
          local f = io.open(path, "r")
          if f then
            f:close()
            M.show_template_selector(window, pane, path)
          else
            window:toast_notification("WezTerm", "Directory not found: " .. path, nil, 4000)
          end
        end
      end),
    }),
    pane
  )
end

-- Keybinding
function M.get_keybinding()
  return {
    key = "L",
    mods = "CMD|SHIFT",
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(M.show_workspace_selector(), pane)
    end),
  }
end

return M
