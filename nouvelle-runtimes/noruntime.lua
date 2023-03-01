local Runtime = { 
  unsafe = true,
}
Runtime.__index = Runtime

function Runtime:new()
  return setmetatable({}, self)
end

function Runtime:load(code)
  self.fn = assert(load(code))
end

function Runtime:run()
  self.fn()
end

return Runtime
