local Runtime = { id = "luajit", name = "LuaJIT" }
Runtime.__index = Runtime

function Runtime:new(code)
  return setmetatable({}, self):_init(code)
end

function Runtime:_init(code)
  self.code = code
  self.C = require_native("luajit")
  self.lua = setmetatable(self.C.luaL_newstate(), {
    __index = self.C,
    __gc = function(lua)
      self.C.lua_close(lua)
    end
  })
  self.lua:luaL_openlibs()
  self.chunk = self.lua:luaL_loadstring(self.code)
  return self
end

function Runtime:run()
  local error = self.lua:lua_pcall(0, 0, 0)
  if error > 0 then
    local error = self.lua:lua_tostring(-1)
    self.lua:lua_pop(1)
    logf("Script error: %s", error)
    error(error)
  end
end

return Runtime
