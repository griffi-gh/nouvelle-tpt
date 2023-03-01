--BOOTSTRAP product information
local bootstrap = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  log_file = "nouvelle.log",
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
rawset(_G, "setglobal", function(key, value)
  rawset(_G, key, value)
end)
rawset(_G, "getglobal", function(key)
  return rawget(_G, key)
end)

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
  local function logtab(t)
    tab = tab + (t or 1)
  end
  local function log(...)
    local mesage = (" "):rep(tab * 2)..table.concat({...}, " ")
    log_file:write(mesage.."\n")
  end
  local function logf(...)
    log(string.format(...))
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

--Run
do
  local error_header
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
    tpt.throw_error(("%s: %s error\n\n====== ERROR ======\n%s\n===================\n\nPlease restart the game"):format(bootstrap.friendly_name, error_header, strerr))
  end
end
