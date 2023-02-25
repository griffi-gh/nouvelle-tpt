local lua = require(.....'.lua')

local function init_runtimes()
  lua.load_native_library(lua.lua_version.lua54, "./nouvelle/runtimes/lua/")
end

return {
  init_runtimes = init_runtimes,
  lua = lua
}
