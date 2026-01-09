#!/bin/bash

if [[ -z "$ARM64_DEVICE" ]]; then
    echo "Notice: ARM64_DEVICE environment variable is not set. Defaulting to generic."
    ARM64_DEVICE="generic"
fi

export BOX64_ROLLING_LOG=1
export BOX64_LOG=1
export BOX64_NOSIGSEGV=1
export BOX64_CRASHHANDLER=1
export BOX64_NORCFILES=1
export BOX64_ENV="DBUS_FATAL_WARNINGS=0"

case "$ARM64_DEVICE" in
    rpi5)      BINARY_NAME="box64-rpi5" ;;
    rpi5_16k)  BINARY_NAME="box64-rpi5-16k" ;;
    rpi4)      BINARY_NAME="box64-rpi4" ;;
    rpi3)      BINARY_NAME="box64-rpi3" ;;
    rk3588)    BINARY_NAME="box64-rk3588" ;;
    rk3399)    BINARY_NAME="box64-rk3399" ;;
    m1|apple)  BINARY_NAME="box64-m1" ;;
    tegrax1)   BINARY_NAME="box64-tegrax1" ;;
    tegra_t194) BINARY_NAME="box64-tegra-t194" ;;
    android)   BINARY_NAME="box64-android" ;;
    lx2160a)   BINARY_NAME="box64-lx2160a" ;;
    sd888)     BINARY_NAME="box64-sd888" ;;
    sdoryon1)  BINARY_NAME="box64-sdoryon1" ;;
    *)         BINARY_NAME="box64-generic" ;;
esac

BINARY_PATH="/usr/local/bin/$BINARY_NAME"

if [[ ! -x "$BINARY_PATH" ]]; then
    if command -v box64 >/dev/null 2>&1; then
        echo "Warning: '$BINARY_PATH' not found. Falling back to system 'box64'."
        BINARY_PATH=$(command -v box64)
    else
        echo "Error: No Box64 binary found at '$BINARY_PATH' or in PATH."
        exit 1
    fi
fi

exec "$BINARY_PATH" "$@"