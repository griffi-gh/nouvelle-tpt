local runtimes = require(.....'.runtimes')

local manager = {}

function manager:init()  
  print("Nouvelle manager")
  runtimes.init_runtimes()
end

return function()
  manager:init()
end
