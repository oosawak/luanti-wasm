#!/bin/bash
# Luanti Emscripten WASM — CMake インストール用スクリプト

set -e

echo "=========================================="
echo "CMake インストール用スクリプト"
echo "=========================================="
echo ""

# OS判定
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="linux"
  ARCH=$(uname -m)
  
  if [ "$ARCH" = "x86_64" ]; then
    ARCH_SUFFIX="x86_64"
  elif [ "$ARCH" = "aarch64" ]; then
    ARCH_SUFFIX="aarch64"
  else
    echo "❌ 対応していないアーキテクチャ: $ARCH"
    exit 1
  fi
  
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
  ARCH=$(uname -m)
  
  if [ "$ARCH" = "x86_64" ]; then
    ARCH_SUFFIX="x86_64"
  elif [ "$ARCH" = "arm64" ]; then
    ARCH_SUFFIX="aarch64"
  else
    echo "❌ 対応していないアーキテクチャ: $ARCH"
    exit 1
  fi
  
elif [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "cygwin" ]]; then
  echo "❌ Windows は手動インストールが必要です"
  echo "https://cmake.org/download/ からダウンロードしてください"
  exit 1
else
  echo "❌ 対応していない OS: $OSTYPE"
  exit 1
fi

echo "🔍 検出された環境:"
echo "  OS: $OS"
echo "  Architecture: $ARCH"
echo ""

# CMake バージョン
CMAKE_VERSION="3.28.0"
INSTALL_DIR="${HOME}/.local/opt/cmake-${CMAKE_VERSION}"

echo "📦 インストール情報:"
echo "  Version: $CMAKE_VERSION"
echo "  Install Dir: $INSTALL_DIR"
echo ""

# Linux インストール
if [ "$OS" = "linux" ]; then
  echo "📥 Linux: CMake バイナリをダウンロード中..."
  
  mkdir -p /tmp/cmake-install
  cd /tmp/cmake-install
  
  DOWNLOAD_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH_SUFFIX}.tar.gz"
  echo "  From: $DOWNLOAD_URL"
  
  if ! wget -q --show-progress "$DOWNLOAD_URL" -O cmake.tar.gz; then
    echo "❌ ダウンロード失敗"
    exit 1
  fi
  
  echo "📦 展開中..."
  tar xzf cmake.tar.gz
  
  mkdir -p "$INSTALL_DIR"
  cp -r cmake-${CMAKE_VERSION}-linux-${ARCH_SUFFIX}/* "$INSTALL_DIR/"
  
  echo "✅ インストール完了"
  echo ""
  echo "💻 以下のコマンドを実行して PATH に追加してください:"
  echo ""
  echo "  export PATH=\"${INSTALL_DIR}/bin:\$PATH\""
  echo ""
  echo "または .bashrc に以下を追加:"
  echo ""
  echo "  echo 'export PATH=\"${INSTALL_DIR}/bin:\$PATH\"' >> ~/.bashrc"
  echo "  source ~/.bashrc"
  echo ""

# macOS インストール
elif [ "$OS" = "macos" ]; then
  echo "📥 macOS: CMake バイナリをダウンロード中..."
  
  mkdir -p /tmp/cmake-install
  cd /tmp/cmake-install
  
  DOWNLOAD_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-macos-universal.tar.gz"
  echo "  From: $DOWNLOAD_URL"
  
  if ! curl -L --progress-bar "$DOWNLOAD_URL" -o cmake.tar.gz; then
    echo "❌ ダウンロード失敗"
    exit 1
  fi
  
  echo "📦 展開中..."
  tar xzf cmake.tar.gz
  
  mkdir -p "$INSTALL_DIR"
  cp -r cmake-${CMAKE_VERSION}-macos-universal/CMake.app/Contents/* "$INSTALL_DIR/"
  
  echo "✅ インストール完了"
  echo ""
  echo "💻 以下のコマンドを実行して PATH に追加してください:"
  echo ""
  echo "  export PATH=\"${INSTALL_DIR}/bin:\$PATH\""
  echo ""
  echo "または .zshrc に以下を追加:"
  echo ""
  echo "  echo 'export PATH=\"${INSTALL_DIR}/bin:\$PATH\"' >> ~/.zshrc"
  echo "  source ~/.zshrc"
  echo ""
fi

# インストール確認
echo "🔍 インストール確認..."
if "$INSTALL_DIR/bin/cmake" --version > /dev/null 2>&1; then
  echo "✅ CMake 正常にインストールされました"
  echo ""
  echo "Version:"
  "$INSTALL_DIR/bin/cmake" --version | head -1
  echo ""
  echo "PATH 設定後、以下を実行してください:"
  echo ""
  echo "  bash emscripten/verify-setup.sh"
  echo ""
else
  echo "❌ インストール失敗"
  exit 1
fi

# クリーンアップ
cd ~
rm -rf /tmp/cmake-install

echo "完了! ✨"
