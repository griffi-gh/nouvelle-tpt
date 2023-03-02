assert(_G.BOOTSTRAP, "Loaded without bootstrap script")

local RuntimeManager = require(.....'.runtimes')

local nv_config = { ---@class NvConfig
  path = "./nouvelle/",
  mod_path = "./Mods/",
  lib_path = "./nouvelle-native/",
  runtime_path = "./nouvelle-runtimes/",
}

---@class Nouvelle
---@field public runtime_manager RuntimeManager
local Nouvelle = {}
Nouvelle.__index = Nouvelle

function Nouvelle:new() ---@return Nouvelle
  local nouvelle = { ---@type Nouvelle
    runtime_manager = RuntimeManager:new(),
  }
  return setmetatable(nouvelle, self)
end

function Nouvelle:init() ---@return Nouvelle
  log("Init Nouvelle...")
  logtab()
  self.runtime_manager:load_runtimes(nv_config)
  logtab(-1)
  return self
end

return function()
  log("[*] Init process started")
  logtab()
  local time = os.clock()
  local nouvelle = Nouvelle:new():init()
  rawset(_G, "NOUVELLE", nouvelle)
  time = os.clock() - time
  logtab(-1)
  logf("[*] Done in %.2f s", time)
  nouvelle.runtime_manager.runtimes.luajit:new():load("error('Hello world')"):run()
end
