#!/usr/bin/env bash
set -Eeuo pipefail
if command -v cliphist >/dev/null && command -v rofi >/dev/null; then
  cliphist list | rofi -dmenu -p Clipboard | cliphist decode | wl-copy
  exit
fi
echo 'Clipboard history interface requires cliphist and rofi' >&2
exit 127
