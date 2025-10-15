#!/usr/bin/env sh

# Create user if not exists
if ! id "$SSH_USER" >/dev/null 2>&1; then
    adduser -D -s /bin/sh "$SSH_USER"
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd
    addgroup "$SSH_USER" wheel
    echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$SSH_USER
fi

# Harden SSH: Disable root login
echo 'PermitRootLogin no' >> /etc/ssh/sshd_config

# Generate SSH host keys if missing
ssh-keygen -A

# Start supervisord
exec /usr/bin/supervisord -c /etc/supervisord.conf
