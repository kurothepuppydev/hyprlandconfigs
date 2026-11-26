#!/usr/bin/env bash
set -Eeuo pipefail
for tool in slurp grim wl-copy; do command -v "$tool" >/dev/null || { echo "$tool is required" >&2; exit 127; }; done
geometry=$(slurp) || exit 0
grim -g "$geometry" - | wl-copy --type image/png
