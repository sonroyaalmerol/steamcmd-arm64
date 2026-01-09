#!/bin/bash

if [[ -z "$ARM64_DEVICE" ]]; then
    echo "ARM64_DEVICE environment variable is not set, using generic Box64 build."
fi

export BOX64_ROLLING_LOG=1

# Define the path to binaries based on the ARM64_DEVICE environment variable
case $ARM64_DEVICE in
    rpi5)
        BINARY_PATH="/usr/local/bin/box64-rpi5"
        ;;
    rpi5_16k)
        BINARY_PATH="/usr/local/bin/box64-rpi5-16k"
        ;;
    rpi4)
        BINARY_PATH="/usr/local/bin/box64-rpi4"
        ;;
    rpi3)
        BINARY_PATH="/usr/local/bin/box64-rpi3"
        ;;
    rk3588)
        BINARY_PATH="/usr/local/bin/box64-rk3588"
        ;;
    rk3399)
        BINARY_PATH="/usr/local/bin/box64-rk3399"
        ;;
    m1)
        BINARY_PATH="/usr/local/bin/box64-m1"
        ;;
    tegrax1)
        BINARY_PATH="/usr/local/bin/box64-tegrax1"
        ;;
    tegra_t194)
        BINARY_PATH="/usr/local/bin/box64-tegra-t194"
        ;;
    android)
        BINARY_PATH="/usr/local/bin/box64-android"
        ;;
    lx2160a)
        BINARY_PATH="/usr/local/bin/box64-lx2160a"
        ;;
    sd888)
        BINARY_PATH="/usr/local/bin/box64-sd888"
        ;;
    sdoryon1)
        BINARY_PATH="/usr/local/bin/box64-sdoryon1"
        ;;
    *)
        BINARY_PATH="/usr/local/bin/box64-generic"
        ;;
esac

# Check if the box64 binary exists
if [[ ! -x $BINARY_PATH ]]; then
    echo "Error: Box64 binary '$BINARY_PATH' not found or not executable for architecture '$ARM64_DEVICE'."
    exit 1
fi

# Pass all arguments to the selected box64 binary
exec "$BINARY_PATH" "$@"