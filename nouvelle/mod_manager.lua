---@class ModManager
---@field mods table
local ModManager = {} 
ModManager.__index = ModManager

---@return ModManager
function ModManager:new() 
  local mod_manager = { ---@type ModManager
    mods = {}
  }
  return setmetatable(mod_manager, self)
end

---@param nv_config NvConfig
function ModManager:load_mods(nv_config)
  
end

return ModManager
