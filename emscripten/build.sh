#!/bin/bash
# Build script for Luanti Emscripten WASM

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LUANTI_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="${LUANTI_ROOT}/build-emscripten"

echo "=========================================="
echo "Luanti Emscripten WASM Build"
echo "=========================================="
echo "Root: $LUANTI_ROOT"
echo "Build Dir: $BUILD_DIR"
echo ""

# Source Emscripten SDK
if [ -z "$EMSDK" ]; then
  echo "❌ EMSDK not set. Please activate Emscripten:"
  echo "   source /path/to/emsdk/emsdk_env.sh"
  exit 1
fi

echo "✓ Emscripten SDK: $EMSDK"
echo ""

# Create build directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

# Configure with Emscripten toolchain
echo "📦 Configuring CMake..."
emcmake cmake "$LUANTI_ROOT" \
  -DCMAKE_TOOLCHAIN_FILE="$SCRIPT_DIR/CMakeToolchain.cmake" \
  -DCMAKE_BUILD_TYPE=Release \
  -DBUILD_CLIENT=ON \
  -DBUILD_SERVER=OFF \
  -DBUILD_UNITTESTS=OFF \
  -DBUILD_BENCHMARKS=OFF \
  -DENABLE_SOUND=ON \
  -DENABLE_CURL=OFF \
  -DENABLE_GETTEXT=OFF

# Build
echo ""
echo "🔨 Building..."
emmake make -j$(nproc) luanti

echo ""
echo "✓ Build completed!"
echo ""
echo "Output:"
echo "  - Executable: $BUILD_DIR/src/luanti"
echo "  - WASM file: $BUILD_DIR/src/luanti.wasm"
echo "  - JS loader: $BUILD_DIR/src/luanti.js"
echo ""
