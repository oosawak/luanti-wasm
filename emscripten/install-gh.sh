#!/bin/bash
# GitHub CLI (gh) インストールスクリプト
# 参考: https://cli.github.com/

set -e

echo "=========================================="
echo "  GitHub CLI (gh) インストール"
echo "=========================================="

# Ubuntu/Debian 向け公式インストール手順
# sudo 権限が必要です

# GPGキーとリポジトリを追加してaptでインストール
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg \
    | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg

sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg

echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" \
    | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null

sudo apt-get update
sudo apt-get install -y gh

echo ""
echo "=========================================="
echo "  インストール完了"
echo "=========================================="
gh --version

echo ""
echo "次のコマンドでログインしてください:"
echo "  gh auth login"
