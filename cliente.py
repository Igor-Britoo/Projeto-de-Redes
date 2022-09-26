#!/usr/bin/env python3

import socket

HOST = '127.0.0.1'
PORT = 50000

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.connect((HOST, PORT))
msg = input("Digite uma mensagem:")
s.sendall(str.encode(msg))
data = s.recv(1024)

print('Mensagem ecoada: ', data.decode())

