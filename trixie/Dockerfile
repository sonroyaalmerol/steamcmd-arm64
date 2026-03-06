# syntax=docker/dockerfile:1
FROM arm64v8/debian:trixie-slim AS base-setup
ENV DEBIAN_FRONTEND=noninteractive
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Install common dependencies and setup Box64 repositories once
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates wget gnupg \
  && wget -qO- https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
  && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
  && apt-get update

# --- Binary Extraction Stages ---
FROM base-setup AS bin_m1
RUN apt-get install -y box64-m1 && cp /usr/local/bin/box64 /box64-m1; \
  cp /usr/local/bin/box64-bash /box64-bash-m1 || true

FROM base-setup AS bin_rpi5
RUN apt-get install -y box64-rpi5arm64 && cp /usr/local/bin/box64 /box64-rpi5; \
  cp /usr/local/bin/box64-bash /box64-bash-rpi5 || true

FROM base-setup AS bin_rpi5_16k
RUN apt-get install -y box64-rpi5arm64ps16k && cp /usr/local/bin/box64 /box64-rpi5-16k; \
  cp /usr/local/bin/box64-bash /box64-bash-rpi5-16k || true

FROM base-setup AS bin_rpi4
RUN apt-get install -y box64-rpi4arm64 && cp /usr/local/bin/box64 /box64-rpi4; \
  cp /usr/local/bin/box64-bash /box64-bash-rpi4 || true

FROM base-setup AS bin_rpi3
RUN apt-get install -y box64-rpi3arm64 && cp /usr/local/bin/box64 /box64-rpi3; \
  cp /usr/local/bin/box64-bash /box64-bash-rpi3 || true

FROM base-setup AS bin_rk3588
RUN apt-get install -y box64-rk3588 && cp /usr/local/bin/box64 /box64-rk3588; \
  cp /usr/local/bin/box64-bash /box64-bash-rk3588 || true

FROM base-setup AS bin_rk3399
RUN apt-get install -y box64-rk3399 && cp /usr/local/bin/box64 /box64-rk3399; \
  cp /usr/local/bin/box64-bash /box64-bash-rk3399 || true

FROM base-setup AS bin_tegrax1
RUN apt-get install -y box64-tegrax1 && cp /usr/local/bin/box64 /box64-tegrax1; \
  cp /usr/local/bin/box64-bash /box64-bash-tegrax1 || true

FROM base-setup AS bin_tegra_t194
RUN apt-get install -y box64-tegra-t194 && cp /usr/local/bin/box64 /box64-tegra-t194; \
  cp /usr/local/bin/box64-bash /box64-bash-tegra-t194 || true

FROM base-setup AS bin_android
RUN apt-get install -y box64-android && cp /usr/local/bin/box64 /box64-android; \
  cp /usr/local/bin/box64-bash /box64-bash-android || true

FROM base-setup AS bin_lx2160a
RUN apt-get install -y box64-lx2160a && cp /usr/local/bin/box64 /box64-lx2160a; \
  cp /usr/local/bin/box64-bash /box64-bash-lx2160a || true

FROM base-setup AS bin_sd888
RUN apt-get install -y box64-sd888 && cp /usr/local/bin/box64 /box64-sd888; \
  cp /usr/local/bin/box64-bash /box64-bash-sd888 || true

FROM base-setup AS bin_sdoryon1
RUN apt-get install -y box64-sdoryon1 && cp /usr/local/bin/box64 /box64-sdoryon1; \
  cp /usr/local/bin/box64-bash /box64-bash-sdoryon1 || true

# --- Final Build Stage ---
FROM arm64v8/debian:trixie-slim AS build_stage

