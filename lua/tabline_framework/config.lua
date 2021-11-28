local Config = {data = {}}

Config.new = function(t, tbl) rawset(t, 'data', tbl) end

Config.merge = function(t, tbl)
  for k, v in pairs(tbl) do
    rawget(t, 'data')[k] = v
  end
end

functions = {
  new = true,
  merge = true
}

return setmetatable(Config, {
  __index = function(t, k)
    if functions[k] then
      return rawget(t, k)
    else
      return rawget(t, 'data')[k]
    end
  end,
  __newindex = function(t, k, v) rawget(t, 'data')[k] = v end,
})
