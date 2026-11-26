#!/usr/bin/env bash
set -Eeuo pipefail

# Use Kitty's native clipboard paste action so pasted text follows Kitty's
# clipboard and bracketed-paste handling instead of synthesized keystrokes.
if command -v hyprctl >/dev/null && command -v python3 >/dev/null && command -v kitty >/dev/null; then
  active_window="$(hyprctl activewindow -j 2>/dev/null || true)"
  read -r window_class window_pid < <(
    python3 -c 'import json,sys; w=json.loads(sys.stdin.read() or "{}"); print(w.get("class", ""), w.get("pid", ""))' <<<"$active_window" 2>/dev/null || true
  )

  if [[ "${window_class,,}" == "kitty" && "${window_pid:-}" =~ ^[0-9]+$ && -n "${XDG_RUNTIME_DIR:-}" ]]; then
    if kitty @ --to "unix:${XDG_RUNTIME_DIR}/kitty-${window_pid}" action paste_from_clipboard 2>/dev/null; then
      exit 0
    fi
  fi
fi

# Other apps use their normal Ctrl+V action. The global binding is Ctrl+Shift+V.
command -v wtype >/dev/null || { echo 'wtype is required' >&2; exit 127; }
exec wtype -M ctrl -k v -m ctrl
