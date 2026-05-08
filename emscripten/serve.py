#!/usr/bin/env python3
"""
Luanti WASM ローカル確認用サーバー（外部接続対応）
WASM に必要な MIME type と COOP/COEP ヘッダーを付与して配信します

使い方:
  python3 emscripten/serve.py          # デフォルト: 0.0.0.0:8080
  python3 emscripten/serve.py 9000     # ポート指定
"""

import http.server
import socketserver
import os
import sys
import socket

PORT = int(sys.argv[1]) if len(sys.argv) > 1 else 8080
SERVE_DIR = os.path.join(os.path.dirname(__file__), '..', 'docs')

class WasmHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=os.path.abspath(SERVE_DIR), **kwargs)

    def end_headers(self):
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

# ローカルIPアドレスを取得
def get_local_ip():
    try:
        s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        s.connect(('8.8.8.8', 80))
        ip = s.getsockname()[0]
        s.close()
        return ip
    except Exception:
        return '(取得できませんでした)'

local_ip = get_local_ip()

print(f"========================================")
print(f"  Luanti WASM サーバー起動 (全インターフェース)")
print(f"  ローカル:    http://localhost:{PORT}")
print(f"  外部接続:    http://{local_ip}:{PORT}")
print(f"  Ctrl+C で停止")
print(f"========================================")

# 0.0.0.0 にバインドして全インターフェースで待受
socketserver.TCPServer.allow_reuse_address = True
with socketserver.TCPServer(('0.0.0.0', PORT), WasmHandler) as httpd:
    httpd.serve_forever()
