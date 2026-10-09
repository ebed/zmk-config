local wezterm = require 'wezterm'
local icons   = require 'modules.icons'

local M = {}

-- Orden de prioridad para detección (clave -> función test)
-- Cada test devuelve icon, label si hay match, si no nil
local detectors = {
  -- Node ecosystem
  function(cwd, pane) return test_any(cwd, {
    'package.json', 'pnpm-lock.yaml', 'yarn.lock', 'bun.lockb'
  }, function(fname)
    if fname == 'bun.lockb' then return icons.bun, 'bun' end
    if exists(cwd, 'deno.json') or exists(cwd, 'deno.jsonc') then return icons.deno, 'deno' end
    return icons.node, 'node'
  end) end,

  -- Python
  function(cwd, pane)
    if any_exists(cwd, { 'pyproject.toml', 'requirements.txt', 'Pipfile', 'poetry.lock', '.venv' }) then
      return icons.python, 'python'
    end
  end,

  -- Go
  function(cwd, pane)
    if any_exists(cwd, { 'go.mod', 'go.sum' }) then
      return icons.go, 'go'
    end
  end,

  -- Rust
  function(cwd, pane)
    if any_exists(cwd, { 'Cargo.toml', 'Cargo.lock' }) then
      return icons.rust, 'rust'
    end
  end,

  -- Ruby
  function(cwd, pane)
    if any_exists(cwd, { 'Gemfile', '.ruby-version' }) then
      return icons.ruby, 'ruby'
    end
  end,

  -- Java/Kotlin (Gradle/Maven)
  function(cwd, pane)
    if any_exists(cwd, { 'build.gradle', 'build.gradle.kts', 'pom.xml' }) then
      -- Heuristic: if .kt files are prevalent, could choose kotlin; keeping Java neutral
      return icons.java, 'java'
    end
  end,

  -- PHP
  function(cwd, pane)
    if any_exists(cwd, { 'composer.json' }) then
      return icons.php, 'php'
    end
  end,

  -- Swift
  function(cwd, pane)
    if any_exists(cwd, { 'Package.swift' }) or dir_exists(cwd, '.swiftpm') then
      return icons.swift, 'swift'
    end
  end,

  -- Elixir
  function(cwd, pane)
    if any_exists(cwd, { 'mix.exs' }) then
      return icons.elixir, 'elixir'
    end
  end,

  -- Dart/Flutter
  function(cwd, pane)
    if any_exists(cwd, { 'pubspec.yaml' }) then
      if dir_exists(cwd, 'android') and dir_exists(cwd, 'ios') then
        return icons.flutter, 'flutter'
      end
      return icons.dart, 'dart'
    end
  end,

  -- C#/.NET
  function(cwd, pane)
    if glob_exists(cwd, '%.csproj$') or glob_exists(cwd, '%.sln$') then
      return icons.csharp, 'csharp'
    end
    if any_exists(cwd, { 'global.json' }) then
      return icons.dotnet, 'dotnet'
    end
  end,

  -- C/C++
  function(cwd, pane)
    if any_exists(cwd, { 'CMakeLists.txt' }) then
      return icons.cmake, 'cmake'
    end
    if any_exists(cwd, { 'Makefile' }) then
      return icons.make, 'make'
    end
    if glob_exists(cwd, '%.c$') or glob_exists(cwd, '%.cpp$') or glob_exists(cwd, '%.hpp$') then
      return icons.cpp, 'cpp'
    end
  end,

  -- Zig
  function(cwd, pane)
    if any_exists(cwd, { 'build.zig', 'zls.json' }) then
      return icons.zig, 'zig'
    end
  end,

  -- Terraform
  function(cwd, pane)
    if glob_exists(cwd, '%.tf$') or dir_exists(cwd, '.terraform') then
      return icons.terraform, 'terraform'
    end
  end,

  -- Docker
  function(cwd, pane)
    if any_exists(cwd, { 'Dockerfile', 'docker-compose.yml', 'compose.yaml' }) then
      return icons.docker, 'docker'
    end
  end,
}

-- Helper implementation using shell to avoid Lua IO on remote paths accidentally
local function run(cmd, cwd)
  local ok, out, _ = wezterm.run_child_process({ 'bash', '-lc', cmd }, { cwd = cwd })
  if not ok then return nil end
  return (out or ''):gsub('%s+$', '')
end

function exists(cwd, file)
  return run(string.format('[ -e %q ] && echo yes || true', file), cwd) == 'yes'
end

function dir_exists(cwd, dir)
  return run(string.format('[ -d %q ] && echo yes || true', dir), cwd) == 'yes'
end

function glob_exists(cwd, pattern)
  -- Use bash glob; returns yes if match found
  local cmd = string.format('shopt -s nullglob; for f in *; do [[ $f =~ %s ]] && { echo yes; break; }; done', pattern)
  return run(cmd, cwd) == 'yes'
end

function any_exists(cwd, files)
  for _, file in ipairs(files) do
    if exists(cwd, file) then
      return true
    end
  end
  return false
end

function test_any(cwd, files, callback)
  for _, file in ipairs(files) do
    if exists(cwd, file) then
      return callback(file)
    end
  end
  return nil
end

-- Cache
local CACHE, TTL = {}, 5

local function is_remote_pane(pane)
  -- Heuristic: if foreground process is ssh, assume remote
  local proc = pane and pane.foreground_process_name or ''
  proc = (proc and proc:match('([^/\\]+)$')) or ''
  proc = string.lower(proc or '')
  return proc == 'ssh' or proc == 'ssh.exe'
end

function M.detect(pane, cwd)
  if not cwd or cwd == '' then return nil end

  -- If user var TECH exists (from shell), always respect it (useful for SSH)
  local uv = pane and pane:get_user_vars() or {}
  if uv.TECH and uv.TECH ~= '' then
    -- Expects values like "node", "python", etc.
    local key = string.lower(uv.TECH)
    local icon = icons[key]
    if icon then return { icon = icon, key = key } end
  end

  -- Remote pane: avoid touching local FS
  if is_remote_pane(pane) then return nil end

  -- Cache
  local now = os.time()
  local c = CACHE[cwd]
  if c and (now - c.when) <= TTL then return c.data end

  -- Detection
  local found = nil
  for _, detector in ipairs(detectors) do
    local ok, icon, key = pcall(detector, cwd, pane)
    if ok and icon then
      found = { icon = icon, key = key }
      break
    end
  end

  CACHE[cwd] = { when = now, data = found }
  return found
end

return M
