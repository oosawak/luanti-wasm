#!/usr/bin/env python3
"""
Luanti WASM ローカル確認用サーバー
WASM に必要な MIME type と COOP/COEP ヘッダーを付与して配信します

使い方:
  python3 emscripten/serve.py
  → http://localhost:8080 をブラウザで開く
"""

import http.server
import socketserver
import os

PORT = 8080
SERVE_DIR = os.path.join(os.path.dirname(__file__), '..', 'docs')

class WasmHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.abspath(SERVE_DIR), **kwargs)

    def end_headers(self):
        # WASM に必要な MIME type と SharedArrayBuffer 用ヘッダー
        self.send_header('Cross-Origin-Opener-Policy',   'same-origin')
        self.send_header('Cross-Origin-Embedder-Policy', 'require-corp')
        super().end_headers()

    def guess_type(self, path):
        mime, enc = super().guess_type(path)
        if path.endswith('.wasm'):
            mime = 'application/wasm'
        return mime, enc

    def log_message(self, fmt, *args):
        print(fmt % args)

print(f"========================================")
print(f"  Luanti WASM ローカルサーバー起動")
print(f"  http://localhost:{PORT}")
print(f"  Ctrl+C で停止")
print(f"========================================")

with socketserver.TCPServer(('', PORT), WasmHandler) as httpd:
    httpd.serve_forever()
