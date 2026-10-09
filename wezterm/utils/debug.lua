-- =============================================================================
-- DEBUG UTILITIES
-- =============================================================================
--
-- Este módulo proporciona utilidades para depuración de la configuración de WezTerm
-- Author: ralbertomerinocolipe
--

local wezterm = require('wezterm')

local M = {}

-- Archivo de log para depuración
local log_file = os.getenv("HOME") .. "/.config/wezterm/debug.log"

-- Log mensaje de inicio inmediatamente
wezterm.log_info("Módulo de depuración inicializado en " .. os.date("%Y-%m-%d %H:%M:%S"))

-- Intentar escribir mensaje de inicialización al archivo
local init_file = io.open(log_file, "a")
if init_file then
  init_file:write("=== Módulo de depuración inicializado: " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===\n")
  init_file:close()
end

-- Asegurarse de que el archivo de log exista
local function ensure_log_file_exists()
  local test = io.open(log_file, "r")
  if not test then
    -- Intentar crear el archivo
    local create = io.open(log_file, "w")
    if create then
      create:write("=== Log iniciado: " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===\n")
      create:close()
      return true
    else
      -- No se pudo crear, loguear a la consola solamente
      wezterm.log_error("No se pudo crear el archivo de log: " .. log_file)
      return false
    end
  else
    test:close()
    return true
  end
end

-- Función para registrar mensajes en el archivo de log
function M.log(message, value)
  -- Asegurarse de que el archivo existe
  local file_exists = ensure_log_file_exists()

  -- Formatear el mensaje
  local timestamp = os.date("%Y-%m-%d %H:%M:%S")
  local msg = timestamp .. " - " .. tostring(message)

  if value ~= nil then
    if type(value) == "table" then
      msg = msg .. ": " .. M.table_to_string(value)
    else
      msg = msg .. ": " .. tostring(value)
    end
  end

  -- Siempre registrar en la consola de WezTerm
  wezterm.log_info(msg)

  -- Intentar escribir en el archivo si existe
  if file_exists then
    local file = io.open(log_file, "a")
    if file then
      file:write(msg .. "\n")
      file:close()
    end
  end
end

-- Limpia el archivo de log
function M.clear_log()
  local file = io.open(log_file, "w")
  if file then
    file:write("=== Log limpiado: " .. os.date("%Y-%m-%d %H:%M:%S") .. " ===\n")
    file:close()
  end
end

-- Convierte una tabla a string para logging
function M.table_to_string(tbl, indent)
  if not indent then indent = 0 end
  local result = "{\n"

  for k, v in pairs(tbl) do
    result = result .. string.rep("  ", indent + 1)

    if type(k) == "string" then
      result = result .. k .. " = "
    else
      result = result .. "[" .. tostring(k) .. "] = "
    end

    if type(v) == "table" then
      result = result .. M.table_to_string(v, indent + 1)
    elseif type(v) == "string" then
      result = result .. '"' .. v .. '"'
    else
      result = result .. tostring(v)
    end

    result = result .. ",\n"
  end

  result = result .. string.rep("  ", indent) .. "}"
  return result
end

-- Inspecciona un objeto pane y registra sus propiedades
function M.inspect_pane(pane, label)
  label = label or "Pane"
  M.log(label .. " - Inspeccionando pane")

  -- Verificar si el pane existe
  if not pane then
    M.log(label .. " - El pane es nil")
    return
  end

  -- Registrar tipo de objeto
  M.log(label .. " - Tipo", type(pane))

  -- Intentar acceder a métodos comunes y registrar resultados
  local methods = {
    "get_current_working_dir",
    "get_title",
    "get_foreground_process_name",
    "get_user_vars",
    "get_domain_name"
  }

  for _, method in ipairs(methods) do
    M.log(label .. " - Verificando método: " .. method)

    local success, result = pcall(function()
      if pane[method] then
        local fn_result = pane[method](pane)
        return fn_result
      else
        return "método no encontrado"
      end
    end)

    if success then
      M.log(label .. " - " .. method, result)
    else
      M.log(label .. " - Error en " .. method, result)
    end
  end
end

return M