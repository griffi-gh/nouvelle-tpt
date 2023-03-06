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
    log = {},
  }
  return setmetatable(nouvelle, self)
end

---@return Nouvelle
function Nouvelle:setup_log_sink()
  Bootstrap:add_log_sink(function (_, message)
    ---@type LogEntry
    self.log[#self.log+1] = {
      message = message,
      time = os.time()
    }
  end)
  return self
end

function Nouvelle:init() ---@return Nouvelle
  Bootstrap:log("Init Nouvelle...")
  Bootstrap:log_tab()
  self.runtime_manager:load_runtimes(nv_config)
  Bootstrap:log_tab(-1)
  return self
end

return function()
  local nouvelle = Nouvelle:new()
  nouvelle:setup_log_sink()
  Bootstrap:log("[*] Init process started")
  Bootstrap:log_tab()
  local time = os.clock()
  nouvelle:init()
  time = os.clock() - time
  Bootstrap:log_tab(-1)
  Bootstrap:log_fmt("[*] Done in %.2f s", time)
  nouvelle.runtime_manager.runtimes.luajit:new():load("error('Hello world')"):run()
end
