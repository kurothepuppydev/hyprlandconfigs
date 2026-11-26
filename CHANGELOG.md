# Changelog

## 2026-11-26 — Hyprland 0.57.2 config

- Added the `config-v0.57.2/` desktop configuration for Hyprland's Lua config API, including the user's two-monitor layout, theme, Kitty, Dolphin, Hyprlauncher, Hyprlock, GTK, and Dunst settings.
- Added modular executable hotkey scripts for Kitty, Hyprlauncher, window closing/show-desktop behavior, clipboard copy/paste/history, and screenshot-to-clipboard. Preserved the requested keybinds and Kitty's terminal-safe Ctrl+C behavior.
- Added Waybar configs and styling for both monitors, including a NetBird indicator that reports connection state and toggles with `netbird up` / `netbird down`.
- Added per-monitor static and animated wallpapers, rotating cog overlays, source assets, and a script to rebuild the 3440x1440 and 1920x1080 videos.
- Added XWayland `force_zero_scaling` for sharper XWayland rendering on the scaled main display, and start the polkit GNOME authentication agent with Hyprland.
- Added an installer that backs up matching local config directories and the existing hotkey command directory before prompting to install. It does not install packages.
- Added `AI.md` to record the user's standing configuration, keybind, backup, and installation rules.
