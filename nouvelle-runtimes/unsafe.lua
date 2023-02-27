local Runtime = { id = "unsafe-nosandbox", unsafe = true }
Runtime.__index = Runtime

function Runtime:new(code)
  return setmetatable({
    fn = assert(load(code))
  }, self)
end

function Runtime:run()
  self.fn()
end

return Runtime
