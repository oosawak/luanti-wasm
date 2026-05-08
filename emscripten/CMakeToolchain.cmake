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

# Emscripten sysroot (prebuilt libraries live here)
set(EMSDK_ROOT "$ENV{EMSDK}")
if(NOT EMSDK_ROOT)
  set(EMSDK_ROOT "$ENV{HOME}/.emsdk")
endif()
set(EMSCRIPTEN_SYSROOT "${EMSDK_ROOT}/upstream/emscripten/cache/sysroot")

# Point CMake's find_* to Emscripten sysroot
set(CMAKE_FIND_ROOT_PATH "${EMSCRIPTEN_SYSROOT}")
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)

# Pre-set library paths so find_package(ZLIB/JPEG/PNG) find the sysroot versions
set(ZLIB_INCLUDE_DIR  "${EMSCRIPTEN_SYSROOT}/include"                                     CACHE PATH "ZLIB include")
set(ZLIB_LIBRARY      "${EMSCRIPTEN_SYSROOT}/lib/wasm32-emscripten/libz.a"                 CACHE FILEPATH "ZLIB lib")
set(JPEG_INCLUDE_DIR  "${EMSCRIPTEN_SYSROOT}/include"                                     CACHE PATH "JPEG include")
set(JPEG_LIBRARY      "${EMSCRIPTEN_SYSROOT}/lib/wasm32-emscripten/libjpeg.a"             CACHE FILEPATH "JPEG lib")
set(PNG_PNG_INCLUDE_DIR "${EMSCRIPTEN_SYSROOT}/include"                                   CACHE PATH "PNG include")
set(PNG_LIBRARY       "${EMSCRIPTEN_SYSROOT}/lib/wasm32-emscripten/libpng.a"              CACHE FILEPATH "PNG lib")
set(FREETYPE_INCLUDE_DIRS "${EMSCRIPTEN_SYSROOT}/include" "${EMSCRIPTEN_SYSROOT}/include/freetype2" CACHE STRING "Freetype includes")
set(FREETYPE_LIBRARY  "${EMSCRIPTEN_SYSROOT}/lib/wasm32-emscripten/libfreetype.a"         CACHE FILEPATH "Freetype lib")
set(SQLITE3_INCLUDE_DIR "${EMSCRIPTEN_SYSROOT}/include"                                   CACHE PATH "SQLite3 include")
set(SQLITE3_LIBRARY   "${EMSCRIPTEN_SYSROOT}/lib/wasm32-emscripten/libsqlite3.a"          CACHE FILEPATH "SQLite3 lib")
set(ZSTD_INCLUDE_DIR  "${EMSCRIPTEN_SYSROOT}/include"                                     CACHE PATH "Zstd include")
set(ZSTD_LIBRARY      "${EMSCRIPTEN_SYSROOT}/lib/libzstd.a"                               CACHE FILEPATH "Zstd lib")
# EGL is built into Emscripten's WebGL layer — no separate library needed
set(EGL_INCLUDE_DIR   "${EMSCRIPTEN_SYSROOT}/include"                                     CACHE PATH "EGL include")
set(EGL_LIBRARY       ""                                                                   CACHE FILEPATH "EGL lib (built into Emscripten)")

# WebGL / Emscripten link flags
set(EMSCRIPTEN_LINK_FLAGS
  "-s WASM=1"
  "-s FULL_ES3=1"
  "-s USE_SDL=2"
  "-s USE_ZLIB=1"
  "-s USE_LIBJPEG=1"
  "-s USE_LIBPNG=1"
  "-s ALLOW_MEMORY_GROWTH=1"
  "-s INITIAL_MEMORY=536870912"
  "-s MAXIMUM_MEMORY=2147483648"
  "-s ASYNCIFY=1"
  "-s ASSERTIONS=1"
  "-s ENVIRONMENT='web,worker'"
  "--preload-file ${CMAKE_SOURCE_DIR}/builtin@/builtin"
  "--preload-file ${CMAKE_SOURCE_DIR}/client@/client"
  "--preload-file ${CMAKE_SOURCE_DIR}/clientmods@/clientmods"
  "--preload-file ${CMAKE_SOURCE_DIR}/fonts@/fonts"
  "--preload-file ${CMAKE_SOURCE_DIR}/games@/games"
  "--preload-file ${CMAKE_SOURCE_DIR}/textures@/textures"
)

