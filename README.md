# WOL
Удаленный запуск/выключение компа через переходник в виде домашнего телефона, находящегося в 1 сети wifi,что и комп

# 🖥️ Удалённое управление ПК через Android
### Wake-on-LAN + SSH + Tailscale — полностью бесплатно, из любой точки мира

---

## 🏗️ Архитектура

```
[Основной телефон] ➡️ (Tailscale VPN) ➡️ [Домашний телефон · реле] ➡️ (LAN + SSH) ➡️ [ПК]
```

> 💡 Публичный IP **не нужен** — всё работает через Tailscale.

---

## 📋 Что понадобится

| Компонент | Требования |
|---|---|
| 🖥️ **ПК** | Поддержка Wake-on-LAN, проводное подключение к роутеру |
| 📱 **Домашний телефон** | Android, тот же Wi-Fi, что у ПК — работает как «мост» |
| 📱 **Основной телефон** | Android, с него ведётся управление |
| 🌐 **Сеть** | Tailscale (бесплатный аккаунт) |

---

# 🖥️ Часть 1 — Настройка ПК (Windows)

## 1.1 · BIOS/UEFI

| Параметр | Значение | Зачем |
|---|---|---|
| `ErP` / `ErP Ready` | **Disabled** | ⚡ Критично: без этого сетевая карта не получает питание после выключения |
| `Wake on LAN` / `Power On By PCI-E` | **Enabled** | Разрешает пробуждение по сети |

Сохраните настройки: **F10**

## 1.2 · Windows

**Отключите «Быстрый запуск»:**
```
Панель управления ➡️ Электропитание ➡️ Действия кнопок питания
➡️ Изменение параметров, которые сейчас недоступны
➡️ Снимите галочку «Включить быстрый запуск»
```

**Настройте сетевую карту:**
```
Диспетчер устройств ➡️ Сетевые адаптеры ➡️ Свойства Ethernet-адаптера
```

- **Управление электропитанием** → разрешить вывод из ждущего режима + только магическому пакету
- **Дополнительно** → `Wake on Magic Packet` = **Enabled**

## 1.3 · SSH-сервер на Windows

**Установка:**
```
Параметры ➡️ Система ➡️ Дополнительные компоненты ➡️ Просмотреть компоненты
➡️ «Служба OpenSSH Server»
```

**Запуск (PowerShell от администратора):**
```powershell
Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'
```

**Брандмауэр:**
```powershell
New-NetFirewallRule -Name sshd -DisplayName 'OpenSSH Server (sshd)' `
  -Enabled True -Direction Inbound -Protocol TCP -Action Allow -LocalPort 22
```

**Узнайте IP и MAC:**
```cmd
ipconfig /all
```
> 📝 Запишите `IPv4-адрес` (например, `192.168.1.55`) и `Физический адрес` (MAC, например, `10-FF-E0-90-FC-7D`).

---

# 📱 Часть 2 — Домашний телефон (Реле)

## 2.1 · Приложения

1. **Tailscale** — войдите в аккаунт (APK с офиц. сайта, если нет в Play Store)
2. **Termux** + **Termux:API** — ⚠️ только с **F-Droid**, не из Google Play!

## 2.2 · Termux и скрипт WOL

```bash
pkg update -y && pkg install -y python openssh termux-api
passwd   # задайте пароль для SSH
```

**Создайте скрипт:**
```bash
nano ~/wol.sh
```

```python
#!/data/data/com.termux/files/usr/bin/python

import socket

MAC = "10-FF-E0-90-FC-7D"          # ← ваш MAC
BROADCAST = "192.168.1.255"        # ← обычно .255 от IP ПК

mac_bytes = bytes.fromhex(MAC.replace("-", "").replace(":", ""))
packet = b'\xff' * 6 + mac_bytes * 16

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
sock.sendto(packet, (BROADCAST, 9))
sock.close()

