local RuntimeManager = require(.....'.runtimes')

local nv_config = {
  path = "./nouvelle/",
  lib_path = "./nouvelle-native/",
  runtime_path = "./nouvelle-runtimes/",
}

local Nouvelle = {}
Nouvelle.__index = Nouvelle

function Nouvelle:new()
  return setmetatable({
    runtime_manager = RuntimeManager:new(),
    --loader = 
  }, self)
end

function Nouvelle:init() 
  log("Init Nouvelle...")
  self.runtime_manager:load_runtimes(nv_config)
  return self
end

return function()
  log("[*] Init process started")
  local time = os.clock()
  local nouvelle = Nouvelle:new():init()
  rawset(_G, "NOUVELLE", nouvelle)
  time = os.clock() - time
  logf("[*] Done in %.2f s", time)
  nouvelle.runtime_manager.runtimes.luajit:new():load("error('hi')"):run()
end
