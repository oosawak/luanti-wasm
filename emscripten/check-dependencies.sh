#!/bin/bash
# Luanti Emscripten WASM — 必須ライブラリインストール用スクリプト
# （将来的に必要になった場合用）

set -e

echo "=========================================="
echo "Luanti WASM — ライブラリ確認・インストール"
echo "=========================================="
echo ""

# OS判定
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OS="ubuntu"
  PACKAGE_MANAGER="apt"
elif [[ "$OSTYPE" == "darwin"* ]]; then
  OS="macos"
  PACKAGE_MANAGER="brew"
else
  echo "❌ 対応していない OS"
  exit 1
fi

echo "🔍 OS: $OS"
echo "📦 パッケージマネージャー: $PACKAGE_MANAGER"
echo ""

# Ubuntu の場合
if [ "$OS" = "ubuntu" ]; then
  echo "📋 以下のパッケージが必要です:"
  echo ""
  
  PACKAGES=(
    "build-essential"     # gcc, g++, make
    "git"                 # version control
    "curl"                # HTTP client
    "wget"                # file download
    "python3"             # Python
    "python3-pip"         # pip
  )
  
  for pkg in "${PACKAGES[@]}"; do
    if dpkg -l | grep "^ii  $pkg" > /dev/null 2>&1; then
      echo "  ✅ $pkg (インストール済み)"
    else
      echo "  ❌ $pkg (要インストール)"
    fi
  done
  
  echo ""
  echo "⚠️  Ubuntu/Debian ではパッケージマネージャーが sudo を必要とします。"
  echo "以下を実行してください:"
  echo ""
  echo "  sudo apt-get update"
  echo "  sudo apt-get install -y build-essential git curl wget python3 python3-pip"
  echo ""
  
# macOS の場合
elif [ "$OS" = "macos" ]; then
  echo "📋 以下のツールが必要です:"
  echo ""
  
  TOOLS=(
    "gcc"
    "git"
    "curl"
    "wget"
    "python3"
  )
  
  for tool in "${TOOLS[@]}"; do
    if command -v "$tool" &> /dev/null; then
      echo "  ✅ $tool (インストール済み)"
    else
      echo "  ❌ $tool (要インストール)"
    fi
  done
  
  echo ""
  echo "📦 Homebrew を使用してインストール:"
  echo ""
  echo "  brew install gcc git curl wget python3"
  echo ""
fi

echo "=========================================="
echo "✨ セットアップ手順"
echo "=========================================="
echo ""
echo "1️⃣  必須ライブラリをインストール（上記を参照）"
echo ""
echo "2️⃣  CMake をインストール"
echo "   bash emscripten/install-cmake.sh"
echo ""
echo "3️⃣  セットアップ確認"
echo "   bash emscripten/verify-setup.sh"
echo ""
echo "4️⃣  ビルド実行"
echo "   bash emscripten/build.sh"
echo ""
