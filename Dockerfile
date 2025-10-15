FROM alpine:latest

LABEL org.opencontainers.image.source="https://github.com/nickdu088/debian"

# Set environment variables
ENV TZ=Asia/Shanghai \
    SSH_USER=debian \
    SSH_PASSWORD=debian!23

# Copy necessary scripts
COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot
COPY supervisord.conf /etc/supervisord.conf

# Install dependencies
RUN apk update && apk add --no-cache \
        tzdata \
        openssh \
        sudo \
        curl \
        ca-certificates \
        wget \
        vim \
        nano \
        nginx \
        net-tools \
        supervisor \
        sqlite \
        python3 \
        py3-pip \
        bash \
        iputils \
        iproute2 \
        git \
        shadow \
        unzip \
        bind-tools \
        && \
    # Set timezone
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Add SSH user
    adduser -D -s /bin/bash $SSH_USER && \
    echo "$SSH_USER:$SSH_PASSWORD" | chpasswd && \
    echo "$SSH_USER ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    # Create SSH dir
    mkdir -p /var/run/sshd && \
    chmod +x /entrypoint.sh && \
    chmod +x /usr/local/sbin/reboot

EXPOSE 22 80

ENTRYPOINT ["/entrypoint.sh"]
