# 📜 Часть 4 — Скрипты управления

Все скрипты читают переменные из `config/config.sh`.

## Список

| Файл | Что делает |
|---|---|
| `scripts/relay/wol.sh` | Отправляет magic packet (запускается на домашнем телефоне) |
| `scripts/client/wake_pc.sh` | 🟢 Включить ПК |
| `scripts/client/shutdown_pc.sh` | 🔴 Выключить ПК |
| `scripts/client/reboot_pc.sh` | 🔄 Перезагрузить ПК |
| `scripts/client/sleep_pc.sh` | 🌙 Спящий режим |

## Алиасы (в `~/.bashrc` основного телефона)

```bash
PROJ=~/pc-remote-control
echo "alias wake='bash $PROJ/scripts/client/wake_pc.sh'"      >> ~/.bashrc
echo "alias shutup='bash $PROJ/scripts/client/shutdown_pc.sh'" >> ~/.bashrc
echo "alias reboot='bash $PROJ/scripts/client/reboot_pc.sh'"   >> ~/.bashrc
echo "alias sleep='bash $PROJ/scripts/client/sleep_pc.sh'"     >> ~/.bashrc
source ~/.bashrc
```

## Права на исполнение в Git

Windows не хранит unix-права, поэтому после `git add` отметьте скрипты как исполняемые:

```bash
git add .
git update-index --chmod=+x scripts/relay/wol.sh scripts/client/*.sh config/*.sh
```
