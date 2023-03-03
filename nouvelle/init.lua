local Bootstrap = require('bootstrap')
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
  Bootstrap:log("Init Nouvelle...")
  Bootstrap:log_tab()
  self.runtime_manager:load_runtimes(nv_config)
  Bootstrap:log_tab(-1)
  return self
end

return function()
  Bootstrap:log("[*] Init process started")
  Bootstrap:log_tab()
  local time = os.clock()
  local nouvelle = Nouvelle:new():init()
  time = os.clock() - time
  Bootstrap:log_tab(-1)
  Bootstrap:log_fmt("[*] Done in %.2f s", time)
  nouvelle.runtime_manager.runtimes.luajit:new():load("error('Hello world')"):run()
end
