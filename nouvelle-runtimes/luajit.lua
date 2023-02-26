local Runtime = { id = "luajit", name = "LuaJIT" }
Runtime.__index = Runtime

function Runtime:new()
  return setmetatable({
    C = require_native("luajit")
  }, self)
end

function Runtime:run()
  --TODO
end

return Runtime
