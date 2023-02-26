local ffi = require("ffi")

local runtime_type = {
  luajit = "luajit",
}

local supported_runtimes = {
  luajit_linux64 = true,
  luajit_win64 = true,
  luajit_win32 = true,
}

local function load_native_library(version, bin_path)
  bin_path = bin_path or "./"
  assert(type(version) == "string", "No runtime_type provided")
  assert(runtime_type[version], "Invalid runtime_type")
  
  --find the dll suffix
  local binary_name
  local dll_suffix
  do
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
    elseif ffi.os == "Linux" then
      dll_os = "linux"
    else
      error(("OS %s not supported"):format(ffi.os))
    end
    dll_suffix = dll_os..dll_arch
  end

  --find binary name and check if it's supported
  binary_name = ("%s_%s"):format(version, dll_suffix)
  assert(supported_runtimes[binary_name], ("Runtime %s not supported"):format(binary_name))
  
  --Find path to headers and load them
  do
    local headers_path = ("./%s/%s/%s_headers.i"):format(bin_path, version, version)
    local header_data
    do
      local file = assert(io.open(headers_path, "rb"))
      header_data = file:read("*a")
      file:close()
    end
    ffi.cdef(header_data)
  end

  --Find binary path and load binary
  local binary_path = ("./%s/%s/%s"):format(bin_path, version, binary_name)
  local lib = ffi.load(binary_path)
  
  return lib
end

return {
  runtime_type = runtime_type,
  supported_runtimes = supported_runtimes,
  load_native_library = load_native_library,
}
