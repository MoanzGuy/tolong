
ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Jakarta

# ==========================================
# INSTALL PACKAGES
# ==========================================
RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    curl \
    wget \
    git \
    nano \
    vim \
    sudo \
    ca-certificates \
    procps \
    hostname \
    iproute2 \
    net-tools \
    dnsutils \
    figlet \
    toilet \
    neofetch \
    lolcat \
    tzdata \
    && mkdir -p /run/sshd /root/.ssh \
    && chmod 700 /root/.ssh \
    && rm -rf /var/lib/apt/lists/*

# ==========================================
# SSH CONFIGURATION
# ==========================================
RUN printf '%s\n' \
    'Port 2222' \
    'AddressFamily any' \
    'ListenAddress 0.0.0.0' \
    'ListenAddress ::' \
    'PermitRootLogin prohibit-password' \
    'PubkeyAuthentication yes' \
    'PasswordAuthentication no' \
    'KbdInteractiveAuthentication no' \
    'AuthorizedKeysFile .ssh/authorized_keys' \
    'UsePAM yes' \
    'PrintMotd yes' \
    'ClientAliveInterval 60' \
    'ClientAliveCountMax 3' \
    'X11Forwarding no' \
    'AllowTcpForwarding yes' \
    'Subsystem sftp /usr/lib/openssh/sftp-server' \
    > /etc/ssh/sshd_config

# ==========================================
# SSH AUTHORIZED KEYS
# ==========================================
RUN touch /root/.ssh/authorized_keys \
    && chmod 600 /root/.ssh/authorized_keys

# ==========================================
# BANNER
# ==========================================
COPY banner.sh /usr/local/bin/vps

RUN chmod 755 /usr/local/bin/vps \
    && printf '%s\n' \
       '[ -t 1 ] && /usr/local/bin/vps' \
       > /etc/profile.d/banner.sh

# ==========================================
# SSH HOST KEYS & VALIDATION
# ==========================================
RUN ssh-keygen -A \
    && /usr/sbin/sshd -t \
    && grep -q '^Port 2222$' /etc/ssh/sshd_config \
    && echo "SSH CONFIGURATION VALID"

# ==========================================
# ENVIRONMENT
# ==========================================
WORKDIR /root

EXPOSE 2222

# ==========================================
# START SSH SERVER
# ==========================================
CMD ["/usr/sbin/sshd", "-D", "-e"]
