-- =============================================================================
-- UTILITY HELPER FUNCTIONS
-- =============================================================================
--
-- This module provides utility functions that can be used across the configuration
-- Author: ralbertomerinocolipe
-- Last update: 2024-01-08

local wezterm = require 'wezterm'

local M = {}

-- -----------------------------------------------------------------------------
-- PATH HELPERS
-- -----------------------------------------------------------------------------

-- Extract the last component of a path (directory or file name)
function M.basename(path)
  if not path then return nil end
  return path:match("([^/]+)$") or path
end

-- Get home directory with trailing slash
function M.get_home()
  return os.getenv("HOME") .. "/"
end

-- Check if path is in home directory and return ~ version if it is
function M.tilde_path(path)
  if not path then return nil end
  local home = M.get_home()
  if path:sub(1, #home) == home then
    return "~" .. path:sub(#home)
  end
  return path
end

-- -----------------------------------------------------------------------------
-- PROCESS HELPERS
-- -----------------------------------------------------------------------------

-- Get current process name from pane
function M.get_process_name(pane)
  if not pane then return "wezterm" end

  local process_name = "wezterm"
  if pane:get_foreground_process_name() then
    local full_process = pane:get_foreground_process_name()
    process_name = full_process:match("([^/]+)$") or ""
    process_name = process_name:lower()
  end

  return process_name
end

-- Check if a process is a shell
function M.is_shell(process_name)
  local shells = {
    bash = true,
    zsh = true,
    fish = true,
    sh = true,
    dash = true,
    ksh = true,
    csh = true
  }
  return shells[process_name] or false
end

-- -----------------------------------------------------------------------------
-- COLOR HELPERS
-- -----------------------------------------------------------------------------

-- Brighten color by amount (0.0 - 1.0)
function M.brighten_color(color, amount)
  return wezterm.color.brighten(color, amount)
end

-- Darken color by amount (0.0 - 1.0)
function M.darken_color(color, amount)
  return wezterm.color.darken(color, amount)
end

-- -----------------------------------------------------------------------------
-- LOGGING AND DEBUGGING
-- -----------------------------------------------------------------------------

-- Debug log to file and console
function M.debug(message)
  wezterm.log_info(message)

  -- Also log to file if desired
  -- local log_file = M.get_home() .. ".config/wezterm/debug.log"
  -- local file = io.open(log_file, "a")
  -- if file then
  --   local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  --   file:write(timestamp .. " - " .. message .. "\n")
  --   file:close()
  -- end
end

return M