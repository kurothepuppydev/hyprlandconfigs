#!/usr/bin/env bash
set -Eeuo pipefail

notify() {
  if command -v notify-send >/dev/null 2>&1; then
    notify-send 'NetBird' "$1"
  else
    printf 'NetBird: %s\n' "$1" >&2
  fi
}

if ! command -v netbird >/dev/null 2>&1; then
  notify 'The netbird command was not found.'
  exit 127
fi

status="$(netbird status 2>&1 || true)"
if grep -Eiq '^Management:[[:space:]]*Connected([[:space:]]|$)' <<<"$status"; then
  if output="$(netbird down 2>&1)"; then
    notify 'Disconnected.'
  else
    notify "Could not disconnect: $output"
    exit 1
  fi
else
  if output="$(netbird up 2>&1)"; then
    notify 'Connecting.'
  else
    notify "Could not connect: $output"
    exit 1
  fi
fi
