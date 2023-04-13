import sys
import ssl
from http.server import HTTPServer, SimpleHTTPRequestHandler

httpd = HTTPServer( ( ip, port ), SimpleHTTPRequestHandler )

httpd.socket = ssl.wrap_socket(
                httpd.socket,
                keyfile     = "cert/ip_key.pem",
                certfile    = "cert/ip.pem",
                server_side = True
)

httpd.serve_forever()
