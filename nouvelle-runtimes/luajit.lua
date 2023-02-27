local ffi = require('ffi')

local Runtime = { id = "luajit", name = "LuaJIT" }
Runtime.__index = Runtime

function Runtime:new(code)
  return setmetatable({}, self):_init(code)
end

function Runtime:_init(code)
  self.code = code
  self.C = require_native("luajit")
  self.lua = ffi.gc(self.C.luaL_newstate(), function(L)
    self.C.lua_close(L)
  end)
  self.C.luaJIT_setmode(self.lua, 0, 0x0100); --LUAJIT_MODE_ON = 0x0100
  self.C.luaL_openlibs(self.lua)
  self.chunk = self.C.luaL_loadstring(self.lua, self.code)
  return self
end

function Runtime:run()
  local is_err = self.C.lua_pcall(self.lua, 0, 0, 0)
  if is_err > 0 then
    local err = ffi.string(self.C.lua_tolstring(self.lua, -1, nil))
    self.C.lua_settop(self.lua, -(1)-1) --self.C.lua_pop(self.lua, 1)
    error(err)
  end
end

return Runtime
