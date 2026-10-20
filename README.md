# 🖥️ Удалённое управление ПК через Android

Wake-on-LAN + SSH + Tailscale — бесплатно, из любой точки мира.

## 📚 Документация

1. [Настройка ПК (Windows)](docs/01-pc-windows.md)
2. [Домашний телефон — реле](docs/02-home-phone-relay.md)
3. [Основной телефон — клиент](docs/03-main-phone-client.md)
4. [Скрипты управления](docs/04-scripts.md)
5. [Использование](docs/05-usage.md)
6. [Troubleshooting](docs/06-troubleshooting.md)

## 🏗️ Архитектура

```
[Основной телефон] ➡️ (Tailscale VPN) ➡️ [Домашний телефон · реле] ➡️ (LAN + SSH) ➡️ [ПК]
```

## 🚀 Быстрый старт (на основном телефоне)

> Раздел — только про развёртывание проекта. Сначала выполните [часть 1](docs/01-pc-windows.md) (ПК) и [часть 2](docs/02-home-phone-relay.md) (реле), а на оба телефона поставьте Tailscale и Termux (F-Droid).

```bash
pkg update -y && pkg install -y openssh git
git clone https://github.com/BobLoTiK/WOL ~/pc-remote-control
cd ~/pc-remote-control
cp config/config.example.sh config/config.sh
nano config/config.sh            # свои IP/MAC/юзеров
chmod +x scripts/relay/*.sh scripts/client/*.sh config/*.sh
```

Дальше: скопировать `scripts/relay/wol.sh` на реле, настроить SSH-ключи и алиасы — [часть 3](docs/03-main-phone-client.md) и [часть 4](docs/04-scripts.md).

