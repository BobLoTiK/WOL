#!/data/data/com.termux/files/usr/bin/bash
source "$(dirname "$0")/../../config/config.sh"

if ssh -p "$RELAY_SSH_PORT" -o ConnectTimeout=5 "$RELAY_USER@$RELAY_IP" 'echo OK' > /dev/null 2>&1; then
  ssh -p "$RELAY_SSH_PORT" "$RELAY_USER@$RELAY_IP" '~/wol.sh'
else
  echo '❌ Домашний телефон не отвечает'
fi
