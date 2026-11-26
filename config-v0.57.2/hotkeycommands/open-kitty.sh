#!/usr/bin/env bash
set -Eeuo pipefail
command -v kitty >/dev/null || { echo 'kitty is required' >&2; exit 127; }
exec kitty --title kurothepuppy.dev
