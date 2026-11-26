#!/usr/bin/env bash
set -Eeuo pipefail
WALLPAPER_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/kuro/wallpapers"
MAIN_WALLPAPER="$WALLPAPER_DIR/kuro-animated.mp4"
SECONDARY_WALLPAPER="$WALLPAPER_DIR/kuro-animated-secondary.mp4"

if [[ ! -r "$MAIN_WALLPAPER" ]]; then
  echo "Animated wallpaper not found: $MAIN_WALLPAPER" >&2
  exit 1
fi
if command -v mpvpaper >/dev/null 2>&1; then
  if [[ -r "$SECONDARY_WALLPAPER" ]]; then
    mpvpaper -o 'no-audio --loop-file=inf' DP-3 "$MAIN_WALLPAPER" &
    main_pid=$!
    mpvpaper -o 'no-audio --loop-file=inf' HDMI-A-1 "$SECONDARY_WALLPAPER" &
    secondary_pid=$!
    trap 'kill "$main_pid" "$secondary_pid" 2>/dev/null || true' EXIT INT TERM
    wait "$main_pid" "$secondary_pid" || true
    exit 0
  fi
  exec mpvpaper -o 'no-audio --loop-file=inf' DP-3 "$MAIN_WALLPAPER"
fi
if command -v hyprpaper >/dev/null 2>&1; then
  if command -v notify-send >/dev/null 2>&1; then
    notify-send -u normal 'KURO wallpaper' 'mpvpaper is missing; showing the static Hyprpaper background.'
  else
    printf '%s\n' 'mpvpaper is missing; showing the static Hyprpaper background.' >&2
  fi
  exec hyprpaper
fi
echo 'Install mpvpaper for animation or hyprpaper for the static fallback.' >&2
exit 127
