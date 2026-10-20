# 📱 Часть 2 — Домашний телефон (Реле)

## 2.1 · Приложения

1. **Tailscale** — войдите в аккаунт (APK с офиц. сайта, если нет в Play Store)
2. **Termux** + **Termux:API** — ⚠️ только с **F-Droid**, не из Google Play!

## 2.2 · Termux и скрипт WOL

```bash
pkg update -y && pkg install -y python openssh termux-api
passwd   # задайте пароль для SSH
```

**Скопируйте `scripts/relay/wol.sh` на телефон** (через `scp`, Git или `nano`), затем:

```bash
chmod +x ~/wol.sh
```

> 💡 Скрипт должен лежать именно в `~/wol.sh` — клиент вызывает его как `~/wol.sh`.
> MAC и широковещательный адрес в нём — те же, что в `config/config.sh`.

## 2.3 · Запуск SSH и защита от выгрузки

```bash
sshd
termux-wake-lock
```

> ⚠️ **Важно:** в настройках Android для **Termux** и **Tailscale** выставьте режим батареи **«Без ограничений»** — иначе система убьёт процессы и связь оборвётся.
