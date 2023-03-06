local Bootstrap = require('bootstrap')
local Mod = require(.....'.mod') ---@type Mod
local TOML = Bootstrap:require('lib.toml') ---@type TOML

local manifest_file = "Mod.toml"

---@class ModError
---@field public error string

---@class ModManager
---@field public mods Mod[]
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
---@param mods table<string | number, Mod>
---@param path string
local function load_mod(mods, path)
  local manfiest_file = assert(io.open(path..'/'..manifest_file, "rb"))
  local manifest_data = manfiest_file:read("*a")
  manfiest_file:close()
  local manifest = TOML.parse(manifest_data)
  return Mod:from_path_and_manifest(path, manifest)
end

---Recursively load mods from directory
---@param mods table<string | number, Mod>
---@param path string
local function recursive_search(mods, path)
  do
    local manifest_path = path.."/Mod.toml"
    if fs.exists(manifest_path) and fs.isFile(manifest_path) then
      local ok, err = pcall(load_mod, mods, path)
      if not ok then
        
      end
      return
    end
  end
  for _, name in fs.list(path) do
    local item_path = path.."/"..name
    if fs.isDirectory(item_path) then
      local manifest_path = item_path.."/Mod.toml"
      if fs.exists(manifest_path) and fs.isFile(manifest_path) then
        load_mod(mods, item_path)
      else
        recursive_search(mods, item_path)
      end
    end
  end
end

---@param path string
function ModManager:load_mods_from_path(path)
  recursive_search(self.mods, path)
end

return ModManager
