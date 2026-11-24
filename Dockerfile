
ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    openssh-server \
    curl \
    git \
    nano \
    sudo \
    ca-certificates \
    procps \
    hostname \
    figlet \
    toilet \
    neofetch \
    lolcat \
    && mkdir -p /run/sshd /root/.ssh \
    && chmod 700 /root/.ssh \
    && rm -rf /var/lib/apt/lists/*

# SSH configuration
RUN printf '%s\n' \
    'Port 22' \
    'PermitRootLogin prohibit-password' \
    'PubkeyAuthentication yes' \
    'PasswordAuthentication no' \
    'KbdInteractiveAuthentication no' \
    'AuthorizedKeysFile .ssh/authorized_keys' \
    'UsePAM yes' \
    > /etc/ssh/sshd_config

COPY banner.sh /usr/local/bin/vps

RUN chmod 755 /usr/local/bin/vps \
    && printf '%s\n' '[ -t 1 ] && /usr/local/bin/vps' \
    > /etc/profile.d/banner.sh \
    && ssh-keygen -A \
    && /usr/sbin/sshd -t

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]
