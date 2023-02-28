local ffi = require('ffi')
local Lua = require_native("luajit") --TODO lazy load

local Runtime = { 
  name = "LuaJIT" 
}
Runtime.__index = Runtime

function Runtime:new(code)
  return setmetatable({}, self):_init(code)
end

function Runtime:_init(code)
  self.code = code
  self.lua = self.ffi.gc(Lua.luaL_newstate(), function(L)
    Lua.lua_close(L)
  end)
  Lua.luaJIT_setmode(self.lua, 0, 0x0100); --LUAJIT_MODE_ON = 0x0100
  Lua.luaL_openlibs(self.lua)
  self.chunk = Lua.luaL_loadstring(self.lua, self.code)
  return self
end

function Runtime:run()
  local is_err = Lua.lua_pcall(self.lua, 0, 0, 0)
  if is_err > 0 then
    local err = self.ffi.string(Lua.lua_tolstring(self.lua, -1, nil))
    Lua.lua_settop(self.lua, -(1)-1) --Lua.lua_pop(self.lua, 1)
    error(err)
  end
end

return Runtime
