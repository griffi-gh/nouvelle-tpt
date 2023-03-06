local Bootstrap = require('bootstrap')
local Mod = require(.....'.mod') ---@type Mod
local TOML = Bootstrap:require('lib.toml') ---@type TOML

local manifest_file = "Mod.toml"

---@class ModExt: Mod
---@field public nid number Contains numeric id of the mod
local ModExt = setmetatable({}, {
  __index = Mod
})
ModExt.__index = ModExt

---@param mod Mod
---@return ModExt
function ModExt:cast(mod)
  local mod = mod ---@type table
  return setmetatable(mod, ModExt)
end

---@class ModError
---@field public error string

---@class ModManager
---@field public mods table<string | integer, ModExt>
---@field public errors ModError[]
local ModManager = {} 
ModManager.__index = ModManager

---@return ModManager
function ModManager:new() 
  ---@type ModManager
  local mod_manager = { 
    mods = {},
    errors = {}
  }
  return setmetatable(mod_manager, self)
end

---Load single mod from directory
---@param mods table<string | number, ModExt>
---@param path string
local function load_mod(mods, path)
  local manfiest_file = assert(io.open(path..'/'..manifest_file, "rb"))
  local manifest_data = manfiest_file:read("*a")
  manfiest_file:close()
  local manifest = TOML.parse(manifest_data)
  local mod = Mod:from_path_and_manifest(path, manifest)
  local log_message = string.format(
    "\"%s\"%s (id: %s)", 
    mod:get_name(), 
    mod.author and (" by %s"):format(mod.author) or "",
    mod.id
  )
  if mods[mod.id] == nil then
    local mod = ModExt:cast(mod)
    mod.nid = #mods + 1
    mods[mod.nid] = mod
    mods[mod.id] = mod
    Bootstrap:log_fmt("New mod discovered: %s with nid %d", log_message, mod.nid)
  else
    Bootstrap:log("Already loaded:", log_message)
  end
end

---Recursively load mods from directory
---@param mods table<string | number, ModExt>
---@param path string
---@return ModError[]
local function recursive_search(mods, path)
  do
    local manifest_path = path.."/Mod.toml"
    if fs.exists(manifest_path) and fs.isFile(manifest_path) then
      local ok, err = pcall(load_mod, mods, path)
      if not ok then
        return {{error = err}}
      else
        return {}
      end
    end
  end
  
  local errors = {}

  ---@param _ integer
  ---@param file_name string
  for _, file_name in ipairs(fs.list(path)) do
    local item_path = path.."/"..file_name
    if fs.isDirectory(item_path) then
      local manifest_path = item_path.."/Mod.toml"
      if fs.exists(manifest_path) and fs.isFile(manifest_path) then
        local ok, err = pcall(load_mod, mods, item_path)
        if not ok then
          errors[#errors+1] = {
            error = err
          }
        end
      else
        recursive_search(mods, item_path)
      end
    end
  end

  return errors
end

---@param path string
function ModManager:load_mods_from_path(path)
  Bootstrap:log("Loading mods...")
  Bootstrap:log_tab()
  local errs = #self.errors
  for i, error in ipairs(recursive_search(self.mods, path)) do
    Bootstrap:log_fmt("Mod load error: %s", error.error)
    self.errors[errs+i] = error
  end
  Bootstrap:log_tab(-1)
end

function ModManager:run_mods()
  for _, mod in ipairs(self.mods) do
    
  end
end

return ModManager
