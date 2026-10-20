# 📱 Часть 3 — Основной телефон (Клиент)

1. **Tailscale** — войдите в **тот же** аккаунт
2. **Termux** (из F-Droid)

```bash
pkg update -y && pkg install -y openssh git
```

## 3.1 · Клонирование проекта

```bash
git clone https://github.com/BobLoTiK/WOL ~/pc-remote-control
cd ~/pc-remote-control
cp config/config.example.sh config/config.sh
nano config/config.sh          # вписать свои IP/MAC/юзеров
chmod +x scripts/relay/*.sh scripts/client/*.sh config/*.sh
```

## 3.2 · Беспарольный доступ (SSH-ключи)

**На основном телефоне:**
```bash
ssh-keygen -t rsa -b 4096       # Enter × 3
cat ~/.ssh/id_rsa.pub           # скопируйте вывод
```

**На домашнем телефоне** (физически или по паролю):
```bash
mkdir -p ~/.ssh
nano ~/.ssh/authorized_keys     # вставьте ключ ОДНОЙ строкой
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
```
