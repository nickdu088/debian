FROM debian:bookworm-slim

LABEL org.opencontainers.image.source="https://github.com/nickdu088/debian"

# Set environment variables
ENV TZ=Asia/Shanghai \
    SSH_USER=debian \
    SSH_PASSWORD=debian!23

# Copy necessary scripts
COPY entrypoint.sh /entrypoint.sh
COPY reboot.sh /usr/local/sbin/reboot
COPY supervisord.conf /etc/supervisord.conf

# Install dependencies and Python 3.12
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y \
        tzdata \
        openssh-server \
        sudo \
        curl \
        ca-certificates \
        wget \
        vim \
        nano \
        nginx \
        net-tools \
        supervisor \
        cron \
        unzip \
        iputils-ping \
        telnet \
        git \
        iproute2 \
        gnupg2 \
        lsb-release \
        apt-transport-https \
        software-properties-common \
        --no-install-recommends && \
    # Add deadsnakes repository for Python 3.12
    echo "deb http://deb.debian.org/debian bookworm-backports main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install -y python3.12 python3.12-venv python3.12-dev && \
    # Clean up
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    # Set up Python 3.12 as default python3
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    # Verify Python version
    python3 --version && \
    # Prepare the SSH server
    mkdir /var/run/sshd && \
    chmod +x /entrypoint.sh && \
    chmod +x /usr/local/sbin/reboot && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Expose SSH port
EXPOSE 22 80

# Set the entry point and command
ENTRYPOINT ["/entrypoint.sh"]
CMD ["/usr/sbin/sshd", "-D"]
