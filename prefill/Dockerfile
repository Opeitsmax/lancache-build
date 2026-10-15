FROM ubuntu:24.04

ARG TARGETARCH

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    ca-certificates \
    curl \
    unzip \
    libncursesw6 \
    locales \
    cron \
    tzdata \
    && sed -i '/en_US.UTF-8/s/^# //' /etc/locale.gen \
    && dpkg-reconfigure --frontend=noninteractive locales \
    && update-locale LANG=en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 \
    TERM=xterm-256color

ARG STEAM_PREFILL_VERSION=3.7.2
ARG EPIC_PREFILL_VERSION=2.1.0
ARG BATTLENET_PREFILL_VERSION=2.3.0

RUN if [ "$TARGETARCH" = "arm64" ]; then \
        ARCH_SUFFIX="linux-arm64"; \
    else \
        ARCH_SUFFIX="linux-x64"; \
    fi && \
    mkdir -p /app /Config && \
    curl -sSL "https://github.com/tpill90/steam-lancache-prefill/releases/download/v${STEAM_PREFILL_VERSION}/SteamPrefill-${STEAM_PREFILL_VERSION}-${ARCH_SUFFIX}.zip" -o /tmp/steam.zip && \
    unzip -q /tmp/steam.zip -d /app && \
    rm /tmp/steam.zip && \
    chmod +x /app/SteamPrefill && \
    ln -s /app/SteamPrefill /usr/local/bin/SteamPrefill && \
    curl -sSL "https://github.com/tpill90/epic-lancache-prefill/releases/download/v${EPIC_PREFILL_VERSION}/EpicPrefill-${EPIC_PREFILL_VERSION}-${ARCH_SUFFIX}.zip" -o /tmp/epic.zip && \
    unzip -q /tmp/epic.zip -d /app && \
    rm /tmp/epic.zip && \
    chmod +x /app/EpicPrefill && \
    ln -s /app/EpicPrefill /usr/local/bin/EpicPrefill && \
    curl -sSL "https://github.com/tpill90/battlenet-lancache-prefill/releases/download/v${BATTLENET_PREFILL_VERSION}/BattleNetPrefill-${BATTLENET_PREFILL_VERSION}-${ARCH_SUFFIX}.zip" -o /tmp/bnet.zip && \
    unzip -q /tmp/bnet.zip -d /app && \
    rm /tmp/bnet.zip && \
    chmod +x /app/BattleNetPrefill && \
    ln -s /app/BattleNetPrefill /usr/local/bin/BattleNetPrefill && \
    ln -s /Config /app/Config

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

VOLUME ["/Config"]

WORKDIR /app
ENTRYPOINT ["/app/entrypoint.sh"]
