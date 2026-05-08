# Luanti Emscripten WASM — セットアップガイド

このドキュメントでは、Luanti を WASM 化するために必要な環境セットアップを説明します。

---

## 📋 必須要件

| ツール | バージョン | 用途 | 状態 |
|--------|-----------|------|------|
| **CMake** | 3.12+ | ビルドシステム | ⚠️ 要インストール |
| **Emscripten SDK** | 5.0+ | WASM コンパイラ | ✅ セットアップ済み |
| **Node.js** | 14+ | WASM ローダー・開発サーバー | ✅ インストール済み |
| **Git** | - | リポジトリ管理 | ✅ インストール済み |
| **C++ コンパイラ** | - | Emscripten 内部で使用 | ✅ インストール済み |
| **Python** | 3.6+ | ビルド補助 | ✅ インストール済み |

---

## 🚀 セットアップ手順

### Step 1: CMake をインストール

**Linux (Ubuntu/Debian)**:
```bash
# Snap を使用（APT が使えない場合）
snap install cmake --classic

# または、バイナリダウンロード
cd /tmp
wget https://github.com/Kitware/CMake/releases/download/v3.28.0/cmake-3.28.0-linux-x86_64.tar.gz
tar xzf cmake-3.28.0-linux-x86_64.tar.gz
export PATH="/tmp/cmake-3.28.0-linux-x86_64/bin:$PATH"
```

**macOS**:
```bash
brew install cmake
```

**Windows**:
```powershell
choco install cmake
# または https://cmake.org/download/ からダウンロード
```

**確認**:
```bash
cmake --version
# → cmake version 3.28.0
```

---

### Step 2: Emscripten SDK を有効化

毎回のビルド前に、Emscripten 環境を有効化します：

```bash
source /path/to/emsdk/emsdk_env.sh
```

**確認**:
```bash
emcmake --version
# → emcmake is a helper for cmake, setting various environment variables...
```

---

### Step 3: Luanti WASM ビルド用スクリプト実行

```bash
cd /path/to/luanti/emscripten
./build.sh
```

---

## ✅ インストール確認スクリプト

以下のスクリプトを実行して、すべての依存がインストール済みか確認します：

```bash
bash emscripten/verify-setup.sh
```

---

## 🔧 トラブルシューティング

### "emcmake: cmake executable not found"
→ CMake がインストールされていません。上記 Step 1 を参照してください。

### "emcc: command not found"
→ Emscripten が有効化されていません。以下を実行：
```bash
source /path/to/emsdk/emsdk_env.sh
```

### ビルド中に "Permission denied"
→ `build-emscripten/` ディレクトリを削除して再度実行：
```bash
rm -rf build-emscripten
bash emscripten/build.sh
```

---

## 📦 出力ファイル

ビルド成功時、以下のファイルが生成されます：

```
build-emscripten/src/
├── luanti.js          # JavaScript loader + Emscripten runtime
├── luanti.wasm        # WebAssembly binary (core logic)
└── luanti.data        # Assets (textures, models, etc.)
```

これらを `docs/wasm/` にコピーしてブラウザで実行できます。

---

## 🌐 ブラウザでテスト

```bash
cd docs/wasm
python3 -m http.server 8080
# → ブラウザで http://localhost:8080 を開く
```

---

**必要なツールがあれば、都度スクリプトを作成します！**
