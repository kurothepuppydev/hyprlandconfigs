#!/bin/sh
command -v rofi >/dev/null || exit 0

actions='Log out'
if command -v hyprlock >/dev/null; then
    actions="Lock
$actions"
fi
if command -v systemctl >/dev/null; then
    actions="$actions
Restart
Power off"
fi

choice=$(printf '%s\n' "$actions" | rofi -dmenu -no-custom -p Session) || exit 0
if [ "$choice" = Lock ]; then
    exec hyprlock
fi

confirm=$(printf '%s\n' Cancel "$choice" | rofi -dmenu -no-custom -p Confirm) || exit 0
[ "$confirm" = "$choice" ] || exit 0
case "$choice" in
    'Log out') exec hyprctl dispatch exit ;;
    Restart) exec systemctl reboot ;;
    'Power off') exec systemctl poweroff ;;
esac
