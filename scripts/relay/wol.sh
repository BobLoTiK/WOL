#!/data/data/com.termux/files/usr/bin/python
import socket

MAC = "10-FF-E0-90-FC-7D"
BROADCAST = "192.168.1.255"

mac_bytes = bytes.fromhex(MAC.replace("-", "").replace(":", ""))
packet = b'\xff' * 6 + mac_bytes * 16

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
sock.sendto(packet, (BROADCAST, 9))
sock.close()
print("Magic packet sent to " + MAC)
