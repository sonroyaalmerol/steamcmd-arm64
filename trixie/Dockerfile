# syntax=docker/dockerfile:1
FROM arm64v8/debian:trixie-slim AS base-setup
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install common dependencies and setup Box64/Box86 repositories once
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates wget gnupg \
    && wget -qO- https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
    && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
    && wget -qO- https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list \
    && wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg \
    && apt-get update

# --- Binary Extraction Stages ---
FROM base-setup AS bin_m1
RUN apt-get install -y box64-m1 && cp /usr/local/bin/box64 /box64-m1

FROM base-setup AS bin_rpi5
RUN apt-get install -y box64-rpi5arm64 && cp /usr/local/bin/box64 /box64-rpi5

FROM base-setup AS bin_rpi5_16k
RUN apt-get install -y box64-rpi5arm64ps16k && cp /usr/local/bin/box64 /box64-rpi5-16k

FROM base-setup AS bin_rpi4
RUN apt-get install -y box64-rpi4arm64 && cp /usr/local/bin/box64 /box64-rpi4

FROM base-setup AS bin_rpi3
RUN apt-get install -y box64-rpi3arm64 && cp /usr/local/bin/box64 /box64-rpi3

FROM base-setup AS bin_rk3588
RUN apt-get install -y box64-rk3588 && cp /usr/local/bin/box64 /box64-rk3588

FROM base-setup AS bin_rk3399
RUN apt-get install -y box64-rk3399 && cp /usr/local/bin/box64 /box64-rk3399

FROM base-setup AS bin_tegrax1
RUN apt-get install -y box64-tegrax1 && cp /usr/local/bin/box64 /box64-tegrax1

FROM base-setup AS bin_tegra_t194
RUN apt-get install -y box64-tegra-t194 && cp /usr/local/bin/box64 /box64-tegra-t194

FROM base-setup AS bin_android
RUN apt-get install -y box64-android && cp /usr/local/bin/box64 /box64-android

FROM base-setup AS bin_lx2160a
RUN apt-get install -y box64-lx2160a && cp /usr/local/bin/box64 /box64-lx2160a

FROM base-setup AS bin_sd888
RUN apt-get install -y box64-sd888 && cp /usr/local/bin/box64 /box64-sd888

FROM base-setup AS bin_sdoryon1
RUN apt-get install -y box64-sdoryon1 && cp /usr/local/bin/box64 /box64-sdoryon1

FROM base-setup AS bin_rpi4_legacy
RUN wget -q https://github.com/Pi-Apps-Coders/box64-debs/raw/064eb3cffe90fa40d5ab44325a90720c28aaae2b/debian/box64-rpi4arm64_0.2.7+20240521T063129.3882a98-1_arm64.deb -O legacy.deb \
    && dpkg-deb -x legacy.deb /tmp/legacy && cp /tmp/legacy/usr/local/bin/box64 /box64-rpi4-0_2_7

FROM arm64v8/debian:bookworm-slim AS bookworm_libs
RUN set -x \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libcurl4 libcurl4:i386

# --- Final Build Stage ---
FROM arm64v8/debian:trixie-slim AS build_stage

LABEL maintainer="github@snry.me"
ARG PUID=1000
ENV USER=steam \
    HOMEDIR="/home/steam" \
    STEAMCMDDIR="/home/steam/steamcmd" \
    DEBIAN_FRONTEND=noninteractive \
    DEBUGGER="/usr/local/bin/box86" \
    BOX86_BOX64="/usr/local/bin/box64" \
    LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/box64-x86_64-linux-gnu" \
    BOX86_LD_LIBRARY_PATH="/home/steam/steamcmd/linux32:/lib/i386-linux-gnu:/usr/lib/i386-linux-gnu" \
    LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy all specialized binaries
