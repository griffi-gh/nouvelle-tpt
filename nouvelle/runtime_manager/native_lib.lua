local Bootstrap = require("bootstrap")

---load native library using it's type and path to binaries
---@version JIT
---@param runtime_type string
---@param bin_path string
---@return ffi.namespace*
local function load_native_library(runtime_type, bin_path)
  local ffi = require("ffi")

  assert(type(bin_path) == "string", "No bin_path provided")
  assert(type(runtime_type) == "string", "No runtime_type provided")
  
  --find the dll suffix
  local dll_suffix, dll_ext
  if Bootstrap:get_global("platform") then
    dll_suffix = platform.platform():lower()
    if dll_suffix == "win32" or dll_suffix == "win64" then
      dll_ext = ".dll"
    elseif dll_suffix == "lin32" or dll_suffix == "lin64" then
      dll_ext = ".so"
    elseif dll_suffix == "macosarm" or dll_suffix == "macosx" then
      dll_ext = ".dylib"
    else
      error("Unknown OS")
    end
  else
    local dll_arch, dll_os
    --Get bits
    if ffi.abi("32bit") and ffi.arch == "x86" then
      dll_arch = "32"
    elseif ffi.abi("64bit") and ffi.arch == "x64" then
      dll_arch = "64"
    elseif ffi.abi("64bit") and ffi.arch == "arm" then
      dll_arch = "arm64"
    elseif ffi.abi("32bit") and ffi.arch == "arm" then
      dll_arch = "arm32"
    else
      error(("Architecture %s not supported"):format(ffi.arch))
    end
    --Get OS
    if ffi.os == "Windows" then
      dll_os = "win"
      dll_ext = ".dll"
    elseif ffi.os == "Linux" then
      dll_os = "lin"
      dll_ext = ".so"
    else
      error(("OS %s not supported"):format(ffi.os))
    end
    dll_suffix = dll_os..dll_arch
  end

  --Find path to headers and load them
  do
    local headers_path = ("./%s/%s/%s-headers.i"):format(bin_path, runtime_type, runtime_type)
    local header_data
    do
      local file = assert(io.open(headers_path, "rb"))
      header_data = file:read("*a")
      file:close()
    end
    ffi.cdef(header_data)
  end

  --Load dll binary
  do
    --find binary filename
    local binary_name = ("%s-%s%s"):format(runtime_type, dll_suffix, dll_ext)
    --Find binary path and load binary
    local binary_path = ("./%s/%s/%s"):format(bin_path, runtime_type, binary_name)
    if Bootstrap:get_global("fs") and (not fs.exists(binary_path)) then
      error("No binary for platform "..dll_suffix)
    end
    local lib = ffi.load(binary_path)
    return lib
  end
end

---@class NativeLib
return {
  load_native_library = load_native_library,
}
