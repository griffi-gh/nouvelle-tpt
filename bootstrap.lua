---BOOTSTRAP product information
local BOOTSTRAP_PRODUCT = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  log_path = "./nouvelle.log",
  requireable = true,
} ---@type Bootstrap

-------------------------------------

---@class Bootstrap
---@field public friendly_name string Name of the software to load
---@field public entry_point string Entry point module to load
---@field public log_path string Path to store log files
---@field public safe_mode_file string? Setting this to nil completely disables all safe mode functionality
---@field public bootstrap_global string? Expose Bootstrap table at this global (optional)
---@field public requireable (boolean | string)? Expose Bootstrap as require module (set to a string to override the name)
---@field private keystore table Key storage for arbitrary data 
local Bootstrap = BOOTSTRAP_PRODUCT
Bootstrap.keystore = {}

--Check for tpt
assert(rawget(_G, "tpt"), "This is a The Powder Toy mod")

if Bootstrap.bootstrap_global then
  --Check if bootstrap is already loded
  if rawget(_G, Bootstrap.bootstrap_global) then return end
  --Set global BOOTSTRAP variable
  rawset(_G, Bootstrap.bootstrap_global, Bootstrap)
elseif Bootstrap.requireable then
  --If global variable is not used, check package cache instead!
  assert(type(package.loaded[...]) ~= "table", "Bootstrap already loaded")
else
  error("No expose standard found, enable bootstrap_global or requireable")
end

--Change path
package.path = "?.lua;?/init.lua"

--Prevent writes to _G
setmetatable(_G, {
  __index = function(_, key, _)
    error(("Undefined global variable: %s"):format(tostring(key)))
  end,
  __newindex = function(_, key, _)
    error(("Attempt to create global: %s"):format(tostring(key)))
  end
})

--Functions to set/get globals
do
  ---Set _G.key = value
  ---@param key any
  ---@param value any
  function Bootstrap:set_global(key, value)
    rawset(_G, key, value)
  end

  ---Get _G.key
  ---@param key any
  ---@return any
  function Bootstrap:get_global(key)
    return rawget(_G, key)
  end
end


--Prevent global TPTMP from loading unsandboxed
if tpt.version.jacob1s_mod then
  Bootstrap:set_global("TPTMP", { version = math.huge })
end

--Logging
do
  do 
    --Empty the file
    local log_file = assert(io.open(Bootstrap.log_path, "wb"))
    log_file:write("")
    log_file:close()
  end
  Bootstrap.log_file = assert(io.open(Bootstrap.log_path, "a+b"))

  local tab = 0
  ---@param t number?
  function Bootstrap:log_tab(t)
    tab = tab + (math.floor(t or 1))
  end
  ---@param ... any
  function Bootstrap:log(...)
    local message = (" "):rep(tab * 2)..table.concat({...}, " ")
    self.log_file:write(message.."\n")
  end
  ---@param fmt string
  ---@param ... any?
  function Bootstrap:log_fmt(fmt, ...)
    self:log(string.format(fmt, ...))
  end
  event.register(event.close, function()
    Bootstrap.log_file:close()
  end)
  Bootstrap:log("BOOTSTRAP LOGGER: "..Bootstrap.friendly_name)
end

--Keystore
do
  ---Set keystore[key]
  ---@param key any
  ---@param value any?
  function Bootstrap:set_keystore(key, value)
    self.keystore[key] = value
  end

  ---Get keystore[key]
  ---@param key any
  ---@return any?
  function Bootstrap:get_keystore(key)
    return self.keystore[key]
  end

  ---Replace keystore object with a new one
  ---Destroys all data in keystore
  function Bootstrap:drop_keystore()
    self.keystore = {}
  end
end

--Make sure that JIT is not disabled
if Bootstrap:get_global("jit") then 
  if pcall(jit.on) then
    Bootstrap:log("JIT: on")
  else
    Bootstrap:log("JIT: off")
  end
