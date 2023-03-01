local ModLoader = {}
ModLoader.__index = ModLoader

function ModLoader:new()
  return setmetatable({
    mods = {}
  }, self)
end

return ModLoader
