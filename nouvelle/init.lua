assert(_G.BOOTSTRAP, "launched without bootstrap!")

local runtimes = require(.....'.runtimes')

local PATH_NOUVELLE = "./nouvelle/"
local PATH_LIB = "./nouvelle-lib/"
local PATH_RUNTIMES = "./nouvelle-runtimes/"

local Nouvelle = {}
Nouvelle.__index = Nouvelle

function Nouvelle:init()
  return setmetatable({
    runtimes = runtimes:init(PATH_RUNTIMES, PATH_LIB)
  }, self)
end

return function()
  print("Nouvelle manager")
  Nouvelle:init()
end
