-- =============================================================================
-- PROJECT DETECTION MODULE
-- =============================================================================
--
-- Automatically detects project type and provides contextual information
-- Integrates with tech.lua for technology detection
--
-- Author: ralbertomerinocolipe
-- Last update: 2026-01-26

local wezterm = require('wezterm')
local tech = require('modules.tech')
local git = require('modules.git')
local utils = require('utils.helpers')

local M = {}

-- Cache for project detection (avoid excessive filesystem calls)
local PROJECT_CACHE = {}
local CACHE_TTL = 30 -- seconds (increased from 5 for better performance)

-- Get project information from current working directory
local function get_project_info(pane)
  if not pane then return nil end

  -- Obtener CWD usando la API correcta de wezterm
  local cwd_uri = pane:get_current_working_dir()
  if not cwd_uri then return nil end

  -- Extraer el path del URI
  local cwd = cwd_uri.file_path or cwd_uri.path or tostring(cwd_uri)
  if not cwd or cwd == '' then return nil end

  -- Check cache
  local now = os.time()
  local cached = PROJECT_CACHE[cwd]
  if cached and (now - cached.when) <= CACHE_TTL then
    return cached.data
  end

  -- Detect technology
  local tech_info = tech.detect(pane, cwd)

  -- Detect git repository
  local git_info = git.info(cwd)

  -- Build project info
  local project = {
    cwd = cwd,
    tech = tech_info,
    git = git_info,
    name = utils.basename(cwd),
  }

  -- Cache result
  PROJECT_CACHE[cwd] = { when = now, data = project }

  return project
end

-- Apply project-specific configuration
function M.apply_to_config(config)
  -- This module doesn't directly modify config
  -- Instead, it provides utilities for other modules to use
  wezterm.log_info('Project detection module loaded')
end

-- Export utility function
M.get_project_info = get_project_info

return M
