#!/usr/bin/env bash
set -Eeuo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd -P)"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_DIR=""
mapfile -t COMPONENTS < <(find "$SCRIPT_DIR" -mindepth 1 -maxdepth 1 -type d ! -name hotkeycommands -printf '%f\n' | sort)

if ! command -v Hyprland >/dev/null 2>&1; then
    printf 'Hyprland was not found in PATH; cannot install this config.\n' >&2
    exit 1
fi

if (( EUID == 0 )); then
    printf 'Run this installer as kuro without sudo; root would back up the wrong config directory.\n' >&2
    exit 1
fi

if [[ ! -f "$SCRIPT_DIR/hypr/hyprland.lua" ]]; then
    printf 'Could not find hyprland.lua next to this installer.\n' >&2
    exit 1
fi

mkdir -p -- "$CONFIG_HOME"
BACKUP_PARENT="/home/kuro/config-backups"
BACKUP_STAMP="$(date '+%Y-%m-%d_%H-%M-%S')"
BACKUP_ROOT="$BACKUP_PARENT/hypr"
BACKUP_DIR="$BACKUP_ROOT/$BACKUP_STAMP"
mkdir -p -- "$BACKUP_PARENT"
if [[ -e "$BACKUP_ROOT" && ! -w "$BACKUP_ROOT" ]]; then
    RECOVERY_DIR="$BACKUP_PARENT/hypr.previous-$BACKUP_STAMP"
    if ! mv -- "$BACKUP_ROOT" "$RECOVERY_DIR"; then
        printf 'Cannot write to %s or move it aside. Fix its ownership, then rerun as kuro.\n' "$BACKUP_ROOT" >&2
        exit 1
    fi
    printf 'Preserved the previous unwritable backup folder at: %s\n' "$RECOVERY_DIR"
fi
mkdir -p -- "$BACKUP_ROOT"
if [[ -e "$BACKUP_DIR" ]]; then
    BACKUP_DIR="$(mktemp -d "$BACKUP_ROOT/$BACKUP_STAMP.XXXXXXXX")"
else
    mkdir -- "$BACKUP_DIR"
fi

for component in "${COMPONENTS[@]}"; do
    source_path="$CONFIG_HOME/$component"
    if [[ -e "$source_path" || -L "$source_path" ]]; then
        # Dereference local config symlinks so the backup contains the files
        # the current setup actually reads, not just links to mutable targets.
        cp -aL -- "$source_path" "$BACKUP_DIR/"
    fi
done

# Back up the separately installed hotkey commands directory as part of the
# same timestamped import backup. It is not a top-level XDG config component.
HOTKEY_SOURCE="$CONFIG_HOME/kuro/hotkeycommands"
if [[ -e "$HOTKEY_SOURCE" || -L "$HOTKEY_SOURCE" ]]; then
    HOTKEY_BACKUP_ROOT="$HOME/kuro/config-backups/hyper-commands"
    mkdir -p -- "$HOTKEY_BACKUP_ROOT"
    HOTKEY_BACKUP="$HOTKEY_BACKUP_ROOT/$BACKUP_STAMP"
    if [[ -e "$HOTKEY_BACKUP" ]]; then
        HOTKEY_BACKUP="$(mktemp -d "$HOTKEY_BACKUP_ROOT/$BACKUP_STAMP.XXXXXXXX")"
    else
        mkdir -- "$HOTKEY_BACKUP"
    fi
    cp -aL -- "$HOTKEY_SOURCE" "$HOTKEY_BACKUP/hotkeycommands"
    printf 'Hotkey commands backup created at: %s\n' "$HOTKEY_BACKUP/hotkeycommands"
fi

BACKED_UP_FILES="$(find "$BACKUP_DIR" -type f -print | wc -l)"
if (( BACKED_UP_FILES == 0 )); then
    printf 'No local config files were found under %s; refusing to continue with an empty backup.\n' "$CONFIG_HOME" >&2
    printf 'Empty backup folder: %s\n' "$BACKUP_DIR" >&2
    exit 1
fi

printf 'Backup created at: %s\n' "$BACKUP_DIR"
printf 'Copied %s current local config files from: %s\n' "$BACKED_UP_FILES" "$CONFIG_HOME"
printf 'Symlinks were dereferenced so the backup contains file contents.\n'
printf 'Install the Hyprland 0.57.2 config into %s? [y/N] ' "$CONFIG_HOME"
if ! IFS= read -r answer </dev/tty; then
    answer=""
fi

case "$answer" in
    y|Y|yes|YES|Yes) ;;
    *)
        printf 'Install cancelled. Backup kept at: %s\n' "$BACKUP_DIR"
        exit 0
        ;;
esac

for component in "${COMPONENTS[@]}"; do
    cp -a -- "$SCRIPT_DIR/$component" "$CONFIG_HOME/"
done

if [[ -d "$SCRIPT_DIR/hotkeycommands" ]]; then
    mkdir -p -- "$CONFIG_HOME/kuro"
    rm -rf -- "$CONFIG_HOME/kuro/hotkeycommands"
    cp -a -- "$SCRIPT_DIR/hotkeycommands" "$CONFIG_HOME/kuro/"
fi

printf 'Checking the installed Hyprland config...\n'
if Hyprland --verify-config -c "$CONFIG_HOME/hypr/hyprland.lua"; then
    printf 'Install complete. Log out and back into Hyprland to use the new config.\n'
    printf 'Backup: %s\n' "$BACKUP_DIR"
else
    printf 'Config check failed. The backup is available at: %s\n' "$BACKUP_DIR" >&2
    exit 1
fi