print("Magic packet sent to " + MAC)
```

**Сохраните** (`Ctrl+X`, `Y`, `Enter`) **и сделайте исполняемым:**
```bash
chmod +x ~/wol.sh
```

## 2.3 · Запуск SSH и защита от выгрузки

```bash
sshd
termux-wake-lock
```

> ⚠️ **Важно:** в настройках Android для **Termux** и **Tailscale** выставьте режим батареи **«Без ограничений»** — иначе система убьёт процессы и связь оборвётся.

---

# 📱 Часть 3 — Основной телефон (Клиент)

1. **Tailscale** — войдите в **тот же** аккаунт
2. **Termux** (из F-Droid)

```bash
pkg update -y && pkg install -y openssh
```

## 3.1 · Беспарольный доступ (SSH-ключи)

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

---

# 📜 Часть 4 — Скрипты управления

```bash
mkdir -p ~/.shortcuts && cd ~/.shortcuts
```

## 4.1 · Включение (WOL) — `wake_pc.sh`

```bash
#!/data/data/com.termux/files/usr/bin/bash
# Замените IP и юзернейм на свои
if ssh -p 8022 -o ConnectTimeout=5 u0_a222@100.65.156.38 'echo OK' > /dev/null 2>&1; then
  ssh -p 8022 u0_a222@100.65.156.38 '~/wol.sh'
else
  echo '❌ Домашний телефон не отвечает'
fi
```

## 4.2 · Выключение — `shutdown_pc.sh`

```bash
#!/data/data/com.termux/files/usr/bin/bash
if ssh -p 8022 -o ConnectTimeout=5 u0_a222@100.65.156.38 'echo OK' > /dev/null 2>&1; then
  ssh -t -p 8022 u0_a222@100.65.156.38 "ssh максим@192.168.1.55 'shutdown /s /t 0'"
else
  echo '❌ Домашний телефон не отвечает'
fi
```

## 4.3 · Перезагрузка и сон

| Файл | Команда на ПК |
|---|---|
| `reboot_pc.sh` | `shutdown /r /t 0` |
| `sleep_pc.sh` | `rundll32.exe powrprof.dll,SetSuspendState 0,1,0` |

## 4.4 · Алиасы для быстрого вызова

```bash
echo "alias wake='bash ~/.shortcuts/wake_pc.sh'"      >> ~/.bashrc
echo "alias shutup='bash ~/.shortcuts/shutdown_pc.sh'" >> ~/.bashrc
echo "alias reboot='bash ~/.shortcuts/reboot_pc.sh'"   >> ~/.bashrc
echo "alias sleep='bash ~/.shortcuts/sleep_pc.sh'"     >> ~/.bashrc
source ~/.bashrc
```

---

# 🚀 Использование

При включённом Tailscale на **обоих** телефонах доступны команды:

| Команда | Действие |
|---|---|
| `wake` | 🟢 Включить ПК (из выключенного/сна) |
| `shutup` | 🔴 Выключить ПК |
| `reboot` | 🔄 Перезагрузить ПК |
| `sleep` | 🌙 Спящий режим |

**Проверка связи вручную:**
```bash
# Связь с домашним телефоном
ssh -p 8022 u0_a222@100.65.156.38 'echo OK'

# Связь с ПК (через реле)
ssh -t -p 8022 u0_a222@100.65.156.38 "ssh максим@192.168.1.55 'echo OK'"
```

---

# ⚠️ Известные ограничения

| # | Проблема | Решение |
|---|---|---|
| 1 | Порт SSH в Termux | Всегда **8022**, не 22 |
| 2 | `Permission denied` | Права `authorized_keys` = **600**, ключ одной строкой |
| 3 | ПК не пингуется | Норма — брандмауэр блокирует ICMP. Ориентируйтесь на SSH |
| 4 | Сторонний VPN на ПК | Может ронять Tailscale (ограничение Android) — отключите VPN или используйте `tailscale-termux-cli` |
| 5 | Два вложенных SSH | Обязателен флаг `-t` (псевдотерминал), иначе команды не выполнятся |

---

> ✨ **Итог:** один раз настроили — и с любого места в мире включаете, выключаете, перезагружаете и усыпляете ПК с телефона. Всё бесплатно, без публичного IP и проброса портов.
