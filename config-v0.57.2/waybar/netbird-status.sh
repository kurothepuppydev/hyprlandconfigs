#!/usr/bin/env bash
set -Eeuo pipefail

if ! command -v netbird >/dev/null 2>&1; then
  printf '{"text":"● NetBird","class":"unavailable","tooltip":"NetBird command not found"}\n'
  exit 0
fi

status="$(netbird status 2>&1 || true)"
if grep -Eiq '^Management:[[:space:]]*Connected([[:space:]]|$)' <<<"$status"; then
  printf '{"text":"● NetBird","class":"connected","tooltip":"NetBird connected — click to disconnect"}\n'
else
  printf '{"text":"● NetBird","class":"disconnected","tooltip":"NetBird disconnected — click to connect"}\n'
fi
