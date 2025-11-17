FROM ubuntu:noble

# Установим зависимости
RUN apt-get update && apt-get install -y \
    curl sudo gnupg2 passwd iproute2

# Добавим ключ и репозиторий Tailscale (noble)
RUN curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.noarmor.gpg \
      | tee /usr/share/keyrings/tailscale-archive-keyring.gpg >/dev/null && \
    curl -fsSL https://pkgs.tailscale.com/stable/ubuntu/noble.tailscale-keyring.list \
      | tee /etc/apt/sources.list.d/tailscale.list

# Установка Tailscale
RUN apt-get update && apt-get install -y tailscale

# Создаем пользователя ray с sudo доступом к tailscale
RUN useradd -m ray && echo "ray:ray" | chpasswd && \
    echo "ray ALL=(ALL) NOPASSWD: /usr/bin/tailscale" > /etc/sudoers.d/ray

# Копируем entrypoint
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]
