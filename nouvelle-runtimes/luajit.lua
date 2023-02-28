local Runtime = { 
  name = "LuaJIT" 
}
Runtime.__index = Runtime

local ffi, liblua

function Runtime:init()
  ffi = require('ffi')
  liblua = require_native("luajit")
end

function Runtime:_pop_error()
  local err = ffi.string(liblua.lua_tolstring(self.lua, -1, nil))
  liblua.lua_settop(self.lua, -(1)-1) --liblua.lua_pop(self.lua, 1)
  error(err)
end

function Runtime:new()
  self = setmetatable({}, self)
  self.lua = ffi.gc(liblua.luaL_newstate(), function(L)
    liblua.lua_close(L)
  end)
  liblua.luaJIT_setmode(self.lua, 0, 0x0100); --LUAJIT_MODE_ON = 0x0100
  liblua.luaL_openlibs(self.lua)
  return self
end

function Runtime:load(code)
  self.code = code
  if liblua.luaL_loadstring(self.lua, self.code) > 0 then
    self:_pop_error()
  end
  return self
end

function Runtime:run()
  if liblua.lua_pcall(self.lua, 0, 0, 0) > 0 then
    self:_pop_error()
  end
  return self
end

return Runtime
