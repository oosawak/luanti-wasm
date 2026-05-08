#!/bin/bash
# Luanti Emscripten WASM — 環境変数自動設定スクリプト

echo "=========================================="
echo "環境変数設定スクリプト"
echo "=========================================="
echo ""

# CMake パス
CMAKE_PATH="${HOME}/.local/opt/cmake-3.28.0/bin"
EMSDK_PATH="/tmp/emsdk"

echo "🔧 設定する環境変数："
echo ""
echo "  CMAKE_PATH:   $CMAKE_PATH"
echo "  EMSDK_PATH:   $EMSDK_PATH"
echo ""

# PATH に CMake を追加
if [ -d "$CMAKE_PATH" ]; then
  if [[ ":$PATH:" == *":$CMAKE_PATH:"* ]]; then
    echo "✅ CMake は既に PATH に設定されています"
  else
    echo "➕ CMake を PATH に追加..."
    export PATH="$CMAKE_PATH:$PATH"
    echo "  done!"
  fi
else
  echo "❌ CMake が見つかりません: $CMAKE_PATH"
  exit 1
fi

# Emscripten SDK を有効化
if [ -d "$EMSDK_PATH" ]; then
  echo "➕ Emscripten SDK を有効化..."
  source "$EMSDK_PATH/emsdk_env.sh" > /dev/null 2>&1
  echo "  done!"
else
  echo "❌ Emscripten SDK が見つかりません: $EMSDK_PATH"
  exit 1
fi

echo ""
echo "=========================================="
echo "確認"
echo "=========================================="
echo ""

cmake --version 2>&1 | head -1 && echo "  ✅ CMake OK" || echo "  ❌ CMake NG"
emcc --version 2>&1 | head -1 && echo "  ✅ Emscripten OK" || echo "  ❌ Emscripten NG"

echo ""
echo "✅ 設定完了!"
echo ""
echo "次に以下を実行："
echo "  bash emscripten/verify-setup.sh"
echo ""
