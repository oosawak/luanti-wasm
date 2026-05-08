#!/bin/bash
# Emscripten SDK インストール・セットアップスクリプト

set -e

echo "=========================================="
echo "Emscripten SDK セットアップ"
echo "=========================================="

EMSDK_DIR="${HOME}/.emsdk"
EMSDK_VERSION="5.0.7"  # 前に使った版

echo "📦 Installation directory: $EMSDK_DIR"
echo "📦 Version: $EMSDK_VERSION"
echo ""

# emsdk clone
if [ ! -d "$EMSDK_DIR" ]; then
    echo "📥 Cloning emscripten-core/emsdk..."
    git clone https://github.com/emscripten-core/emsdk.git "$EMSDK_DIR"
    cd "$EMSDK_DIR"
else
    echo "✓ emsdk directory already exists"
    cd "$EMSDK_DIR"
    git pull origin main
fi

echo ""
echo "🔧 Installing Emscripten $EMSDK_VERSION..."

# emsdk latest でセットアップ
./emsdk install $EMSDK_VERSION
./emsdk activate $EMSDK_VERSION

echo ""
echo "✅ Emscripten セットアップ完了"
echo ""
echo "💻 以下を実行して環境変数を設定:"
echo ""
echo "  source ~/.emsdk/emsdk_env.sh"
echo ""
echo "または .bashrc に以下を追加:"
echo ""
echo "  echo 'source ~/.emsdk/emsdk_env.sh' >> ~/.bashrc"
echo "  source ~/.bashrc"
echo ""

# セットアップの確認
source "$EMSDK_DIR/emsdk_env.sh"

echo "🔍 検証中..."
emcc --version
echo ""
echo "✓ Emscripten ready!"
