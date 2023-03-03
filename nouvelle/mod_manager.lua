local Mod = require(.....'.mod') ---@type Mod

---@class ModManager
---@field mods table<string | number, Mod>
local ModManager = {} 
ModManager.__index = ModManager

---@return ModManager
function ModManager:new() 
  ---@type ModManager
  local mod_manager = { 
    mods = {}
  }
  return setmetatable(mod_manager, self)
end

---Load single mod from directory
---@param mods table<string | number, Mod>
---@param path string
local function load_mod(mods, path)

end

---Recursively load mods from directory
---@param mods table<string | number, Mod>
---@param path string
local function recursive_search(mods, path)
  do
    local manifest_path = path.."/Mod.toml"
    if fs.exists(manifest_path) and fs.isFile(manifest_path) then
      load_mod(mods, path)
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
