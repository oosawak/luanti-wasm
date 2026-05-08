#!/bin/bash
# Luanti Emscripten WASM - Environment Setup Verification Script

set +e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "=========================================="
echo "Luanti Emscripten WASM Setup Verification"
echo "=========================================="
echo ""

passed=0
failed=0
warning=0

# Function to check command availability
check_command() {
  local cmd=$1
  local name=$2
  local min_version=$3
  
  if command -v "$cmd" &> /dev/null; then
    version=$("$cmd" --version 2>&1 | head -1)
    echo -e "${GREEN}✓${NC} $name installed"
    echo "  → $version"
    ((passed++))
    return 0
  else
    echo -e "${RED}✗${NC} $name NOT found"
    ((failed++))
    return 1
  fi
}

# Function to check environment variable
check_env() {
  local var=$1
  local name=$2
  
  if [ -n "${!var}" ]; then
    echo -e "${GREEN}✓${NC} $name set"
    echo "  → ${!var}"
    ((passed++))
    return 0
  else
    echo -e "${YELLOW}⚠${NC} $name not set"
    echo "  → source /path/to/emsdk/emsdk_env.sh"
    ((warning++))
    return 1
  fi
}

echo "📦 Required Tools:"
echo ""

check_command cmake "CMake"
check_command git "Git"
check_command node "Node.js"
check_command python3 "Python 3"
check_command em++ "Emscripten C++ Compiler"

echo ""
echo "🔧 Environment Variables:"
echo ""

check_env EMSDK "EMSDK"
check_env EMSCRIPTEN "EMSCRIPTEN"

echo ""
echo "=========================================="
echo "Summary"
echo "=========================================="
echo -e "${GREEN}✓ Passed: $passed${NC}"
echo -e "${RED}✗ Failed: $failed${NC}"
echo -e "${YELLOW}⚠ Warnings: $warning${NC}"
echo ""

if [ $failed -eq 0 ] && [ $warning -eq 0 ]; then
  echo -e "${GREEN}All requirements met! Ready to build.${NC}"
  echo ""
  echo "Run build:"
  echo "  bash emscripten/build.sh"
  exit 0
elif [ $failed -eq 0 ]; then
  echo -e "${YELLOW}Most requirements met. Please fix warnings above.${NC}"
  echo ""
  echo "Activate Emscripten:"
  echo "  source /path/to/emsdk/emsdk_env.sh"
  echo ""
  echo "Then try again:"
  echo "  bash emscripten/verify-setup.sh"
  exit 1
else
  echo -e "${RED}Some requirements are missing. Please install them.${NC}"
  exit 1
fi
