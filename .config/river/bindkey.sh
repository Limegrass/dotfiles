#! /bin/sh

# See the river(1), riverctl(1), and rivertile(1) man pages for complete documentation.

riverctl map normal Super+Shift Return spawn foot
riverctl map normal Super Space spawn "rofi -show-icons -combi-modi window,drun,ssh,run -modi combi -show combi"
riverctl map normal Super Tab spawn "rofi -show-icons -modi window -show window"
riverctl map normal Super+Shift Q close  m

riverctl map normal Super+Shift Escape exit # exits river
riverctl map normal Super+Shift R spawn ". ~/.config/river/config.sh"

riverctl map normal Super A spawn "killall waybar || waybar -c ~/.config/waybar/river/config.json -s ~/.config/waybar/river/river_style.css"

riverctl map normal Super H focus-view left
riverctl map normal Super J focus-view down
riverctl map normal Super K focus-view up
riverctl map normal Super L focus-view right

# Super+Shift+J and Super+Shift+K to swap the focused view with the next/previous view in the layout stack
riverctl map normal Super+Shift J swap next
riverctl map normal Super+Shift K swap previous

# Super+Period and Super+Comma to focus the next/previous output
riverctl map normal Super Period focus-output next
riverctl map normal Super Comma focus-output previous

# Super+Shift+{Period,Comma} to send the focused view to the next/previous output
riverctl map normal Super+Shift Period send-to-output next
riverctl map normal Super+Shift Comma send-to-output previous

# Super+Return to bump the focused view to the top of the layout stack
riverctl map normal Super Return zoom

# Super+Shift+H and Super+Shift+L to increment/decrement the main count of rivertile(1)
riverctl map normal Super+Shift H send-layout-cmd rivertile "main-count +1"
riverctl map normal Super+Shift L send-layout-cmd rivertile "main-count -1"

# Super+Alt+{H,J,K,L} to move views
riverctl map normal Super+Alt H move left 100
riverctl map normal Super+Alt J move down 100
riverctl map normal Super+Alt K move up 100
riverctl map normal Super+Alt L move right 100

# Super+Alt+Control+{H,J,K,L} to snap views to screen edges
riverctl map normal Super+Alt+Control H snap left
riverctl map normal Super+Alt+Control J snap down
riverctl map normal Super+Alt+Control K snap up
riverctl map normal Super+Alt+Control L snap right

# Super+Alt+Shift+{H,J,K,L} to resize views
riverctl map normal Super+Alt+Shift H resize horizontal -100
riverctl map normal Super+Alt+Shift J resize vertical 100
riverctl map normal Super+Alt+Shift K resize vertical -100
riverctl map normal Super+Alt+Shift L resize horizontal 100

riverctl map-pointer normal Super BTN_LEFT move-view
riverctl map-pointer normal Super BTN_RIGHT resize-view
riverctl map-pointer normal Super BTN_MIDDLE toggle-float

for i in $(seq 1 9)
do
    tags=$((1 << i - 1))

    # Super+[1-9] to focus tag [0-8]
    riverctl map normal Super "$i" set-focused-tags $tags

    # Super+Shift+[1-9] to tag focused view with tag [0-8]
    riverctl map normal Super+Shift "$i" set-view-tags $tags

    # Super+Control+[1-9] to toggle focus of tag [0-8]
    riverctl map normal Super+Control "$i" toggle-focused-tags $tags

    # Super+Shift+Control+[1-9] to toggle tag [0-8] of focused view
    riverctl map normal Super+Shift+Control "$i" toggle-view-tags $tags
done

all_tags=$(((1 << 32) - 1))
riverctl map normal Super p set-focused-tags $all_tags # focus all tags
riverctl map normal Super+Control+Shift p set-view-tags $all_tags # pin view to all tags

riverctl map normal Super+Shift Space toggle-float

# Super+F to toggle fullscreen
riverctl map normal Super F toggle-fullscreen

# Declare a passthrough mode. This mode has only a single mapping to return to
# normal mode. This makes it useful for testing a nested wayland compositor
riverctl declare-mode passthrough
riverctl map normal Super F11 enter-mode passthrough
riverctl map passthrough Super F11 enter-mode normal

# Various media key mapping examples for both normal and locked mode which do
# not have a modifier
for mode in normal locked
do
    # Eject the optical drive (well if you still have one that is)
    riverctl map $mode None XF86Eject spawn 'eject -T'

    # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
    riverctl map $mode None XF86AudioRaiseVolume  spawn 'pamixer -i 5'
    riverctl map $mode None XF86AudioLowerVolume  spawn 'pamixer -d 5'
    riverctl map $mode None XF86AudioMute         spawn 'pamixer --toggle-mute'

    # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
    riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPlay  spawn 'playerctl play-pause'
    riverctl map $mode None XF86AudioPrev  spawn 'playerctl previous'
    riverctl map $mode None XF86AudioNext  spawn 'playerctl next'

    # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
    riverctl map $mode None XF86MonBrightnessUp   spawn 'brightnessctl set +5%'
    riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
done
