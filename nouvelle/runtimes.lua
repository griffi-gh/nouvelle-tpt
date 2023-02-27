local native_lib = require(.....'.native_lib')
local fs = assert(fs, "No filesystem API")

local RuntimeManager = {}
RuntimeManager.__index = RuntimeManager

function RuntimeManager:require_native(runtime_type, path)
  if self.native_lib[runtime_type] then
    return self.native_lib[runtime_type]
  end
  local lib = native_lib.load_native_library(runtime_type, path)
  self.native_lib[runtime_type] = lib
  return lib
end

function RuntimeManager:load_runtimes(runtime_path, lib_path)
  log("Loading runtimes...")
  assert(type(runtime_path) == "string", "No runtime path provided")
  assert(type(lib_path) == "string", "No lib path provided")
  local f = fs.list(runtime_path)
  for _, file_name in ipairs(f) do
    local ok, err = pcall(function()
      local file_path = runtime_path..file_name
      local file = assert(io.open(file_path, "rb"))
      local data = file:read("*a")
      file:close()
      local fn = assert(load(data))
      local runtime = setfenv(fn, setmetatable({
        require_native = function(library)
          return self:require_native(library, lib_path)
        end
      }, {
        __index = _G,
        __newindex = getmetatable(_G).__newindex,
      }))()
      assert(
        (type(runtime) == "table") and 
        (
          (type(runtime.new) == "function") and 
          (type(runtime.run) == "function") and 
          (type(runtime.id)  == "string") and
          ((type(runtime.name) == "string") or (runtime.name == nil)) and
          ((type(runtime.unsafe) == "bool") or (runtime.unsafe == nil))
        ), 
        "Invalid runtime API provided by "..file_name
      )
      if runtime.name == nil then
        runtime.name = runtime.id
      end
      self.runtimes[#self.runtimes+1] = runtime
      self.runtimes[runtime.id] = runtime
      runtime.nid = #self.runtimes
      logf("Found %s (id: %s; nid: %d)", runtime.name, runtime.id, runtime.nid)
    end)
    if not ok then
      logf("Error loading runtime %s: %s", file_name, err)
      local err_runtime = {
        id = file_name,
        name = file_name,
        error = true,
      }
      self.runtimes[err_runtime.id] = err_runtime
      self.runtimes[#self.runtimes+1] = err_runtime
      err_runtime.nid = #self.runtimes
    end
  end
  logf("Loaded %d runtime%s!", #self.runtimes, (#self.runtimes ~= 1) and "s" or "")
  return self
end

function RuntimeManager:init(runtime_path, lib_path)
  log("Init RuntimeManager...")
  return setmetatable({
    runtimes = {},
    native_lib = {},
  }, self):load_runtimes(runtime_path, lib_path)
end

return RuntimeManager
