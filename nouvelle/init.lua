local Bootstrap = require('bootstrap')
local RuntimeManager = require(.....'.runtime_manager') ---@type RuntimeManager
local ModManager = require(.....'.mod_manager') ---@type ModManager

local nv_config = { ---@class NvConfig
  path = "./nouvelle/",
  mod_path = "./Mods/",
  lib_path = "./nouvelle-native/",
  runtime_path = "./nouvelle-runtimes/",
}

---@class Nouvelle
---@field runtime_manager RuntimeManager
---@field mod_manager ModManager
---@field log LogEntry[]
local Nouvelle = {}
Nouvelle.__index = Nouvelle

---@class LogEntry
---@field public message string
---@field public time number

---@return Nouvelle
function Nouvelle:new() 
  local nouvelle = { ---@type Nouvelle
    runtime_manager = RuntimeManager:new(),
    mod_manager = ModManager:new(),
    log = {},
  }
  return setmetatable(nouvelle, self)
end

---@return Nouvelle
function Nouvelle:pre_init()
  Bootstrap:add_log_sink(function (_, message)
    ---@type LogEntry
    self.log[#self.log+1] = {
      message = message,
      time = os.time()
    }
  end)
  Bootstrap:log("[ Nouvelle log system ready ]")
  return self
end

function Nouvelle:init() ---@return Nouvelle
  Bootstrap:log("Init Nouvelle...")
  Bootstrap:log_tab()
  local clock = os.clock()
  self.runtime_manager:load_runtimes(nv_config)
  self.mod_manager:load_mods_from_path(nv_config.mod_path)
  self.mod_manager:run_mods()
  clock = os.clock() - clock
  Bootstrap:log_fmt("Initialized in %.2fs!", clock)
  Bootstrap:log_tab(-1)
  return self
end

return function()
  local nouvelle = Nouvelle:new()
  nouvelle:init()
  nouvelle.runtime_manager.runtimes.luajit:new():load("error('Hello world')"):run()
end
