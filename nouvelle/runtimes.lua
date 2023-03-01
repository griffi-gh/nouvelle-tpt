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

function RuntimeManager:load_runtimes(nv_config)
  log("Loading runtimes...")
  assert(type(nv_config.runtime_path) == "string", "No runtime path provided")
  assert(type(nv_config.lib_path) == "string", "No lib path provided")
  local f = fs.list(nv_config.runtime_path)
  for _, file_name in ipairs(f) do
    local runtime_id = file_name:sub(1, -5)
    local ok, err = pcall(function()
      local file_path = nv_config.runtime_path..file_name
      local file = assert(io.open(file_path, "rb"))
      local data = file:read("*a")
      file:close()
      local fn = assert(load(data))
      local runtime = setfenv(fn, setmetatable({
        require_native = function(library)
          return self:require_native(library, nv_config.lib_path)
        end
      }, {
        __index = _G,
        __newindex = getmetatable(_G).__newindex,
      }))()
      assert(type(runtime) == "table", file_name..": not a table")
      local function assert_runtime(key, type1, type2)
        local err = ("Invalid API: %s is not a %s%s"):format(key, type1, type2 and (" or "..type2) or "")
        local typ = type(runtime[key])
        assert((typ == type1) or (typ == type2), err)
      end
      assert_runtime("id", "nil")
      assert_runtime("name", "string", "nil")
      assert_runtime("unsafe", "boolean", "nil")
      assert_runtime("init", "function", "nil")
      assert_runtime("new", "function")
      assert_runtime("load", "function")
      assert_runtime("run", "function")
      runtime.id = runtime_id
      if runtime.name == nil then
        runtime.name = runtime.id
      end
      self.runtimes[#self.runtimes+1] = runtime
      self.runtimes[runtime.id] = runtime
      runtime.nid = #self.runtimes
      if runtime.init then
        runtime:init()
      end
      logf("Loaded %s (id: %s; nid: %d)", runtime.name, runtime.id, runtime.nid)
    end)
    if not ok then
      logf("Error loading runtime %s: %s", file_name, err)
      local err_runtime = {
        id = runtime_id,
        error = true,
      }
      err_runtime.name = err_runtime.id
      self.runtimes[err_runtime.id] = err_runtime
      self.runtimes[#self.runtimes+1] = err_runtime
      err_runtime.nid = #self.runtimes
    end
  end
  logf("Loaded %d runtime%s!", #self.runtimes, (#self.runtimes ~= 1) and "s" or "")
  return self
end

function RuntimeManager:new()
  return setmetatable({
    runtimes = {},
    native_lib = {},
  }, self)
end

return RuntimeManager
