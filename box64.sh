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
    rpi4-pre3)
        BINARY_PATH="/usr/local/bin/box64-rpi4-0_2_7"
        ;;
    rpi3)
        BINARY_PATH="/usr/local/bin/box64-rpi3"
        ;;
    m1)
        BINARY_PATH="/usr/local/bin/box64-m1"
        ;;
    adlink)
        BINARY_PATH="/usr/local/bin/box64-adlink"
        ;;
    *)
        BINARY_PATH="/usr/local/bin/box64-generic"
        ;;
esac

# Check if the box64 exists
if [[ ! -f $BINARY_PATH ]]; then
    echo "Error: Box64 file '$BINARY_PATH' not found for architecture '$ARM64_DEVICE'."
    exit 1
fi

# Pass all arguments to box64
"$BINARY_PATH" "$@"