end

--Handle safe mode
do
  ---@alias safemode_level 0|1|2

  ---Set safe mode level  
  ---  
  ---0 - safe mode disabled  
  ---1 - safe mode enabled (handled by the loaded module)  
  ---2 - super safe mode enabled (handled by bootstrap) 
  ---   
  ---Bootstrap.safe_mode_file must be enabled  
  ---If no arguments are provided, this defaults to mode 1
  ---@param level safemode_level?
  function Bootstrap:set_safe_mode(level) 
    if not self.safe_mode_file then
      error("Safe mode not allowed")
    end
    level = level or 1
    local f = assert(io.open(self.safe_mode_file, "wb"), "Failed to open "..self.safe_mode_file)
    f:write(tostring(level))
    f:close()
    if level > 0 then
      self.safe_mode = level
    else 
      self.safe_mode = nil
      local ok = (fs and fs.removeFile or os.remove)(self.safe_mode_file) ---@type boolean
      if not ok then print("File delete failed. Don't worry, safe mode should still be disabled") end
    end
  end

  if Bootstrap.safe_mode_file and ((not Bootstrap:get_global('fs')) or fs.exists(Bootstrap.safe_mode_file)) then
    --Read safe mode file
    local safemode_level = io.open(Bootstrap.safe_mode_file, "rb")
    if safemode_level then
      local level = safemode_level:read"*n"
      if level > 0 then
        print("Safe mode activated")
        Bootstrap.safe_mode = level
      end
    end

    ---Display warning to the user
    if Bootstrap.safe_mode and (Bootstrap.safe_mode >= 2) then
      ---@type boolean
      local do_disable = tpt.confirm("Safe mode", "Safe mode activated\n"..Bootstrap.friendly_name.." won't be loaded", "Exit safe mode")
      if do_disable then
        Bootstrap:set_safe_mode(0)
      else
        return
      end
    end
  end
end

--Store in package cache (to make `require("bootstrap")` work)
--If Bootstrap.requireable is enabled
if Bootstrap.requireable then
  local require_path ---@type string
  if type(Bootstrap.requireable) == "string" then
    require_path = tostring(Bootstrap.requireable) --tostring is needed here to suppress warning
  else
    require_path = ...
  end
  package.loaded[require_path] = Bootstrap
  --Verify that require works correctly
  do
    ---@type boolean, Bootstrap?
    local req_ok, req_Bootstrap = pcall(require, require_path)
    assert(
      req_ok, 
      "Requireable: Require error"
    )
    assert(
      type(req_Bootstrap) == "table", 
      "Requireable: Invalid type returned: "..type(req_Bootstrap)
    )
    assert(
      req_Bootstrap == Bootstrap, 
      "Requireable: Table not equal"
    )
  end
end

--Run
do
  local error_header ---@type string?
  local use_xpcall = (debug and xpcall) and true or false
  local ok, err = (use_xpcall and xpcall or pcall)(function()
    error_header = "Load"
    local init = require(assert(Bootstrap.entry_point, "No entry_point provided"))
    error_header = "Init"
    init()
    error_header = "Runtime"
  end, use_xpcall and debug.traceback)
  if not ok then
    local strerr = tostring(err)
    Bootstrap:log_fmt("====== ERROR ======\n%s\n===================", strerr)
    if Bootstrap:get_global("platform") then
      if not pcall(platform.clipboardPaste, Bootstrap.friendly_name.."ERROR\n"..strerr) then
        Bootstrap:log("failed to copy error to clipboard")
      end
    end
    tpt.throw_error(("%s: %s error\n\n====== ERROR ======\n%s\n===================\n\nPlease restart the game\nTry doing this:\n\t - Report the issue to the developer on GitHub or Discord"):format(Bootstrap.friendly_name, error_header, strerr))
  end
end

--For diagnostic tools onlyBootstrap:
return Bootstrap
