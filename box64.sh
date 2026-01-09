#!/bin/bash

if [[ -z "$ARM64_DEVICE" ]]; then
    ARM64_DEVICE="generic"
fi

case "$ARM64_DEVICE" in
    rpi5)      SUFFIX="rpi5" ;;
    rpi5_16k)  SUFFIX="rpi5-16k" ;;
    rpi4)      SUFFIX="rpi4" ;;
    rpi3)      SUFFIX="rpi3" ;;
    rk3588)    SUFFIX="rk3588" ;;
    rk3399)    SUFFIX="rk3399" ;;
    m1|apple)  SUFFIX="m1" ;;
    tegrax1)   SUFFIX="tegrax1" ;;
    tegra_t194) SUFFIX="tegra-t194" ;;
    android)   SUFFIX="android" ;;
    lx2160a)   SUFFIX="lx2160a" ;;
    sd888)     SUFFIX="sd888" ;;
    sdoryon1)  SUFFIX="sdoryon1" ;;
    *)         SUFFIX="generic" ;;
esac

export BOX64_BASH="/usr/local/bin/box64-bash-$SUFFIX"
BINARY_PATH="/usr/local/bin/box64-$SUFFIX"

# Fallback to generic if the specific one is missing
if [[ ! -x "$BINARY_PATH" ]]; then
    BINARY_PATH="/usr/local/bin/box64-generic"
fi

# SteamCMD crash masking logic
IS_STEAMCMD=0
for arg in "$@"; do
    if [[ "$arg" == *"steamcmd"* ]]; then
        IS_STEAMCMD=1
        break
    fi
done

if [ "$IS_STEAMCMD" -eq 1 ]; then
    "$BINARY_PATH" "$@"
    STATUS=$?
    [[ $STATUS -eq 139 || $STATUS -eq 134 ]] && exit 0
    exit $STATUS
else
    exec "$BINARY_PATH" "$@"
fi