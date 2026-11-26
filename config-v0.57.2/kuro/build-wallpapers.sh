#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
WALLPAPER_DIR="$SCRIPT_DIR/wallpapers"
MAIN_STATIC="$WALLPAPER_DIR/kuro-desktop.png"
SECONDARY_STATIC="$WALLPAPER_DIR/kuro-desktop-secondary.png"
COG_SVG="$WALLPAPER_DIR/cog-overlay.svg"
MAIN_OUTPUT="$WALLPAPER_DIR/kuro-animated.mp4"
SECONDARY_OUTPUT="$WALLPAPER_DIR/kuro-animated-secondary.mp4"
MAIN_TMP="$MAIN_OUTPUT.tmp.mp4"
SECONDARY_TMP="$SECONDARY_OUTPUT.tmp.mp4"

if ! command -v ffmpeg >/dev/null 2>&1; then
  echo 'ffmpeg is required to build the animated wallpapers.' >&2
  exit 127
fi

for required in "$MAIN_STATIC" "$SECONDARY_STATIC" "$COG_SVG"; do
  if [[ ! -r "$required" ]]; then
    echo "Required wallpaper source is missing: $required" >&2
    exit 1
  fi
done

# Keep both transparent, rotating cogs behind the artwork. The large output is
# composed for DP-3 at 3440x1440.
ffmpeg -hide_banner -loglevel warning -y \
  -loop 1 -framerate 20 -i "$MAIN_STATIC" \
  -loop 1 -framerate 20 -i "$COG_SVG" \
  -loop 1 -framerate 20 -i "$COG_SVG" \
  -filter_complex '[1:v]rotate=2*PI*t/12:ow=iw:oh=ih:c=none[left_gear];[2:v]rotate=-2*PI*t/16:ow=iw:oh=ih:c=none[right_gear];[0:v][left_gear]overlay=x=-520:y=-500:format=auto[tmp];[tmp][right_gear]overlay=x=2770:y=780:format=auto,format=yuv420p[out]' \
  -t 6 -map '[out]' -an -c:v libx264 -preset slow -crf 13 -profile:v high \
  -movflags +faststart "$MAIN_TMP"

# The secondary output uses native 16:9 framing to avoid letterboxing on HDMI-A-1.
ffmpeg -hide_banner -loglevel warning -y \
  -loop 1 -framerate 20 -i "$SECONDARY_STATIC" \
  -loop 1 -framerate 20 -i "$COG_SVG" \
  -loop 1 -framerate 20 -i "$COG_SVG" \
  -filter_complex '[1:v]scale=700:700:flags=lanczos,rotate=2*PI*t/13:ow=iw:oh=ih:c=none[left_gear];[2:v]scale=740:740:flags=lanczos,rotate=-2*PI*t/17:ow=iw:oh=ih:c=none[right_gear];[0:v][left_gear]overlay=x=-320:y=-160:format=auto[tmp];[tmp][right_gear]overlay=x=1515:y=530:format=auto,format=yuv420p[out]' \
  -t 6 -map '[out]' -an -c:v libx264 -preset slow -crf 15 -profile:v high \
  -movflags +faststart "$SECONDARY_TMP"

mv -f -- "$MAIN_TMP" "$MAIN_OUTPUT"
mv -f -- "$SECONDARY_TMP" "$SECONDARY_OUTPUT"
printf 'Built %s and %s\n' "$MAIN_OUTPUT" "$SECONDARY_OUTPUT"