string(REPLACE ";" " " EMSCRIPTEN_LINK_FLAGS_STR "${EMSCRIPTEN_LINK_FLAGS}")

set(CMAKE_EXE_LINKER_FLAGS    "${EMSCRIPTEN_LINK_FLAGS_STR}")
set(CMAKE_SHARED_LINKER_FLAGS "${EMSCRIPTEN_LINK_FLAGS_STR}")
set(CMAKE_MODULE_LINKER_FLAGS "${EMSCRIPTEN_LINK_FLAGS_STR}")

# Also pass USE_* flags at compile time so headers are found via -include / port injection
set(CMAKE_C_FLAGS   "${CMAKE_C_FLAGS}   -s USE_ZLIB=1 -s USE_LIBJPEG=1 -s USE_LIBPNG=1 -s USE_SDL=2")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++17 -s USE_ZLIB=1 -s USE_LIBJPEG=1 -s USE_LIBPNG=1 -s USE_SDL=2")

set(CMAKE_CXX_FLAGS_RELEASE "-O3 -DNDEBUG")
set(CMAKE_CXX_FLAGS_DEBUG   "-g -O0 -s ASSERTIONS=1")

# Disable features not available in WebAssembly
set(BUILD_SERVER        OFF CACHE BOOL "Server not supported in WASM" FORCE)
set(BUILD_UNITTESTS     OFF CACHE BOOL "Tests not supported in WASM"  FORCE)
set(BUILD_BENCHMARKS    OFF CACHE BOOL "Benchmarks not supported in WASM" FORCE)
set(BUILD_DOCUMENTATION OFF CACHE BOOL "Documentation build skipped"  FORCE)

# Disable optional features for WASM compatibility
set(ENABLE_GETTEXT    OFF CACHE BOOL "GetText disabled for WASM"                  FORCE)
set(ENABLE_POSTGRESQL OFF CACHE BOOL "PostgreSQL disabled for WASM"               FORCE)
set(ENABLE_LEVELDB    OFF CACHE BOOL "LevelDB disabled for WASM"                  FORCE)
set(ENABLE_REDIS      OFF CACHE BOOL "Redis disabled for WASM"                    FORCE)
set(ENABLE_CURSES     OFF CACHE BOOL "ncurses disabled for WASM"                  FORCE)
set(ENABLE_CURL       OFF CACHE BOOL "cURL disabled (use WebSocket/Fetch instead)" FORCE)
set(ENABLE_LUAJIT     OFF CACHE BOOL "LuaJIT disabled for WASM"                   FORCE)
set(ENABLE_SOUND      OFF CACHE BOOL "Sound disabled for WASM (use Web Audio API)" FORCE)

# Force client build
set(BUILD_CLIENT  ON  CACHE BOOL "Client is required"    FORCE)
set(RUN_IN_PLACE  ON  CACHE BOOL "RUN_IN_PLACE for WASM" FORCE)

# Set install directories (normally set by UNIX/WIN32 detection, but Emscripten is neither)
set(SHAREDIR      "."       CACHE STRING "Share directory for WASM")
set(BINDIR        "bin"     CACHE STRING "Bin directory for WASM")
set(DOCDIR        "doc"     CACHE STRING "Doc directory for WASM")
set(EXAMPLE_CONF_DIR "."   CACHE STRING "Example config dir for WASM")
set(LOCALEDIR     "locale"  CACHE STRING "Locale directory for WASM")

# Disable Link Time Optimization for Emscripten
set(ENABLE_LTO                      OFF CACHE BOOL "LTO disabled for Emscripten" FORCE)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION OFF)

# Emscripten is always little-endian
set(WORDS_BIGENDIAN OFF CACHE BOOL "Emscripten uses little-endian" FORCE)

# Message for verification
message(STATUS "Emscripten CMake Toolchain Loaded")
message(STATUS "  WASM Build: YES")
message(STATUS "  SDL2 Support: YES")
message(STATUS "  OpenGL → WebGL: Auto")
message(STATUS "  Memory: 512 MB → 2 GB")
message(STATUS "  Sysroot: ${EMSCRIPTEN_SYSROOT}")
