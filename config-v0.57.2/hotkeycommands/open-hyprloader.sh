#!/usr/bin/env bash
set -Eeuo pipefail
if command -v hyprloader >/dev/null; then exec hyprloader; fi
if command -v hyprlauncher >/dev/null; then exec hyprlauncher; fi
echo 'Neither hyprloader nor hyprlauncher is installed' >&2
exit 127
