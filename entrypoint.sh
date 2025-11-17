#!/bin/bash

# Запускаем tailscaled (с системным tun)
/usr/sbin/tailscaled &

# Ждём запуск демона
sleep 3

# Логинимся через authkey
tailscale up --authkey=${TS_AUTHKEY} --accept-dns=true --accept-routes=true

# Показываем IP
tailscale ip -4

# Держим контейнер активным
exec /bin/bash
