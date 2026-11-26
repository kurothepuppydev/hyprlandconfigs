# KURO config for Hyprland 0.57.2

This folder uses Hyprland's Lua config API. Hyprland 0.57 removed the legacy Hyprlang config loader, so the entry point is `hypr/hyprland.lua`. The existing `config/` folder remains available for older Hyprland releases.

The setup uses Kitty for Super+Q and Super+Enter, closes the focused window with Super+Shift+Q, and opens Dolphin with Super+E. Super+Space and Super+R open Hyprlauncher, with Rofi as a fallback. Super+Shift+S selects a screen area with `slurp`, captures it with `grim`, and copies it to the clipboard with `wl-copy`. Waybar includes the Apps and Files shortcuts. The Waybar and launcher colors follow the KURO palette. Waybar and Dunst start when available. Hyprlock remains configured through its own Hyprlang file.

Waybar remains the top bar. `kuro/start-wallpaper.sh` starts separate looping wallpapers through `mpvpaper`: 3440x1440 for DP-3 and 1920x1080 for HDMI-A-1. Both include visible rotating cogs, the gothic gear artwork, character, and logo card. Hyprpaper uses matching per-monitor static fallbacks. `kuro/build-wallpapers.sh` regenerates the videos from the included SVG and PNG assets. The importer does not install packages.

Run the installer from this folder as user `kuro`, without `sudo`. It finds the top-level folders in this config folder, backs up matching folders from `~/.config` (or `$XDG_CONFIG_HOME`) under `/home/kuro/config-backups/hypr/<timestamp>`, then asks before installing. It refuses to continue if the backup contains no files, copies the new config, and runs Hyprland's config check:

```sh
bash ./install.sh
```

Run it from inside `config-v0.57.2`, or call it by its path. Then log out and back into Hyprland; it loads `hyprland.lua` from `$XDG_CONFIG_HOME/hypr/` (usually `~/.config/hypr/`). For a manual check in a running session, use `hyprctl reload` and `hyprctl configerrors`.

This config expects the Hyprland 0.57 Lua API and does not request plugins or set build flags. It preserves the provided visual palette and user interface settings; the version ABI values are properties of the installed build and do not require config entries.
### NetBird in Waybar

Waybar shows a NetBird indicator on both monitors. It is colored when `netbird status` reports `Management: Connected`, and grey when disconnected or unavailable. Click it to run `netbird down` when connected or `netbird up` otherwise. The indicator refreshes every five seconds.
