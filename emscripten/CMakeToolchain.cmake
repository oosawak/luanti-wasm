# Emscripten CMake Toolchain for Luanti WASM
# Usage: emcmake cmake .. -DCMAKE_TOOLCHAIN_FILE=emscripten/CMakeToolchain.cmake

set(CMAKE_SYSTEM_NAME Emscripten)
set(CMAKE_SYSTEM_VERSION 1)

# Emscripten compiler settings
set(CMAKE_C_COMPILER "emcc")
set(CMAKE_CXX_COMPILER "em++")
set(CMAKE_AR "emar")
set(CMAKE_RANLIB "emranlib")

# Platform-specific settings
set(EMSCRIPTEN TRUE)
add_definitions(-DEMSCRIPTEN)

# WebGL / Web Audio settings
set(EMSCRIPTEN_LINK_FLAGS 
  "-s WASM=1"
  "-s FULL_ES3=1"
  "-s USE_SDL=2"
  "-s USE_OPENAL=1"
  "-s USE_VORBIS=1"
  "-s USE_OGG=1"
  "-s ALLOW_MEMORY_GROWTH=1"
  "-s INITIAL_MEMORY=536870912"  # 512 MB
  "-s MAXIMUM_MEMORY=2147483648" # 2 GB
  "-s ASYNCIFY=1"
  "-s ENVIRONMENT='web,worker'"
)

string(REPLACE ";" " " EMSCRIPTEN_LINK_FLAGS_STR "${EMSCRIPTEN_LINK_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS "${EMSCRIPTEN_LINK_FLAGS_STR}")
set(CMAKE_SHARED_LINKER_FLAGS "${EMSCRIPTEN_LINK_FLAGS_STR}")
set(CMAKE_MODULE_LINKER_FLAGS "${EMSCRIPTEN_LINK_FLAGS_STR}")

# Emscripten CMake options
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# Disable features not available in WebAssembly
set(BUILD_SERVER OFF CACHE BOOL "Server not supported in WASM" FORCE)
set(BUILD_UNITTESTS OFF CACHE BOOL "Tests not supported in WASM" FORCE)
set(BUILD_BENCHMARKS OFF CACHE BOOL "Benchmarks not supported in WASM" FORCE)
set(BUILD_DOCUMENTATION OFF CACHE BOOL "Documentation build skipped" FORCE)

# Disable optional features for WASM compatibility
set(ENABLE_GETTEXT OFF CACHE BOOL "GetText disabled for WASM" FORCE)
set(ENABLE_POSTGRESQL OFF CACHE BOOL "PostgreSQL disabled for WASM" FORCE)
set(ENABLE_LEVELDB OFF CACHE BOOL "LevelDB disabled for WASM" FORCE)
set(ENABLE_REDIS OFF CACHE BOOL "Redis disabled for WASM" FORCE)
set(ENABLE_CURSES OFF CACHE BOOL "ncurses disabled for WASM" FORCE)
set(ENABLE_CURL OFF CACHE BOOL "cURL disabled (use WebSocket/Fetch instead)" FORCE)
set(ENABLE_LUAJIT OFF CACHE BOOL "LuaJIT disabled for WASM" FORCE)

# Force client build, disable server
set(BUILD_CLIENT ON CACHE BOOL "Client is required" FORCE)
set(RUN_IN_PLACE ON CACHE BOOL "RUN_IN_PLACE for WASM" FORCE)

# Compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17")
set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG "-g -O0 -s ASSERTIONS=1")

# Disable Link Time Optimization for Emscripten
set(ENABLE_LTO OFF CACHE BOOL "LTO disabled for Emscripten" FORCE)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION OFF)

# Message for verification
message(STATUS "Emscripten CMake Toolchain Loaded")
message(STATUS "  WASM Build: YES")
message(STATUS "  SDL2 Support: YES")
message(STATUS "  OpenGL → WebGL: Auto")
message(STATUS "  Memory: 512 MB → 2 GB")
