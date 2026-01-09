#!/bin/bash

if [[ -z "$ARM64_DEVICE" ]]; then
    echo "Notice: ARM64_DEVICE environment variable is not set. Defaulting to generic."
    ARM64_DEVICE="generic"
fi

# probably no-op but just in case
export STEAMOS=1
export STEAM_RUNTIME=1
export DBUS_FATAL_WARNINGS=0

# Determine architecture suffix
case "$ARM64_DEVICE" in
    rpi5)       SUFFIX="rpi5" ;;
    rpi5_16k)   SUFFIX="rpi5-16k" ;;
    rpi4)       SUFFIX="rpi4" ;;
    rpi3)       SUFFIX="rpi3" ;;
    rk3588)     SUFFIX="rk3588" ;;
    rk3399)     SUFFIX="rk3399" ;;
    m1|apple)   SUFFIX="m1" ;;
    tegrax1)    SUFFIX="tegrax1" ;;
    tegra_t194) SUFFIX="tegra-t194" ;;
    android)    SUFFIX="android" ;;
    lx2160a)    SUFFIX="lx2160a" ;;
    sd888)      SUFFIX="sd888" ;;
    sdoryon1)   SUFFIX="sdoryon1" ;;
    *)          SUFFIX="generic" ;;
esac

# Check if we should use the bash-specific wrapper
# Logic: If the first argument ends in .sh or is bash, use box64-bash
USE_BASH_WRAPPER=0
if [[ "$1" == *.sh ]] || [[ "$1" == "bash" ]] || [[ "$1" == "/bin/bash" ]]; then
    echo "Notice: Bash script detected. Using box64-bash."
    USE_BASH_WRAPPER=1
fi

if [ "$USE_BASH_WRAPPER" -eq 1 ]; then
    BINARY_NAME="box64-bash-$SUFFIX"
    # If the specialized bash binary doesn't exist, fall back to standard architecture binary
    if [[ ! -x "/usr/local/bin/$BINARY_NAME" ]]; then
        BINARY_NAME="box64-$SUFFIX"
    fi
else
    BINARY_NAME="box64-$SUFFIX"
fi

BINARY_PATH="/usr/local/bin/$BINARY_NAME"

# Fallback check
if [[ ! -x "$BINARY_PATH" ]]; then
    if [[ -x "/usr/local/bin/box64-generic" ]]; then
        BINARY_PATH="/usr/local/bin/box64-generic"
    else
        echo "Error: No Box64 binary found."
        exit 1
    fi
fi

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

    # 139 is SIGSEGV, 134 is SIGABRT
    if [ $STATUS -eq 139 ] || [ $STATUS -eq 134 ]; then
        echo "Notice: Caught steamcmd crash ($STATUS). Masking as Exit 0."
        exit 0
    else
        exit $STATUS
    fi
else
    exec "$BINARY_PATH" "$@"
fi