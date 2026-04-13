FROM debian:trixie-slim AS molecule-debian13-systemd

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    systemd \
    systemd-sysv \
    udev \
    python3 \
    python3-apt \
    sudo \
    iproute2 \
    procps \
    curl \
    gnupg \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN find /etc/systemd/system \
         /lib/systemd/system \
         -path '*.wants/*' \
         \( \
           -name '*getty*' \
           -o -name '*apt-daily*' \
           -o -name '*systemd-timesyncd*' \
           -o -name '*systemd-resolved*' \
           -o -name '*e2scrub*' \
         \) \
         -exec rm -f {} \; ; true

RUN systemctl set-default multi-user.target || true

CMD ["/sbin/init"]
