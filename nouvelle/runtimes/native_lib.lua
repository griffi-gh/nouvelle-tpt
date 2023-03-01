local ffi = require("ffi")

-- local runtime_type = {
--   luajit = "luajit",
-- }

-- local supported_runtimes = {
--   luajit_linux64 = true,
--   luajit_win64 = true,
--   luajit_win32 = true,
-- }

local function load_native_library(version, bin_path)
  assert(type(bin_path) == "string", "No bin_path provided")
  assert(type(version) == "string", "No runtime_type provided")
  --assert(runtime_type[version], "Invalid runtime_type")
  
  --find the dll suffix
  local dll_suffix, dll_ext
  if getglobal "platform" then
    dll_suffix = platform.platform():lower()
    dll_ext = "" --empty for automatic
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
    local headers_path = ("./%s/%s/%s-headers.i"):format(bin_path, version, version)
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
    local binary_name = ("%s-%s%s"):format(version, dll_suffix, dll_ext)
    --assert(supported_runtimes[binary_name], ("Runtime %s not supported"):format(binary_name))
    --Find binary path and load binary
    local binary_path = ("./%s/%s/%s"):format(bin_path, version, binary_name)
    local lib = ffi.load(binary_path)
    return lib
  end
end

return {
  load_native_library = load_native_library,
}
