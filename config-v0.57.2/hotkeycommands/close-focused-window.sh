#!/usr/bin/env bash
set -Eeuo pipefail
command -v hyprctl >/dev/null || { echo 'hyprctl is required' >&2; exit 127; }
# Hyprland 0.57 uses Lua dispatcher expressions through hyprctl.
hyprctl dispatch 'hl.dsp.window.close()'
