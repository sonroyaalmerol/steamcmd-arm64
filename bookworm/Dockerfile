FROM arm64v8/debian:bookworm-slim as box64_m1

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
 	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
  		wget \
		gnupg \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64-m1

############################################################

FROM arm64v8/debian:bookworm-slim as box64_rpi5_4k

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
 	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
  		wget \
		gnupg \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64-rpi5arm64

############################################################

FROM arm64v8/debian:bookworm-slim as box64_rpi5_16k

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		wget \
		gnupg \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64-rpi5arm64ps16k

############################################################

FROM arm64v8/debian:bookworm-slim as box64_rpi4

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		wget \
		gnupg \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64-rpi4arm64

############################################################

FROM arm64v8/debian:bookworm-slim as box64_rpi3

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		ca-certificates \
		wget \
		gnupg \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64-rpi3arm64

############################################################

FROM arm64v8/python:slim-bookworm as box64_adlink

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		git \
		ca-certificates \
		build-essential \
		cmake \
		mold \
	&& git clone https://github.com/ptitSeb/box64.git \
	&& mkdir /box64/build \
	&& cd /box64/build \
	&& cmake .. -D ADLINK=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo -D WITH_MOLD=1 \
	&& mold -run make -j$(nproc) \
	&& make install DESTDIR=/tmp/install

############################################################
# Dockerfile that contains SteamCMD and Box86/64
############################################################

FROM arm64v8/debian:bookworm-slim as build_stage

LABEL maintainer="github@snry.me"
ARG PUID=1000

ENV USER steam
ENV HOMEDIR "/home/${USER}"
ENV STEAMCMDDIR "${HOMEDIR}/steamcmd"

ENV DEBIAN_FRONTEND noninteractive

ENV DEBUGGER "/usr/local/bin/box86"

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

COPY --from=box64_m1 /usr/local/bin/box64 /usr/local/bin/box64-m1
COPY --from=box64_rpi5_4k /usr/local/bin/box64 /usr/local/bin/box64-rpi5
COPY --from=box64_rpi5_16k /usr/local/bin/box64 /usr/local/bin/box64-rpi5-16k
COPY --from=box64_rpi4 /usr/local/bin/box64 /usr/local/bin/box64-rpi4
COPY --from=box64_rpi3 /usr/local/bin/box64 /usr/local/bin/box64-rpi3
COPY --from=box64_adlink /tmp/install/usr/local/bin/box64 /usr/local/bin/box64-adlink

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& dpkg --add-architecture armhf \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
 	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libc6:i386 \
		libc6:armhf \
		libstdc++6:i386 \
		libstdc++6:armhf \
		libcurl4 \
		libcurl4:i386 \
		libnuma1 \
		libnuma1:i386 \
		libglib2.0-0 \
		libglib2.0-0:i386 \
		openssl \
		ca-certificates \
		nano \
		curl \
		locales \
  		wget \
		gnupg \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list \
	&& (wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64 \
	&& apt-get download -y \
		box86-generic-arm \
	&& dpkg-deb -R *.deb box86_tmp \
	&& ls -al box86_tmp \
	&& rm box86_tmp/usr/lib/i386-linux-gnu/libstdc++.so* \
	&& dpkg-deb -b box86_tmp new_box86.deb \
	&& dpkg -i new_box86.deb \
	&& rm -rf *.deb \
	&& rm -rf box86_tmp \
	&& sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen \
	&& dpkg-reconfigure --frontend=noninteractive locales \
	# Create unprivileged user
	&& useradd -l -u "${PUID}" -m "${USER}" \
        # Download SteamCMD, execute as user
        && su "${USER}" -c \
		"mkdir -p \"${STEAMCMDDIR}\" \
                && curl -fsSL 'https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz' | tar xvzf - -C \"${STEAMCMDDIR}\" \
                && ${STEAMCMDDIR}/steamcmd.sh +quit \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${STEAMCMDDIR}/steamservice.so\" \
                && mkdir -p \"${HOMEDIR}/.steam/sdk32\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamclient.so\" \"${HOMEDIR}/.steam/sdk32/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux32/steamcmd\" \"${STEAMCMDDIR}/linux32/steam\" \
                && mkdir -p \"${HOMEDIR}/.steam/sdk64\" \
                && ln -s \"${STEAMCMDDIR}/linux64/steamclient.so\" \"${HOMEDIR}/.steam/sdk64/steamclient.so\" \
                && ln -s \"${STEAMCMDDIR}/linux64/steamcmd\" \"${STEAMCMDDIR}/linux64/steam\" \
                && ln -s \"${STEAMCMDDIR}/steamcmd.sh\" \"${STEAMCMDDIR}/steam.sh\"" \
	# Symlink steamclient.so; So misconfigured dedicated servers can find it
	&& mkdir -p /usr/lib/x86_64-linux-gnu \
 	&& ln -s "${STEAMCMDDIR}/linux64/steamclient.so" "/usr/lib/x86_64-linux-gnu/steamclient.so" \
 	&& ln -s "${STEAMCMDDIR}/linux32/steamclient.so" "/usr/lib/i386-linux-gnu/steamclient.so" \
	&& rm -rf /var/lib/apt/lists/* \
	&& mv /usr/local/bin/box64 /usr/local/bin/box64-generic

COPY box64.sh /usr/local/bin/box64
RUN chmod +x /usr/local/bin/box64

FROM build_stage AS bookworm-root
WORKDIR ${STEAMCMDDIR}

FROM bookworm-root AS bookworm
# Switch to user
USER ${USER}