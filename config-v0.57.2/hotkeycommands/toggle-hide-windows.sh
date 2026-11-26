#!/usr/bin/env bash
set -Eeuo pipefail
command -v hyprctl >/dev/null || { echo 'hyprctl is required' >&2; exit 127; }
# Hyprland 0.57 evaluates Lua dispatcher expressions instead of legacy string dispatchers.
hyprctl eval 'local focused = hl.get_active_monitor(); for _, monitor in ipairs(hl.get_monitors()) do hl.dispatch(hl.dsp.focus({ monitor = monitor })); hl.dispatch(hl.dsp.workspace.toggle_special("kuro-show-desktop")); end; if focused then hl.dispatch(hl.dsp.focus({ monitor = focused })); end'
