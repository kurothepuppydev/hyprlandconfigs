-- Hyprland v0.57.2 Lua configuration.
-- This is the entry point loaded by Hyprland; the legacy .conf loader was removed.

local terminal = "kitty"
local file_manager = "dolphin"

local colors = {
    obsidian = "0xff17151d",
    deep_violet = "0xff302a3b",
    surface = "0xff201d27",
    lavender = "rgba(9282ACff)",
    ivory = "rgba(F0EDF3ff)",
    ash = "rgba(C8C2D0ff)",
    error = "rgba(D9828Bff)",
    shadow = "rgba(0B0A0E80)",
}

hl.monitor({ output = "DP-3", mode = "3440x1440@59.97", position = "1920x0", scale = 1.25 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x180", scale = 1 })

hl.config({
    general = {
        layout = "dwindle",
        border_size = 2,
        gaps_in = 6,
        gaps_out = 12,
        col = {
            active_border = colors.lavender,
            inactive_border = colors.deep_violet,
        },
    },
    decoration = {
        rounding = 5,
        blur = { enabled = false },
        shadow = {
            enabled = true,
            range = 8,
            render_power = 2,
            color = colors.shadow,
        },
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        background_color = colors.obsidian,
    },
    input = {
        kb_layout = "us",
        follow_mouse = 0,
        touchpad = { natural_scroll = true },
    },
    xwayland = {
        force_zero_scaling = true,
    },
    animations = { enabled = true },
})

hl.curve("kuroEase", {
    type = "bezier",
    points = { { 0.22, 1 }, { 0.36, 1 } },
})
hl.animation({ leaf = "windowsIn", enabled = true, speed = 2, bezier = "kuroEase", style = "popin 96%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.6, bezier = "kuroEase", style = "popin 96%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 1.8, bezier = "kuroEase" })
hl.animation({ leaf = "fade", enabled = true, speed = 1.6, bezier = "kuroEase" })
hl.animation({ leaf = "border", enabled = true, speed = 1.4, bezier = "kuroEase" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 1.7, bezier = "kuroEase", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.6, bezier = "kuroEase", style = "fade" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 1.8, bezier = "kuroEase", style = "fade" })

local function command_if_available(command)
    return "sh -lc 'command -v " .. command .. " >/dev/null 2>&1 && exec " .. command .. "'"
end

hl.on("hyprland.start", function()
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("dunst")
    hl.exec_cmd(os.getenv("HOME") .. "/.config/kuro/start-wallpaper.sh")
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image/png --watch cliphist store")
    hl.exec_cmd("hyprlauncher -d")
end)

local mod = "SUPER"
local hotkey_script = os.getenv("HOME") .. "/.config/kuro/hotkeycommands/"
hl.bind(mod .. " + RETURN", hl.dsp.exec_cmd(command_if_available(terminal)))
hl.bind(mod .. " + Q", hl.dsp.exec_cmd(hotkey_script .. "open-kitty.sh"))
hl.bind(mod .. " + SPACE", hl.dsp.exec_cmd("sh -lc 'command -v hyprlauncher >/dev/null 2>&1 && exec hyprlauncher || (command -v rofi >/dev/null 2>&1 && exec rofi -show drun)'"))
hl.bind(mod .. " + R", hl.dsp.exec_cmd(hotkey_script .. "open-hyprloader.sh"))
hl.bind(mod .. " + E", hl.dsp.exec_cmd(command_if_available(file_manager)))
hl.bind(mod .. " + L", hl.dsp.exec_cmd("sh -lc 'command -v hyprlock >/dev/null 2>&1 && exec hyprlock'"))
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd(hotkey_script .. "close-focused-window.sh"))
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mod .. " + SHIFT + SPACE", hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod .. " + D", hl.dsp.exec_cmd(hotkey_script .. "toggle-hide-windows.sh"))

for key, direction in pairs({ LEFT = "left", RIGHT = "right", UP = "up", DOWN = "down" }) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ direction = direction }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ direction = direction }))
end

hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
hl.bind("ALT + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind(mod .. " + SHIFT + S", hl.dsp.exec_cmd(hotkey_script .. "screenshot-to-clipboard.sh"))
hl.bind("CTRL + SHIFT + C", hl.dsp.exec_cmd(hotkey_script .. "copy-selected-text.sh"))
hl.bind("CTRL + SHIFT + V", hl.dsp.exec_cmd(hotkey_script .. "paste-clipboard.sh"))
hl.bind(mod .. " + SHIFT + V", hl.dsp.exec_cmd(hotkey_script .. "open-clipboard-manager.sh"))

for workspace = 1, 9 do
    hl.bind(mod .. " + " .. workspace, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. workspace, hl.dsp.window.move({ workspace = workspace }))
end

hl.window_rule({
    name = "file-chooser",
    match = { class = "^(xdg-desktop-portal-gtk|xdg-desktop-portal-kde)$" },
    float = true,
    center = true,
})

-- Keep the preview terminal card as a regular floating window even when Kitty
-- restores a previous maximized/fullscreen state.
hl.window_rule({
    name = "kuro-terminal-card",
    match = { class = "^kitty$", title = "^kurothepuppy\\.dev$" },
    float = true,
    fullscreen = false,
    move = "0 44",
    size = "520 150",
    opacity = "0.90 override 0.90 override",
})
