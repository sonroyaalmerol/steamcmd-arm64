FROM arm64v8/debian:bookworm-slim as qemu_build

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& apt-get update \
 	&& apt-get install -y --no-install-recommends --no-install-suggests \
		git \
		libglib2.0-dev \
		libfdt-dev \
		libpixman-1-dev \
		zlib1g-dev \
		ninja-build \
		build-essential \
		python3-venv \
		python3-tomli \
		flex \
		bison \
		libaio-dev \
        libattr1-dev \
        libbrlapi-dev \
        libcacard-dev \
        libcap-ng-dev \
        libgcrypt20-dev \
        libgnutls28-dev \
        libgtk-3-dev \
        libiscsi-dev \
        liblttng-ust-dev \
        libncurses5-dev \
        libnfs-dev \
        libpng-dev \
        librados-dev \
        libsdl2-dev \
        libseccomp-dev \
        liburcu-dev \
        libusb-1.0-0-dev \
        libvdeplug-dev \
        libvte-2.91-dev \
	&& rm -rf /var/lib/apt/lists/* \
	&& git clone https://gitlab.com/qemu-project/qemu.git \
	&& cd qemu \
	&& git checkout master -b stable-9.0 \ 
	&& git submodule update --init --recursive \
	&& ./configure \
		--prefix=/build/qemu-user-static \
		--static \
		--disable-system \
		--disable-bsd-user \
		--target-list=i386-linux-user \
	&& make -j$(nproc) \
	&& make install

############################################################

FROM arm64v8/python:slim-bookworm as box64_m1

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
        git=1:2.39.2-1.1 \
		ca-certificates=20230311 \
        build-essential=12.9 \
        cmake=3.25.1-1 \
		mold=1.10.1+dfsg-1 \
	&& git clone https://github.com/ptitSeb/box64.git \
    && mkdir /box64/build \
	&& cd /box64/build \
	&& cmake .. -D M1=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo -D WITH_MOLD=1 \
	&& mold -run make -j$(nproc) \
	&& make install DESTDIR=/tmp/install

############################################################

FROM arm64v8/python:slim-bookworm as box64_rpi5

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
        git=1:2.39.2-1.1 \
		ca-certificates=20230311 \
        build-essential=12.9 \
        cmake=3.25.1-1 \
		mold=1.10.1+dfsg-1 \
	&& git clone https://github.com/ptitSeb/box64.git \
    && mkdir /box64/build \
	&& cd /box64/build \
	&& cmake .. -D RPI5ARM64=1 -D CMAKE_BUILD_TYPE=RelWithDebInfo -D WITH_MOLD=1 \
	&& mold -run make -j$(nproc) \
	&& make install DESTDIR=/tmp/install

############################################################

FROM arm64v8/python:slim-bookworm as box64_adlink

ENV DEBIAN_FRONTEND noninteractive

# Set SHELL option explicitly
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -x \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		git=1:2.39.2-1.1 \
		ca-certificates=20230311 \
		build-essential=12.9 \
		cmake=3.25.1-1 \
		mold=1.10.1+dfsg-1 \
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

COPY --from=qemu_build /build/qemu-user-static/bin/qemu-i386 /usr/bin/qemu-i386-static
COPY --from=box64_m1 /tmp/install/usr/local/bin/box64 /usr/local/bin/box64-m1
COPY --from=box64_rpi5 /tmp/install/usr/local/bin/box64 /usr/local/bin/box64-rpi5
COPY --from=box64_adlink /tmp/install/usr/local/bin/box64 /usr/local/bin/box64-adlink

# hadolint ignore=DL3008
RUN set -x \
	# Install, update & upgrade packages
	&& dpkg --add-architecture armhf \
	&& dpkg --add-architecture i386 \
	&& apt-get update \
 	&& apt-get install -y --no-install-recommends --no-install-suggests \
		libc6:i386=2.36-9+deb12u7 \
		libstdc++6:i386=12.2.0-14 \
		libc6:armhf=2.36-9+deb12u7 \
		libstdc++6:armhf=12.2.0-14 \
		glibc=2.36-9+deb12u7 \
		ca-certificates=20230311 \
		nano=7.2-1+deb12u1 \
		curl=7.88.1-10+deb12u6 \
		locales=2.36-9+deb12u7 \
  		wget=1.21.3-1+b1 \
		gnupg=2.2.40-1.1 \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box64-debs/box64.list -O /etc/apt/sources.list.d/box64.list \
	&& (wget -qO- https://ryanfortner.github.io/box64-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box64-debs-archive-keyring.gpg) \
	&& wget --progress=dot:giga https://ryanfortner.github.io/box86-debs/box86.list -O /etc/apt/sources.list.d/box86.list \
	&& (wget -qO- https://ryanfortner.github.io/box86-debs/KEY.gpg | gpg --dearmor -o /etc/apt/trusted.gpg.d/box86-debs-archive-keyring.gpg) \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends --no-install-suggests \
		box64 \
		box86-generic-arm \
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
	&& rm -rf /var/lib/apt/lists/* \
	&& mv /usr/local/bin/box64 /usr/local/bin/box64-generic

COPY box64.sh /usr/local/bin/box64
RUN chmod +x /usr/local/bin/box64

FROM build_stage AS bookworm-root
WORKDIR ${STEAMCMDDIR}

FROM bookworm-root AS bookworm
# Switch to user
USER ${USER}