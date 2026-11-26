#!/usr/bin/env bash
set -Eeuo pipefail

# Kitty owns terminal selections, so ask it to copy through its native action.
# This avoids relying on a synthetic key event reaching the focused terminal.
if command -v hyprctl >/dev/null && command -v python3 >/dev/null && command -v kitty >/dev/null; then
  active_window="$(hyprctl activewindow -j 2>/dev/null || true)"
  read -r window_class window_pid < <(
    python3 -c 'import json,sys; w=json.loads(sys.stdin.read() or "{}"); print(w.get("class", ""), w.get("pid", ""))' <<<"$active_window" 2>/dev/null || true
  )

  if [[ "${window_class,,}" == "kitty" && "${window_pid:-}" =~ ^[0-9]+$ && -n "${XDG_RUNTIME_DIR:-}" ]]; then
    if kitty @ --to "unix:${XDG_RUNTIME_DIR}/kitty-${window_pid}" action copy_to_clipboard 2>/dev/null; then
      exit 0
    fi
  fi
fi

# Other apps use their normal Ctrl+C action. The global binding is Ctrl+Shift+C.
command -v wtype >/dev/null || { echo 'wtype is required' >&2; exit 127; }
exec wtype -M ctrl -k c -m ctrl
