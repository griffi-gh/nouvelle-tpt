---BOOTSTRAP product information
local BOOTSTRAP_PRODUCT = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  log_path = "./nouvelle.log",
  safemode_file = "./safemode.bootstrap",
  bootstrap_global = nil,
  requireable = true,
}

-------------------------------------

---@class Bootstrap
---@field public friendly_name string
---@field public entry_point string
---@field public log_path string
---@field public safemode_file string
---@field public bootstrap_global string?
---@field public requireable boolean?
local Bootstrap = BOOTSTRAP_PRODUCT

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
  error("No api expose standard found, enable global or requireable")
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

--Make sure that JIT is not disabled
if Bootstrap:get_global("jit") then 
  if pcall(jit.on) then
    Bootstrap:log("JIT: on")
  else
    Bootstrap:log("JIT: off")
  end
end

--Safe mode
if (not Bootstrap:get_global('fs')) or fs.exists(Bootstrap.safemode_file) then
  local safemode_level = io.open(Bootstrap.safemode_file, "rb")
  if safemode_level then
    local level = safemode_level:read"*n"
    if level > 0 then
      print("Safe mode activated")
      Bootstrap.safe_mode = level
    end
  end
end

---@alias safemode_level 0|1|2

---Enter safe mode
---@param level safemode_level
function Bootstrap:set_safe_mode(level) 
  level = level or 1
  local f = assert(io.open(self.safemode_file, "wb"), "Failed to open "..self.safemode_file)
  f:write(tostring(level))
  f:close()
  if level > 0 then
    self.safe_mode = level
  else 
    self.safe_mode = nil
    local ok = (fs and fs.removeFile or os.remove)(self.safemode_file) ---@type boolean
    if not ok then print("File delete failed. Don't worry, safe mode should still be disabled") end
  end
end

---Display warning to the user
if Bootstrap.safe_mode then
  ---@type boolean
  local do_disable = tpt.confirm("Safe mode", "NOTE: Safe mode activated due to past errors, your mods won't be loded", "Disable")
  if do_disable then
    Bootstrap:set_safe_mode(0)
  elseif Bootstrap.safe_mode >= 2 then
    return
  end
end

if Bootstrap.requireable then
  --Store in package cache (to make `require("bootstrap")` work)
  package.loaded[...] = Bootstrap
end

--Run
do
  local error_header ---@type string?
  local use_xpcall = (debug and xpcall) and true or false
  local ok, err = (use_xpcall and xpcall or pcall)(function()
    error_header = "Load"
    local init = require(Bootstrap.entry_point)
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
    tpt.throw_error(("%s: %s error\n\n====== ERROR ======\n%s\n===================\n\nPlease restart the game\nHere's how to resolve this issue:\n\t - Report the issue to the developer "):format(Bootstrap.friendly_name, error_header, strerr))
  end
end

--For diagnostic tools onlyBootstrap:
return Bootstrap
