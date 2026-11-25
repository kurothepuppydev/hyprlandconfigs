# Install KURO Desktop

This configuration uses Hyprland's Hyprlang format, validated with **Hyprland 0.53.3**. It uses built-in compositor features and needs no `hyprpm` plugins. On releases that use Lua, check whether the installed compositor still accepts Hyprlang before installing.

## Preview

Open `preview.html` from the repository in a browser, for example with `xdg-open ./preview.html`. Click the workspace numbers or toggle Gear wallpaper to compare the official texture with solid obsidian. The browser preview shows the palette and motion with sample terminal content. Use a Hyprland session to test the real panel, launcher and keybindings.

## Packages

| Package | Role |
| --- | --- |
| Hyprland | Required compositor |
| Waybar | Workspace indicators, clock, system status and session menu |
| Rofi with Wayland support | Application launcher and session menu |
| Kitty | Terminal bound to Super+Enter |
| Dunst | Notification daemon |
| Hyprlock | Session locking and the Waybar Lock action |
| JetBrains Mono and Inter | Desktop typography |
| PipeWire, PipeWire Pulse and WirePlumber | Audio server, Waybar volume and `wpctl` media keys |
| XDG Desktop Portal Hyprland and GTK backend | Screen sharing and file chooser portals |
| `xdg-utils` and a file manager | Open your home directory with Super+E |
| Hyprpaper | Optional static wallpaper add-on |
| Papirus | Optional application and launcher icon theme |

On Arch-based systems, install the available packages from your configured repositories. Check `Hyprland --version` after installation.

```sh
sudo pacman -S --needed hyprland waybar rofi kitty dunst hyprlock \
  ttf-jetbrains-mono inter-font pipewire pipewire-pulse wireplumber \
  xdg-desktop-portal-hyprland xdg-desktop-portal-gtk xdg-utils thunar
```

On other distributions use the equivalent packages. Use a Rofi build with native Wayland support. If you already run a notification daemon, comment out Dunst in `config/hypr/session.conf` before copying the files.

## Install the configuration

Run these commands from the repository root. The first block creates a private backup containing any configuration directories this installation may touch. If it fails, resolve the error before copying.

```sh
cfg=${XDG_CONFIG_HOME:-"$HOME/.config"}
mkdir -p "$cfg"
backup=$(mktemp -d "$HOME/kuro-config-backup.XXXXXXXX")
for component in hypr waybar rofi kitty dunst gtk-3.0 gtk-4.0 kuro; do
    if [ -e "$cfg/$component" ] || [ -L "$cfg/$component" ]; then
        cp -a -- "$cfg/$component" "$backup/" || break
    fi
done
printf 'Backup: %s\n' "$backup"
```

Review your existing configuration before accepting overwrite prompts. The files in `config/hypr/` work together. If you already have a compositor configuration, merge your input, monitor and binding settings into the corresponding KURO files or add overrides in `local.conf`. Resolve any destination symlinks before copying so you know where each file will land.

```sh
Hyprland --verify-config -c "$PWD/config/hypr/hyprland.conf"
cp -Ri -- config/. "$cfg/"
Hyprland --verify-config -c "$cfg/hypr/hyprland.conf"
```

The default monitor rule selects each output's preferred mode with automatic placement and scale. The default keyboard layout is US. For another layout, edit `input.conf` or add `input:kb_layout = de` (or your layout code) to `local.conf`.

Select Hyprland from your login manager, or run `start-hyprland` from a TTY. For changes in an existing session, run `hyprctl reload` and `hyprctl configerrors`. Log out and back in to run changed startup commands.

GTK has dark preferences installed with the configuration. For applications that use the desktop color preference, run `gsettings set org.gnome.desktop.interface color-scheme prefer-dark` if that schema is installed. Choose a dark theme in your Qt applications, browser and editor through their native settings.

## Keybindings

| Binding | Action |
| --- | --- |
| Super+Enter | Kitty with the window title kurothepuppy.dev |
| Super+Space | Rofi application launcher |
| Super+E | Home directory |
| Super+L | Lock with Hyprlock |
| Super+Q / Super+F | Close / fullscreen |
| Super+Shift+Space | Toggle floating |
| Super+Arrow / Super+Shift+Arrow | Focus / move window |
| Super+1–9 / Super+Shift+1–9 | Switch workspace / move window to workspace |
| Super+left / right mouse drag | Move / resize |
| Volume keys | Adjust or mute the default PipeWire output |

Workspace numbers are available for terminal, development, browser, communication, creative work, files, secondary work, testing and miscellaneous use, in that order.

Uncomment `animations:enabled = false` in `hypr/local.conf` and reload for reduced motion. For reduced motion in Waybar, start it with `waybar -s "${XDG_CONFIG_HOME:-$HOME/.config}/waybar/reduced-motion.css"` in place of the default startup command. Rofi uses static interaction states.

## Optional Hyprpaper wallpaper

The desktop and lock screen default to solid obsidian. The official kit includes `site-background-gothic-gears.png` for the developer wallpaper, transparent emblems under `icons/`, and `mainlogo.png` for startup branding. Preserve the originals and use `characterstylesheet.png` as a reference for any new Kuro artwork.

To use the supplied gear texture, install Hyprpaper (on Arch, `sudo pacman -S --needed hyprpaper`), then copy the original into your configuration directory.

```sh
mkdir -p "$cfg/kuro/wallpapers"
cp -i -- kurothepuppy_brand_kit/site-background-gothic-gears.png "$cfg/kuro/wallpapers/"
printf '%s\n' "$cfg/kuro/wallpapers/site-background-gothic-gears.png"
```

For Hyprpaper 0.8 or newer using the block-based format, create `hypr/hyprpaper.conf` under your config directory. Substitute the absolute path to your approved image.

```ini
wallpaper {
    monitor =
    path = /absolute/path/to/site-background-gothic-gears.png
    fit_mode = cover
}
```

Add `exec-once = command -v hyprpaper >/dev/null && hyprpaper` to `hypr/session.conf` and log in again. Use the solid fallback by removing that command. For an approved lock-screen image, add `path = /absolute/path/to/approved-lock-art.png` to the `background` block of `hyprlock.conf` and check that the clock and password prompt remain readable.

## Verify and restore

In a running session, switch workspaces, launch Kitty and use Rofi to open an application. Check Waybar's network and volume labels. If `notify-send` is installed, run `notify-send "KURO Desktop" "Notifications are working."` to check Dunst. Test Super+L while you have access to another TTY.

To restore, move the installed component directories out of the config directory and copy their backups back from the printed backup path. A component that had no backup was absent before installation.

To change shared colors, edit `config/kuro/palette.json` and run `python3 config/kuro/render-palette.py` from the repository root. Python is only needed for palette maintenance.

## App shortcuts

Hyprland leaves desktop icons to other applications. For quick access without another desktop process, add the supplied `"custom/launcher"` and `"custom/files"` modules before `"hyprland/workspaces"` in Waybar's `modules-left` array, then restart Waybar. Apps opens Rofi and Files opens your home directory. The browser preview includes sample shortcuts and content on all nine workspaces. In Hyprland, each workspace starts empty until you open or move a window there.

The browser preview rotates decorative cogs over the gear artwork. Pause cogs freezes the motion, and the preview follows your browser’s reduced-motion preference. Hyprpaper displays the original artwork as a static wallpaper. Hyprland animates window and workspace changes plus brief Wayland layer-surface entrances and exits. The latter applies to surfaces such as Rofi and Dunst when they run as native Wayland layers. Waybar uses its own short hover transitions. Use the reduced-motion overrides above to disable these effects.
