#!/bin/bash
# Luanti WASM ビルドに必要な追加ライブラリのインストール
# 実行には sudo 権限が必要です

set -e

echo "=========================================="
echo "Luanti WASM 追加ライブラリ インストール"
echo "=========================================="
echo ""
echo "インストール対象:"
echo "  - libssl-dev    (OpenSSL >= 3.0)"
echo "  - libzstd-dev   (Zstd 圧縮ライブラリ)"
echo ""

apt-get update -qq

echo "📦 OpenSSL (libssl-dev) をインストール中..."
apt-get install -y libssl-dev

echo "📦 Zstd (libzstd-dev) をインストール中..."
apt-get install -y libzstd-dev

echo ""
echo "=========================================="
echo "✅ インストール完了"
echo "=========================================="
echo ""
echo "インストールされたバージョン:"
dpkg -l libssl-dev libzstd-dev | grep "^ii" | awk '{print "  " $2 ": " $3}'
echo ""
echo "次のステップ:"
echo "  bash /home/oosawak/Workspace/luanti/emscripten/build.sh"
