#!/bin/bash

ARM64_DEVICE="${ARM64_DEVICE:-generic}"

case "$ARM64_DEVICE" in
  rpi5) SUFFIX="rpi5" ;;
  rpi5_16k) SUFFIX="rpi5-16k" ;;
  rpi4) SUFFIX="rpi4" ;;
  rpi3) SUFFIX="rpi3" ;;
  rk3588) SUFFIX="rk3588" ;;
  rk3399) SUFFIX="rk3399" ;;
  m1 | apple) SUFFIX="m1" ;;
  tegrax1) SUFFIX="tegrax1" ;;
  tegra_t194) SUFFIX="tegra-t194" ;;
  android) SUFFIX="android" ;;
  lx2160a) SUFFIX="lx2160a" ;;
  sd888) SUFFIX="sd888" ;;
  sdoryon1) SUFFIX="sdoryon1" ;;
  *) SUFFIX="generic" ;;
esac

BINARY_PATH="/usr/local/bin/box64-$SUFFIX"
BASH_PATH="/usr/local/bin/box64-bash-$SUFFIX"

if [[ ! -x "$BINARY_PATH" ]]; then
  BINARY_PATH="/usr/local/bin/box64-generic"
  BASH_PATH="/usr/local/bin/box64-bash-generic"
fi

export BOX64_BASH="$BASH_PATH"

IS_STEAMCMD=0
for arg in "$@"; do
  if [[ "$arg" == *"steamcmd"* ]]; then
    IS_STEAMCMD=1
    break
  fi
done

if [[ "$IS_STEAMCMD" -eq 1 ]]; then
  export BOX64_SHOWSEGV=1
  export BOX64_DLSYM_ERROR=1
  "$BINARY_PATH" "$@"
  STATUS=$?
  if [[ $STATUS -eq 139 || $STATUS -eq 134 ]]; then
    exit 0
  fi
  exit "$STATUS"
else
  exec "$BINARY_PATH" "$@"
fi
