# AI working notes for this repository

These are standing user decisions. Follow them in future changes unless the user explicitly changes them.

## Approval and installation

- Never run `install.sh` or otherwise install/sync this repository into the user's live `~/.config` automatically. The user must inspect the changes and backup, then run the installer themselves.
- Do not install packages unless the user explicitly asks. Check which dependencies are already installed first. If installation requires interactive `sudo`, give the user the command rather than asking them to share a password.
- Make and verify the requested repository changes before asking the user to take an external action. Do not modify files outside the repository without explicit authorization.

## Keybind preservation (critical)

- **Do not modify, rewrite, reorganize, remove, or rename any existing keybind unless the user explicitly instructs it.** This rule is stronger than any general cleanup or refactoring preference.
- Add only the exact keybinds the user requests. If a requested keybind conflicts with an existing one, overwrite that binding only when the user explicitly authorizes the conflict; otherwise ask first.
- New keybinds should call their own dedicated executable script under `config-v0.57.2/hotkeycommands/`. Keep command logic out of the Hyprland keybind definition.
- Bindings explicitly requested by the user (these may be changed only according to the conflict rule above):

  | Keybind | Action |
  | --- | --- |
  | Super+Shift+Q | Close focused window |
  | Super+Q | Open Kitty |
  | Super+R | Open Hyperloader (use the installed Hyprlauncher fallback where applicable) |
  | Super+D | Hide/minimize all windows and restore them with their original geometry |
  | Ctrl+Shift+C | Copy the selected/marked text |
  | Ctrl+Shift+V | Paste clipboard contents |
  | Super+Shift+V | Open clipboard history UI |
  | Super+Shift+S | Select a region, capture it, and copy the image to the clipboard |

- Existing bindings not listed above are protected. In particular, retain Super+Enter, Super+Space, Super+E, Super+L, Super+F, Super+Shift+Space, directional/workspace bindings, and media keys unless the user explicitly requests a change.

## Config and desktop decisions

- The current target is the `config-v0.57.2/` tree for Hyprland 0.57.2. Keep the older `config/` tree separate unless asked to migrate or synchronize it.
- The user uses Kitty as terminal, Dolphin as file manager, and Hyprlauncher as launcher/loader. Keep Waybar as the top bar; do not replace it with Quickshell.
- Keep the existing KURO palette and styling. The intended look is the browser preview: gothic gear background, character art, lavender accents, subtle borders/shadows, and a centered terminal card. Kitty should open as a normal-sized floating window, not fullscreen. General Hyprland window styling may apply the shared theme to other app windows without changing their keybinds or forcing every app to float.
- The animated wallpaper is a looping video started at Hyprland startup by `config-v0.57.2/kuro/start-wallpaper.sh` using mpvpaper, with Hyprpaper as fallback. Preserve Waybar. Do not add a second shell/bar unless the user asks.
- DP-3 is 3440x1440 and HDMI-A-1 is 1920x1080. Keep a correctly sized, separate wallpaper/video per output so the secondary display has no letterbox bars. Both should retain the gothic gear background, transparent character art, logo card, and visibly animated cogs.
- Existing wallpaper assets live under `config-v0.57.2/kuro/wallpapers/`. Keep paths relative to the installed `$XDG_CONFIG_HOME/kuro/` layout where scripts support it.
- The global Ctrl+Shift+C/V bindings must continue to call their scripts. When Kitty is focused, those scripts use Kitty's native copy/paste actions through its socket-only remote-control socket; other applications receive their normal Ctrl+C/V action through `wtype`.
- Kitty's `listen_on` socket is established when Kitty starts and is not changed by a config reload. Restart Kitty (or start a new session) after installing a change to that setting.
- Keep the preview's brand symbols and Kuro emblem visible in Waybar; ship any custom icon assets inside `config-v0.57.2/waybar/` so the installer copies them with the bar config.

## Import backups

- The user wants to review backups before installation. The installer must prompt before copying new configs, and the assistant must never answer that prompt or run the installer for them.
- Before importing/replacing `~/.config/kuro/hotkeycommands/`, back up its full contents (including nested structure and permissions where possible) under `~/kuro/config-backups/hyper-commands/<timestamp>/`.
- Use a filesystem-safe unique timestamp/directory; never overwrite or delete older backups. If the source hotkeycommands directory does not exist, skip this specific backup without failing.
- Existing config backups should contain the actual locally active config contents from matching directories under `~/.config`, not empty placeholders or repository source copies.

## Implementation and reporting

- Keep scripts modular, executable, and defensive about missing commands. Prefer tools already present; check before suggesting package installation.
- Do not change unrelated config, functionality, assets, or scripts as part of a focused request.
- When asked to verify, run appropriate static checks and clearly distinguish those from live-session testing. The current tool environment may not be able to connect to the user's Hyprland IPC socket.
- State what changed, what was verified, any missing dependency/runtime limitation, and explicitly confirm that the installer was not run.
