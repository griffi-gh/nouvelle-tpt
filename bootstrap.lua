--BOOTSTRAP product information
local bootstrap = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  log_file = "./nouvelle.log",
  safemode_file = "./safemode.bootstrap",
}

-------------------------------------

--Check for tpt
assert(rawget(_G, "tpt"), "This is a The Powder Toy mod")

--Check if bootstrap is already loded
if rawget(_G, "BOOTSTRAP") then return end

--Set global BOOTSTRAP variable
rawset(_G, "BOOTSTRAP", bootstrap)

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
local function setglobal(key, value)
  rawset(_G, key, value)
end
---Get _G.key
---@param key any
---@return any
local function getglobal(key)
  return rawget(_G, key)
end
rawset(_G, "setglobal", setglobal)
rawset(_G, "getglobal", getglobal)

--Prevent global TPTMP from loading unsandboxed
if tpt.version.jacob1s_mod then
  setglobal("TPTMP", { version = math.huge })
end

--Logging
do
  local log_file = assert(io.open(bootstrap.log_file, "wb"))
  log_file:write("")
  log_file:close()
  log_file = assert(io.open(bootstrap.log_file, "a+b"))
  local tab = 0
  ---@param t number?
  local function logtab(t)
    tab = tab + (math.floor(t or 1))
  end
  ---@param ... string
  local function log(...)
    local message = (" "):rep(tab * 2)..table.concat({...}, " ")
    log_file:write(message.."\n")
  end
  ---@param fmt string
  ---@param ... string?
  local function logf(fmt, ...)
    log(string.format(fmt, ...))
  end
  event.register(event.close, function()
    log_file:close()
  end)
  setglobal("log", log)
  setglobal("logf", logf)
  setglobal("logtab", logtab)
  log("BOOTSTRAP LOGGER: "..bootstrap.friendly_name)
end

--Make sure that JIT is not disabled
if getglobal("jit") then 
  if pcall(jit.on) then
    log("JIT: on")
  else
    log("JIT: off")
  end
end

--Safe mode
if (not getglobal('fs')) or fs.exists(bootstrap.safemode_file) then
  local safemode_level = io.open(bootstrap.safemode_file, "rb")
  if safemode_level then
    local level = safemode_level:read"*n"
    if level > 0 then
      print("Safe mode activated")
      setglobal('SAFE_MODE', level)
    end
  end
end

---@alias safemode_level 0|1|2

---Enter safe mode
---@param level safemode_level
local function safemode(level) 
  level = level or 1
  local f = assert(io.open(bootstrap.safemode_file, "wb"), "Failed to open "..bootstrap.safemode_file)
  f:write(tostring(level))
  f:close()
  if level > 0 then
    setglobal('SAFE_MODE', level)
  else 
    setglobal('SAFE_MODE', nil)
    local ok = (fs and fs.removeFile or os.remove)(bootstrap.safemode_file) ---@type boolean
    if not ok then print("File delete failed. Don't worry, safe mode should still be disabled") end
  end
end
setglobal("safemode", safemode)

---Display warning to the user
if getglobal('SAFE_MODE') then
  ---@type boolean
  local do_disable = tpt.confirm("Safe mode", "NOTE: Safe mode activated due to past errors, your mods won't be loded", "Disable")
  if do_disable then
    safemode(0)
  elseif getglobal('SAFE_MODE') >= 2 then 
    return
  end
end

--Run
do
  local error_header ---@type string?
  local use_xpcall = (debug and xpcall) and true or false
  local ok, err = (use_xpcall and xpcall or pcall)(function()
    error_header = "Load"
    local init = require(bootstrap.entry_point)
    error_header = "Init"
    init()
    error_header = "Runtime"
  end, use_xpcall and debug.traceback)
  if not ok then
    local strerr = tostring(err)
    logf("====== ERROR ======\n%s\n===================", strerr)
    if getglobal "platform" then
      if not pcall(platform.clipboardPaste, bootstrap.friendly_name.."ERROR\n"..strerr) then
        log("failed to copy error to clipboard")
      end
    end
    tpt.throw_error(("%s: %s error\n\n====== ERROR ======\n%s\n===================\n\nPlease restart the game\nIf this keeps happening:\n\t- open the console (~), enter \"safemode()\" (without the quotes) and press Enter\n\t - Report the issue to the developer "):format(bootstrap.friendly_name, error_header, strerr))
  end
end
