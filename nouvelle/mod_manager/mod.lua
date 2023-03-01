---@class Mod
---@field public id string Unique identifier of the mod
---@field public name string? User-friendly name of the mod
---@field public description string? Mod description
---@field public dir_path string? Path to the mod directory
---@field public nid number? Contains numeric id of the mod if it's loaded
---@field public runtime string Id of the runtime used to run the mod
---@field public runtime_options table Runtime-dependent options
---@field public permissions table[] Array of mod permissions
local Mod = {}
Mod.__index = Mod

---Turns whitespace-only/empty strings and empty tables into nil
---@generic T
---@param thing T
---@return T?
local function nullify(thing)
  local typ = type(thing)
  if typ == "table" then
    if (#thing == 0) or (not (pairs(thing)(thing))) then 
      return nil
    end
  elseif typ == "string" then
    if (#thing == 0) or thing:match("%S") then
      return nil
    end
  end
  return thing
end

---Asserts that value has either type1 or type2
---@param what string
---@param thing any
---@param type1 type
---@param type2 type?
local function ass_type(what, thing, type1, type2) 
  assert(
    type(thing) == type1 or type(thing) == type2,
    ('%snot "%s"%s'):format(what.." ", type1, type2 and (' or "%s"'):format(type2))
  )
  return thing
end

---Creates a mod object from TOML manifest  
---Do not use the manifest after passing it to this function
---@param path string
---@param manifest table
---@return Mod
function Mod:from_path_and_manifest(path, manifest)
  ass_type("manifest", manifest, "table")
  local runs_on = manifest.runtime and manifest.runtime.runs_on
  manifest.runtime.runs_on = nil
  ---@type Mod
  local mod = {
    id = ass_type("manifest.metadata.id", manifest.metadata.id, "string"),
    name = nullify(ass_type("manifest.metadata.name", "string", "nil")),
    path = ass_type("<path>", path, "string", "nil"),
    description = nullify(ass_type("manifest.metadata.description", manifest.metadata.description, "string", "nil")),
    runtime = nullify(ass_type("manifest.runtime.runs_on", runs_on, "string", "nil")) or "luajit",
    runtime_options = ass_type("manifest.runtime", manifest.runtime, "table", "nil") or {},
    permissions = ass_type("manifest.permissions", manifest.permissions, "table", "nil") or {},
  }
  return setmetatable(mod, self)
end

---Get the name of the mod  
---Returns the mod id if the name is nil
---@return string
function Mod:get_name()
  return self.name or self.id
end
