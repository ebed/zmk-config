local wezterm = require 'wezterm'

local CACHE = {}
local TTL = 2 -- seconds

local function run(cmd, cwd)
  local ok, out, _ = wezterm.run_child_process({ 'bash', '-lc', cmd }, { cwd = cwd })
  if not ok then return nil end
  if not out then return '' end
  return (out:gsub('%s+$', ''))
end

local M = {}

function M.info(cwd)
  if cwd == '' then return nil end
  local now = os.time()
  local c = CACHE[cwd]
  if c and (now - c.when) <= TTL then
    return c.data
  end

  local inside = run('git rev-parse --is-inside-work-tree 2>/dev/null', cwd)
  if inside ~= 'true' then
    CACHE[cwd] = { when = now, data = nil }
    return nil
  end

  local branch = run('git rev-parse --abbrev-ref HEAD 2>/dev/null', cwd)
  local dirty  = run('git status --porcelain 2>/dev/null | head -n1', cwd)
  local ab     = run('git rev-list --left-right --count HEAD...@{upstream} 2>/dev/null', cwd)
  local ahead, behind = 0, 0
  if ab and ab ~= '' then
    local a, b = ab:match('(%d+)%s+(%d+)')
    ahead  = tonumber(a or '0') or 0
    behind = tonumber(b or '0') or 0
  end

  local data = {
    branch = branch,
    dirty  = (dirty and dirty ~= ''),
    ahead  = ahead,
    behind = behind,
  }
  CACHE[cwd] = { when = now, data = data }
  return data
end

return M
