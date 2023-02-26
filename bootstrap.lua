local bootstrap = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  bootstrap_version = 0,
}

-------------------------------------

--Check if bootstrap is already loded
if _G.BOOTSTRAP then return end
rawset(_G, "BOOTSTRAP", true)

--Make sure that JIT is not disabled
if jit then pcall(jit.on) end

--Change path
package.path = "?.lua;?/init.lua"

--Prevent writes to _G
setmetatable(_G, {
  __newindex = error
})

--Prevent global TPTMP from loading unsandboxed
if tpt.version.jacob1s_mod then
  rawset(_G, "TPTMP", { version = math.huge })
end

--Define log function
-- do
--   local ok, ffi = pcall(require, "ffi")
--   local log_fn
--   if ok then
--     ffi.cdef[[
--       int printf(const char *fmt, ...);
--     ]]
--     if ffi.os == "Windows" then
--       ffi.cdef[[
--         int AttachConsole(unsigned long dwProcessId)
--       ]]
--       print(ffi.C.AttachConsole(4294967295))
--     end
--     log_fn = function(...) ffi.C.printf(...) end
--   else 
--     log_fn = print
--   end
--   rawset(_G, "log", function(fmt, ...)
--     if #({...}) == 0 then
--       log_fn(tostring(fmt))
--     else
--       log_fn(tostring(fmt).format(...))
--     end
--   end)
--   log("Nouvelle")
-- end

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