COPY --from=bin_m1 /box64-m1 /usr/local/bin/box64-m1
COPY --from=bin_rpi5 /box64-rpi5 /usr/local/bin/box64-rpi5
COPY --from=bin_rpi5_16k /box64-rpi5-16k /usr/local/bin/box64-rpi5-16k
COPY --from=bin_rpi4 /box64-rpi4 /usr/local/bin/box64-rpi4
COPY --from=bin_rpi4_legacy /box64-rpi4-0_2_7 /usr/local/bin/box64-rpi4-0_2_7
COPY --from=bin_rpi3 /box64-rpi3 /usr/local/bin/box64-rpi3
COPY --from=bin_rk3588 /box64-rk3588 /usr/local/bin/box64-rk3588
COPY --from=bin_rk3399 /box64-rk3399 /usr/local/bin/box64-rk3399
COPY --from=bin_tegrax1 /box64-tegrax1 /usr/local/bin/box64-tegrax1
COPY --from=bin_tegra_t194 /box64-tegra-t194 /usr/local/bin/box64-tegra-t194
COPY --from=bin_android /box64-android /usr/local/bin/box64-android
COPY --from=bin_lx2160a /box64-lx2160a /usr/local/bin/box64-lx2160a
COPY --from=bin_sd888 /box64-sd888 /usr/local/bin/box64-sd888
COPY --from=bin_sdoryon1 /box64-sdoryon1 /usr/local/bin/box64-sdoryon1

COPY --from=bookworm_libs /usr/lib/aarch64-linux-gnu/libcurl.so.* /usr/lib/aarch64-linux-gnu/
COPY --from=bookworm_libs /usr/lib/i386-linux-gnu/libcurl.so.* /usr/lib/i386-linux-gnu/

# System Setup
RUN set -x \
    && ldconfig \
    && dpkg --add-architecture armhf \
    && dpkg --add-architecture i386 \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        libc6:i386 libc6:armhf libstdc++6:armhf \
        libnuma1 libnuma1:i386 \
        libglib2.0-0 libglib2.0-0:i386 \
        openssl ca-certificates nano curl locales wget gnupg \
    && wget -qO- https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
    && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
    && wget -qO- https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list \
    && wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg \
    && apt-get update \
    && apt-get install -y --no-install-recommends box64 box86-generic-arm:armhf \
    && mv /usr/local/bin/box64 /usr/local/bin/box64-generic \
    && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen \
    && rm -rf /var/lib/apt/lists/*

COPY box64.sh /usr/local/bin/box64
RUN chmod +x /usr/local/bin/box64

# SteamCMD Setup
RUN useradd -l -u "${PUID}" -m "${USER}" \
    && su "${USER}" -c \
        "mkdir -p ${STEAMCMDDIR} && cd ${STEAMCMDDIR} \
        && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - \
        && ./steamcmd.sh +quit \
        && ln -s linux32/steamclient.so steamservice.so \
        && mkdir -p ${HOMEDIR}/.steam/sdk32 ${HOMEDIR}/.steam/sdk64 \
        && ln -s ${STEAMCMDDIR}/linux32/steamclient.so ${HOMEDIR}/.steam/sdk32/steamclient.so \
        && ln -s ${STEAMCMDDIR}/linux32/steamcmd ${STEAMCMDDIR}/linux32/steam \
        && ln -s ${STEAMCMDDIR}/linux64/steamclient.so ${HOMEDIR}/.steam/sdk64/steamclient.so \
        && ln -s ${STEAMCMDDIR}/linux64/steamcmd ${STEAMCMDDIR}/linux64/steam \
        && ln -s ${STEAMCMDDIR}/steamcmd.sh ${STEAMCMDDIR}/steam.sh" \
    && mkdir -p /usr/lib/x86_64-linux-gnu /usr/lib/i386-linux-gnu \
    && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
    && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
    && (for file in /usr/lib/box64-x86_64-linux-gnu/*; do [ -e "/usr/lib/x86_64-linux-gnu/$(basename "$file")" ] || ln -s "$file" /usr/lib/x86_64-linux-gnu/; done)

# --- Support original stage names ---
FROM build_stage AS trixie-root
WORKDIR ${STEAMCMDDIR}

FROM trixie-root AS trixie
USER ${USER}