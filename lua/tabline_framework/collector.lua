local Collector = {}
Collector.__index = Collector

function Collector:add(item)
  table.insert(self, item)
end

Collector.__call = function()
  return setmetatable({}, Collector)
end

return setmetatable({}, Collector)
