#! /bin/sh

. "$HOME/.config/river/scratch.sh"
. "$HOME/.config/river/mouse.sh"
. "$HOME/.config/river/bindkey.sh"
. "$HOME/.config/river/rules.sh"

riverctl rule-add ssd
riverctl background-color 0x002b36
riverctl border-width 2
riverctl border-color-focused 0x417563
riverctl border-color-unfocused 0x00000000

riverctl set-repeat 50 300

riverctl default-attach-mode bottom
