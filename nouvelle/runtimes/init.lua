local native_lib = require(.....'.native_lib')

local runtimes = {}
runtimes.__index = runtimes

function runtimes:require_native(runtime_type, path)
  if self.native_lib[runtime_type] then
    return self.native_lib[runtime_type]
  end
  local lib = native_lib.load_native_library(runtime_type, path)
  self.native_lib[runtime_type] = lib
  return lib
end

function runtimes:init()
  return setmetatable({
    native_lib = {},
  }, self)
end

return runtimes
