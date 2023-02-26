local runtimes = require(.....'.runtimes')

local manager = {}
manager.__index = manager

function manager:init()
  return setmetatable({
    runtimes = runtimes:init()
  }, self)
end

return function()
  print("Nouvelle manager")
  local man = manager:init()
  man.runtimes:require_native("luajit", "nouvelle-lib")
end
