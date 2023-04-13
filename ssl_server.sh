#!/usr/bin/python3

import sys
import ssl
from http.server import HTTPServer, SimpleHTTPRequestHandler

if len( sys.argv ) < 3:
    print( "usage: ssl_server <IP> <port>" )
    exit( 1 )

ip   =      sys.argv[ 1 ]
port = int( sys.argv[ 2 ] )

httpd = HTTPServer( ( ip, port ), SimpleHTTPRequestHandler )

httpd.socket = ssl.wrap_socket(
                httpd.socket,
                keyfile     = "cert/ip_key.pem",
                certfile    = "cert/ip.pem",
                server_side = True
)

httpd.serve_forever()
