# Luanti Emscripten WASM — セットアップ＆ビルドガイド

## 🎯 目標
Luanti C++ クライアントを Emscripten で WASM 化し、ブラウザで動作させる。

---

## ✅ セットアップ状況

| 項目 | 状態 | 手順 |
|------|------|------|
| **Emscripten SDK 5.0.7** | ✅ 完了 | - |
| **Node.js 24.15.0** | ✅ 完了 | - |
| **Python 3.12.3** | ✅ 完了 | - |
| **Git 2.43.0** | ✅ 完了 | - |
| **CMake 3.12+** | ❌ 要インストール | 👇 下記参照 |

---

## 🚀 Step 1: CMake をインストール

CMake はビルドシステムです。以下の方法でインストールしてください：

### 方法 A: Snap を使用（推奨・簡単）
```bash
snap install cmake --classic
```

### 方法 B: バイナリをダウンロード
```bash
cd /tmp
wget https://github.com/Kitware/CMake/releases/download/v3.28.0/cmake-3.28.0-linux-x86_64.tar.gz
tar xzf cmake-3.28.0-linux-x86_64.tar.gz

# PATH に追加（毎回必要）
export PATH="/tmp/cmake-3.28.0-linux-x86_64/bin:$PATH"
```

### 確認
```bash
cmake --version
# → cmake version 3.28.0 ...
```

---

## 🔧 Step 2: セットアップ確認スクリプト実行

CMake インストール後、以下を実行：

```bash
cd /path/to/luanti
bash emscripten/verify-setup.sh
```

**期待される出力**:
```
✓ Passed: 6
✗ Failed: 0
⚠ Warnings: 0

All requirements met! Ready to build.
```

---

## 🔨 Step 3: ビルド実行

```bash
cd /path/to/luanti
bash emscripten/build.sh
```

### ビルド時間
- 初回: 3～5 分（Emscripten キャッシュ生成）
- 2 回目以降: 1～2 分

### 出力ファイル
```
build-emscripten/src/
├── luanti.js       # JavaScript ローダー
├── luanti.wasm     # WebAssembly バイナリ
└── luanti.data     # テクスチャ・モデルデータ
```

---

## 🌐 Step 4: ブラウザでテスト

ビルド後、以下を実行：

```bash
cd /path/to/luanti/docs/wasm
python3 -m http.server 8080
```

ブラウザで **http://localhost:8080** を開いてください。

（まだゲーム画面は出ません — 現在は Phase 1 なので、WebGL バックエンドの統合中です）

---

## 📋 次のフェーズ

| フェーズ | 内容 | 期間 |
|---------|------|------|
| **Phase 1** | ✅ ビルド環境整備 | 完了 |
| **Phase 2** | ライブラリ置き換え（グラフィックス・ネットワーク等） | 1～2週間 |
| **Phase 3** | WebSocket・ファイルシステム統合 | 3～5日 |
| **Phase 4** | Web UI・ローディング画面 | 2～3日 |
| **Phase 5** | ゲーム機能・バグ修正 | 1～2週間 |
| **Phase 6** | マルチプレイ・デプロイ | 2～3週間 |

---

## 🆘 トラブルシューティング

### "emcmake: cmake executable not found"
**原因**: CMake がインストールされていない
**解決**: Step 1 を参照

### "emcc: command not found"
**原因**: Emscripten が有効化されていない
**解決**:
```bash
source /tmp/emsdk/emsdk_env.sh
```

### "Permission denied"
**原因**: スクリプトが実行可能でない
**解決**:
```bash
chmod +x emscripten/*.sh
```

### ビルド失敗
**原因**: キャッシュが破損している
**解決**:
```bash
rm -rf build-emscripten
bash emscripten/build.sh
```

---

## 📞 お問い合わせ

セットアップ時に問題が生じた場合、以下を提供してください：

```bash
# システム情報
cmake --version
emcc --version
node --version
python3 --version

# ビルドログ
bash emscripten/build.sh 2>&1 | head -50
```

---

**準備完了！CMake をインストールしたら、再度ご連絡ください。** 🚀
