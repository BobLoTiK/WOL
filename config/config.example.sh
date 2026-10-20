#!/data/data/com.termux/files/usr/bin/bash
# Скопируйте в config.sh и заполните своими значениями

# --- Домашний телефон (реле) ---
RELAY_USER="u0_a000"                 # имя пользователя Termux
RELAY_IP="100.64.0.1"                # Tailscale IP домашнего телефона
RELAY_SSH_PORT="8022"

# --- ПК ---
PC_USER="user"                       # имя пользователя Windows
PC_IP="192.168.1.100"                # IPv4-адрес ПК в локальной сети
PC_MAC="AA-BB-CC-DD-EE-FF"           # MAC-адрес Ethernet-адаптера ПК
PC_BROADCAST="192.168.1.255"         # широковещательный адрес подсети
