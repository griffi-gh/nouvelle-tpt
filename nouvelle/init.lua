local runtimes = require(.....'.runtimes')

local manager = {}

function manager:init()  
  print("Nouvelle manager")
end

return function()
  manager:init()
end

