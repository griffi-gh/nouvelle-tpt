local ffi = require("ffi")

local lua_version = {
  luajit_native = "luajit_native",
  lua51 = "lua51",
  lua54 = "lua54",
}

local is_native = {
  luajit_native = true
}

local supported_runtimes = {
  luajit_native = true,
  lua51_linux32 = true,
  lua51_linux64 = true,
  lua51_win32 = true,
  lua51_win64 = true,
  lua54_linux64 = true,
  lua54_win32 = true,
  lua54_win64 = true,
}

local function load_native_library(version, bin_path)
  bin_path = bin_path or "./"
  assert(type(version) == "string", "No lua version provided")
  assert(lua_version[version], "Invalid lua version")
  
 
  --find the dll suffix
  local binary_name
  if not is_native[version] then
    local dll_suffix
    do
      local dll_bits, dll_os
      --Get bits
      if ffi.abi("32bit") and ffi.arch == "x86" then
        dll_bits = "32"
      elseif ffi.abi("64bit") and ffi.arch == "x64" then
        dll_bits = "64"
      else
        error(("Architecture %s not supported"):format(ffi.arch))
      end
      --Get OS
      if ffi.os == "Windows" then
        dll_os = "win"
      elseif ffi.os == "Linux" then
        dll_os = "linux"
      else
        error(("OS %s not supported"):format(ffi.os))
      end
      dll_suffix = dll_os..dll_bits
    end

    --find binary name and check if it's supported
    binary_name = ("%s_%s"):format(version, dll_suffix)
    assert(supported_runtimes[binary_name], ("Runtime %s not supported"):format(binary_name))
    
    --Find binary path and load binary
    local binary_path = ("./%s/%s/%s"):format(bin_path, version, binary_name)
    ffi.load(binary_path)
  else 
    binary_name = version
  end

  --Find path to headers and load them
  do
    local headers_path = ("./%s/%s/%s_headers.i"):format(bin_path, version, version)
    local header_data
    ffi.cdef(header_data)
  end

  return binary_name
end

return {
  lua_version = lua_version,
  supported_runtimes = supported_runtimes,
  load_native_library = load_native_library,
}
