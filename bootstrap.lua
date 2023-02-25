local bootstrap = {
  friendly_name = "Nouvelle",
  entry_point = "nouvelle",
  bootstrap_version = 0,
}

-------------------------------------

--Check if bootstrap is already loded
if _G.BOOTSTRAP then return end
_G.BOOTSTRAP = true

--Make sure that JIT is not disabled
if jit then pcall(jit.on) end

--Prevent global TPTMP from loading unsandboxed
if tpt.version.jacob1s_mod then
  _G.TPTMP = { version = math.huge }
end

--Change path
package.path = "?.lua;?/init.lua"

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
