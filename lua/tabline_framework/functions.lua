local functions = {}
local functions_index = 0

local function clear()
  for k, _ in pairs(functions) do functions[k] = nil end
  functions_index = 0
end

local function register(callback)
  functions_index = functions_index + 1
  local name = 'fn_nr_' .. functions_index
  functions[name] = callback
  return [[v:lua.require'tabline_framework.functions'.functions.]] .. name
end

return {
  clear = clear,
  register = register,
  functions = functions,
  functions_index = functions_index
}
