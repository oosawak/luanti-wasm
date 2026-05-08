# Luanti Emscripten WASM — インストール・ビルド手順

## 📋 実行スクリプト一覧

このディレクトリに以下の実行可能スクリプトがあります：

| スクリプト | 用途 | 実行 |
|-----------|------|------|
| **install-cmake.sh** | CMake 3.28.0 をインストール | ユーザーが実行 |
| **check-dependencies.sh** | 依存ツール・ライブラリをチェック | 必要に応じて実行 |
| **verify-setup.sh** | セットアップが完了したか確認 | ユーザーが実行 |
| **build.sh** | Luanti を WASM にビルド | ユーザーが実行 |

---

## 🚀 実行手順

### Step 1️⃣: CMake をインストール

```bash
cd /path/to/luanti
bash emscripten/install-cmake.sh
```

**スクリプトが実行すること:**
- CMake 3.28.0 を自動ダウンロード
- `~/.local/opt/cmake-3.28.0` にインストール
- PATH 設定コマンドを表示

**スクリプト実行後:**

表示されるコマンドを実行してください（例）：

```bash
export PATH="/home/user/.local/opt/cmake-3.28.0/bin:$PATH"
```

または `.bashrc`・`.zshrc` に追加。

---

### Step 2️⃣: セットアップ確認

```bash
bash emscripten/verify-setup.sh
```

**期待される出力:**

```
✓ Passed: 6
✗ Failed: 0
⚠ Warnings: 0

All requirements met! Ready to build.
```

---

### Step 3️⃣: ビルド実行

```bash
bash emscripten/build.sh
```

**ビルド時間:**
- 初回: 3～5 分（Emscripten キャッシュ生成）
- 2 回目以降: 1～2 分

**出力:**

```
build-emscripten/src/
├── luanti.js       # JavaScript ローダー
├── luanti.wasm     # WebAssembly バイナリ
└── luanti.data     # テクスチャ・モデルデータ
```

---

### Step 4️⃣: ブラウザテスト（オプション）

```bash
cd docs/wasm
python3 -m http.server 8080
```

ブラウザで **http://localhost:8080** を開く

---

## 🆘 問題が発生したら

### 「CMake インストールに失敗」

**原因:** ネットワーク接続が不安定、またはダウンロード URL が変更

**対応:** 手動ダウンロード後、スクリプト内の URL を編集してください

```bash
# emscripten/install-cmake.sh の以下の行を確認・編集
DOWNLOAD_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-linux-${ARCH_SUFFIX}.tar.gz"
```

### 「verify-setup.sh で CMake が見つからない」

**原因:** PATH が更新されていない

**対応:**

```bash
# PATH を設定したコマンドを再度実行
export PATH="/home/user/.local/opt/cmake-3.28.0/bin:$PATH"

# または .bashrc に追加後、シェルを再起動
source ~/.bashrc
```

### 「ビルド失敗」

**対応:** 以下を実行して再度トライ

```bash
rm -rf build-emscripten
bash emscripten/build.sh
```

---

## 📞 新しいツールが必要な場合

ビルド中にエラーが出て、**新しいツール・ライブラリが必要**になった場合：

1. **エラーメッセージを報告**
2. **新しいインストール用スクリプト**を作成
3. **ユーザーが実行**

という流れで対応します。

---

## ✨ まとめ

```bash
# 以下を順番に実行してください

# 1. CMake インストール
bash emscripten/install-cmake.sh

# （表示されたコマンドで PATH を設定）

# 2. セットアップ確認
bash emscripten/verify-setup.sh

# 3. ビルド
bash emscripten/build.sh

# 完了! 🎉
```

---

**何か問題が発生したら、エラーメッセージを教えてください！** 📢
