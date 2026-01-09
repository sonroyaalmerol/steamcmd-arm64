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

# Primary target: The architecture-specific bash wrapper
BINARY_PATH="/usr/local/bin/box64-bash-$SUFFIX"

# Fallback 1: Generic bash wrapper
if [[ ! -x "$BINARY_PATH" ]]; then
    BINARY_PATH="/usr/local/bin/box64-bash-generic"
fi

# Fallback 2: Standard architecture emulator (if no bash-wrapper exists at all)
if [[ ! -x "$BINARY_PATH" ]]; then
    BINARY_PATH="/usr/local/bin/box64-$SUFFIX"
fi

# Fallback 3: Standard generic emulator
if [[ ! -x "$BINARY_PATH" ]]; then
    BINARY_PATH="/usr/local/bin/box64-generic"
fi

exec "$BINARY_PATH" "$@"