LABEL maintainer="github@snry.me"
ARG PUID=1000
ENV USER=steam \
  HOMEDIR="/home/steam" \
  STEAMCMDDIR="/home/steam/steamcmd" \
  DEBIAN_FRONTEND=noninteractive \
  DEBUGGER="/usr/local/bin/box86" \
  LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/lib/box64-x86_64-linux-gnu:/usr/lib/box64-i386-linux-gnu" \
  LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 \
  BOX64_LD_LIBRARY_PATH="/usr/lib/box64-x86_64-linux-gnu:/usr/lib/box64-i386-linux-gnu" \
  BOX64_LD_PRELOAD=libpthread.so.0 \
  LD_PRELOAD=libpthread.so.0 \
  DBUS_FATAL_WARNINGS=0 \
  STEAM_RUNTIME=1 \
  STEAMOS=1 \
  BOX64_ENV1="DBUS_FATAL_WARNINGS=0" \
  BOX64_ENV2="STEAM_RUNTIME=1" \
  BOX64_ENV3="STEAMOS=1" \
  BOX64_ROLLING_LOG=1 \
  BOX64_LOG=1

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Copy all specialized binaries and their bash counterparts
COPY --from=bin_m1 /box64-m1 /box64-bash-m1* /usr/local/bin/
COPY --from=bin_rpi5 /box64-rpi5 /box64-bash-rpi5* /usr/local/bin/
COPY --from=bin_rpi5_16k /box64-rpi5-16k /box64-bash-rpi5-16k* /usr/local/bin/
COPY --from=bin_rpi4 /box64-rpi4 /box64-bash-rpi4* /usr/local/bin/
COPY --from=bin_rpi3 /box64-rpi3 /box64-bash-rpi3* /usr/local/bin/
COPY --from=bin_rk3588 /box64-rk3588 /box64-bash-rk3588* /usr/local/bin/
COPY --from=bin_rk3399 /box64-rk3399 /box64-bash-rk3399* /usr/local/bin/
COPY --from=bin_tegrax1 /box64-tegrax1 /box64-bash-tegrax1* /usr/local/bin/
COPY --from=bin_tegra_t194 /box64-tegra-t194 /box64-bash-tegra-t194* /usr/local/bin/
COPY --from=bin_android /box64-android /box64-bash-android* /usr/local/bin/
COPY --from=bin_lx2160a /box64-lx2160a /box64-bash-lx2160a* /usr/local/bin/
COPY --from=bin_sd888 /box64-sd888 /box64-bash-sd888* /usr/local/bin/
COPY --from=bin_sdoryon1 /box64-sdoryon1 /box64-bash-sdoryon1* /usr/local/bin/

# System Setup
RUN set -x \
  && dpkg --add-architecture armhf \
  && apt-get update \
  && apt-get install -y --no-install-recommends \
  libc6:arm64 libstdc++6:arm64 libcurl4:arm64 libnuma1:arm64 libglib2.0-0t64:arm64 \
  libc6:armhf libstdc++6:armhf libcurl4:armhf libnuma1:armhf libglib2.0-0t64:armhf \
  libncurses6:arm64 libncurses6:armhf \
  libbz2-1.0:arm64 libbz2-1.0:armhf \
  libcurl3t64-gnutls:arm64 libcurl3t64-gnutls:armhf \
  libssl3t64:arm64 libssl3t64:armhf \
  zlib1g:arm64 zlib1g:armhf \
  liblzma5:arm64 liblzma5:armhf \
  libsqlite3-0:arm64 libsqlite3-0:armhf \
  libgcc-s1:arm64 libgcc-s1:armhf \
  libudev1:arm64 libudev1:armhf \
  libdbus-1-3:arm64 libdbus-1-3:armhf \
  openssl ca-certificates nano curl locales wget gnupg tar \
  && wget -qO- https://ryanfortner.github.io -O /etc/apt/sources.list.d/box86.list \
  && wget -qO- https://ryanfortner.github.io | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg \
  && wget -qO- https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
  && wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg \
  && apt-get update \
  && apt-get install -y --no-install-recommends box64 box86-generic-arm \
  && mv /usr/local/bin/box64 /usr/local/bin/box64-generic \
  && mv /usr/local/bin/box64-bash /usr/local/bin/box64-bash-generic \
  && sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && locale-gen \
  && rm -rf /var/lib/apt/lists/*

COPY box64.sh /usr/local/bin/box64
RUN chmod +x /usr/local/bin/box64

# SteamCMD Setup
RUN useradd -l -u "${PUID}" -m "${USER}" && \
  mkdir -p "${STEAMCMDDIR}" "${HOMEDIR}/.steam/sdk32" "${HOMEDIR}/.steam/sdk64" && \
  chown -R "${USER}:${USER}" "${HOMEDIR}"

USER ${USER}
WORKDIR ${HOMEDIR}

RUN set -x \
  && cd "${STEAMCMDDIR}" \
  && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - \
  && ./steamcmd.sh +quit \
  && ln -s linux32/steamclient.so steamservice.so \
  && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "${HOMEDIR}/.steam/sdk32/steamclient.so" \
  && ln -s "${STEAMCMDDIR}/linux32/steamcmd" "${STEAMCMDDIR}/linux32/steam" \
  && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "${HOMEDIR}/.steam/sdk64/steamclient.so" \
  && ln -s "${STEAMCMDDIR}/linux64/steamcmd" "${STEAMCMDDIR}/linux64/steam" \
  && ln -s "${STEAMCMDDIR}/steamcmd.sh" "${STEAMCMDDIR}/steam.sh"

USER root
RUN mkdir -p /usr/lib/x86_64-linux-gnu /usr/lib/i386-linux-gnu \
  && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
  && ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/box64-x86_64-linux-gnu/steamclient.so" \
  && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
  && ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/box64-i386-linux-gnu/steamclient.so"

# --- Support original stage names ---
FROM build_stage AS trixie-root
WORKDIR ${STEAMCMDDIR}

FROM trixie-root AS trixie
USER ${USER}
