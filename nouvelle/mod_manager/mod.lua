---@class Mod
---@field public id string Unique identifier of the mod
---@field public name string? User-friendly name of the mod
---@field public author string? Username of the developer of the mod
---@field public description string? Mod description
---@field public dir_path string? Path to the mod directory
---@field public runtime string Id of the runtime used to run the mod
---@field public runtime_options table Runtime-dependent options
---@field public permissions table[] Array of mod permissions
local Mod = {}
Mod.__index = Mod

local default_runtime = "luajit"

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
    if (#thing == 0) then
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
    (type(thing) == type1) or (type(thing) == type2),
    ('%snot "%s"%s'):format(what.." ", type1, type2 and (' or "%s"'):format(type2) or "")
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
  ass_type("manifest.metadata", manifest.metadata, "table")
  ass_type("manifest.runtime", manifest.runtime, "table", "nil")
  local runs_on = manifest.runtime and manifest.runtime.runs_on
  manifest.runtime.runs_on = nil
  ---@type Mod
  local mod = {
    id = ass_type("manifest.metadata.id", nullify(manifest.metadata.id), "string"),
    name = nullify(ass_type("manifest.metadata.name", manifest.metadata.name, "string", "nil")),
    author = nullify(ass_type("manifest.metadata.author", manifest.metadata.author, "string", "nil")),
    path = ass_type("<path>", path, "string", "nil"),
    description = nullify(ass_type("manifest.metadata.description", manifest.metadata.description, "string", "nil")),
    runtime = nullify(ass_type("manifest.runtime.runs_on", runs_on, "string", "nil")) or default_runtime,
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

return Mod
