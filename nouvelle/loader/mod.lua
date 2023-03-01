local Mod = {}
Mod.__index = Mod

--Turns whitespace-only/empty strings and empty tables into nil
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

local function ass_type(what, thing, type1, type2) 
  assert(
    type(thing) == type1 or type(thing) == type2,
    ('%snot "%s"%s'):format(what.." ", type1, type2 and (' or "%s"'):format(type2))
  )
  return thing
end

function Mod:from_manifest(manifest)
  ass_type("manifest", manifest, "table")
  local runs_on = manifest.runtime and manifest.runtime.runs_on
  manifest.runtime.runs_on = nil
  return setmetatable({
    id = ass_type("manifest.metadata.id", manifest.metadata.id, "string"),
    name = nullify(ass_type("manifest.metadata.name", "string", "nil")),
    description = nullify(ass_type("manifest.metadata.description", manifest.metadata.description, "string", "nil")),
    runtime = nullify(ass_type("manifest.runtime.runs_on", runs_on, "string", "nil")) or "luajit",
    runtime_options = ass_type("manifest.runtime", manifest.runtime, "table", "nil") or {},
    permissions = ass_type("manifest.permissions", manifest.permissions, "table", "nil") or {},
  }, self)
end

function Mod:get_id()
  return self.name or self.id
end

function Mod:get_name()
  return self.name or self.id
end

function Mod:get_description()
  return self.description or ""
end
