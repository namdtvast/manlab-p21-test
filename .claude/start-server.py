#!/usr/bin/env python3
"""Start HTTP server, respecting PORT environment variable"""
import os
import sys
from http.server import HTTPServer, SimpleHTTPRequestHandler

port = int(os.getenv('PORT', '8000'))
handler = SimpleHTTPRequestHandler

with HTTPServer(('', port), handler) as httpd:
    print(f"Server running at http://localhost:{port}/", file=sys.stderr)
    httpd.serve_forever()
