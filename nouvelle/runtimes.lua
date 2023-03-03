local Bootstrap = require("bootstrap")
local native_lib = require(.....'.native_lib')
local fs = assert(fs, "No filesystem API")

---@class RuntimeManager
---@field private native_lib table<string, ffi.namespace*> Cached native libraries
---@field public runtimes table<number | string, Runtime> Loaded runtimes (both numeric and id indexed)
local RuntimeManager = {}
RuntimeManager.__index = RuntimeManager

---@class Runtime
---@field public id string
---@field public name string?
---@field public unsafe boolean?
---@field public init function?
---@field public new function
---@field public load function
---@field public run function

---Require a native library  
---This function is cached
---@version JIT
---@param runtime_type string Name of the native runtime library
---@param path string Directory to load from
---@return ffi.namespace*
function RuntimeManager:require_native(runtime_type, path)
  if self.native_lib[runtime_type] then
    return self.native_lib[runtime_type]
  end
  local lib = native_lib.load_native_library(runtime_type, path)
  self.native_lib[runtime_type] = lib
  return lib
end

---Load all runtimes from NvConfig.runtime_path
---@param nv_config NvConfig
---@version 5.1,JIT
function RuntimeManager:load_runtimes(nv_config)
  Bootstrap:log("Loading runtimes...")
  Bootstrap:log_tab()
  assert(type(nv_config.runtime_path) == "string", "No runtime path provided")
  assert(type(nv_config.lib_path) == "string", "No lib path provided")
  local f = fs.list(nv_config.runtime_path)
  ---@param file_name string
  for _, file_name in ipairs(f) do
    --local runtime_id = file_name:sub(1, -5)
    local ok, err = pcall(function()
      local file_path = nv_config.runtime_path.."/"..file_name
      local file = assert(io.open(file_path, "rb"))
      local data = file:read("*a")
      file:close()
      local fn = assert(load(data))
      ---@type Runtime
      local runtime = setfenv(fn, setmetatable({
        require_native = function(library)
          return self:require_native(library, nv_config.lib_path)
        end
      }, {
        __index = _G,
        __newindex = getmetatable(_G).__newindex,
      }))()
      assert(type(runtime) == "table", file_name..": not a table")
      ---@param key string
      ---@param type1 type
      ---@param type2 type?
      ---@param note string?
      local function assert_runtime(key, type1, type2, note)
        local err = ('Invalid API: %s is not "%s"%s%s'):format(
          key, 
          type1, 
          type2 and (' or "'..type2..'"') or "",
          note and (" (Note: %s)"):format(note) or ""
        )
        local typ = type(runtime[key])
        assert((typ == type1) or (typ == type2), err)
      end
      assert_runtime("id", "string")
      assert_runtime("name", "string", "nil")
      assert_runtime("unsafe", "boolean", "nil")
      assert_runtime("init", "function", "nil")
      assert_runtime("new", "function")
      assert_runtime("load", "function")
      assert_runtime("run", "function")
      -- if runtime.name == nil then
      --   runtime.name = runtime.id
      -- end
      self.runtimes[#self.runtimes+1] = runtime
      self.runtimes[runtime.id] = runtime
      runtime.nid = #self.runtimes
      if runtime.init then
        runtime:init()
      end
      Bootstrap:log_fmt("Loaded %s (id: %s; nid: %d)", runtime.name, runtime.id, runtime.nid)
    end)
    if not ok then
      Bootstrap:log_fmt("Error loading runtime %s: %s", file_name, err)
      -- local err_runtime = {
      --   file_name = file_name,
      --   error = tostring(err),
      -- }
      -- self.runtimes[#self.runtimes+1] = err_runtime
      -- err_runtime.nid = #self.runtimes
    end
  end
  Bootstrap:log_tab(-1)
  --logf("Loaded %d runtime%s!", #self.runtimes, (#self.runtimes ~= 1) and "s" or "")
  return self
end

---@return RuntimeManager
function RuntimeManager:new()
  ---@type RuntimeManager
  local runtime_manager = {
    runtimes = {},
    native_lib = {},
  }
  return setmetatable(runtime_manager, self)
end

return RuntimeManager
