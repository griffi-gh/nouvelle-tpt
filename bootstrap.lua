local bootstrap = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  log_file = "nouvelle.log",
}

-------------------------------------

--Check if bootstrap is already loded
if _G.BOOTSTRAP then return end

--Set global BOOTSTRAP variable
rawset(_G, "BOOTSTRAP", bootstrap)

--Make sure that JIT is not disabled
if jit then pcall(jit.on) end

--Change path
package.path = "?.lua;?/init.lua"

--Prevent writes to _G
setmetatable(_G, {
  __newindex = function(_, key, _)
    error(("Attempt to create global: %s"):format(tostring(key)))
  end
})

--Prevent global TPTMP from loading unsandboxed
if tpt.version.jacob1s_mod then
  rawset(_G, "TPTMP", { version = math.huge })
end

--Logging
do
  local log_file = assert(io.open(bootstrap.log_file, "wb"))
  log_file:write("")
  log_file:close()
  log_file = assert(io.open(bootstrap.log_file, "a+b"))
  local function log(...)
    log_file:write(table.concat({...}, " ").."\n")
    --log_file:flush()
  end
  local function logf(...)
    log(string.format(...))
  end
  event.register(event.close, function()
    log_file:close()
  end)
  rawset(_G, "log", log)
  rawset(_G, "logf", logf)
  log(bootstrap.friendly_name, "log file")
end

--Run
do
  local error_header
  local use_xpcall = debug and xpcall
  local ok, err = (use_xpcall and xpcall or pcall)(function()
    error_header = "Load"
    local init = require(bootstrap.entry_point)
    error_header = "Init"
    init()
    error_header = "Runtime"
  end, use_xpcall and debug.traceback)
  if not ok and err then
    tpt.throw_error(bootstrap.friendly_name..": "..error_header.." error\n\n"..(err or ""))
  end
end
