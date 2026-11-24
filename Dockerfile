ARG BASE_IMAGE=ubuntu:22.04
FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
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
    && mkdir -p /run/sshd \
    && rm -rf /var/lib/apt/lists/*

COPY banner.sh /usr/local/bin/vps

RUN chmod +x /usr/local/bin/vps \
    && printf '%s\n' '[ -t 1 ] && /usr/local/bin/vps' > /etc/profile.d/banner.sh \
    && touch /root/.hushlogin

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D", "-e"]