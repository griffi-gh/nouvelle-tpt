local lua = require(.....'.lua')

local function init_runtimes()
  lua.load_native_library(lua.lua_version.luajit_native, "./nouvelle-bin/lua/")
end

return {
  init_runtimes = init_runtimes,
  lua = lua
}
