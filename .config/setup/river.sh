#! /bin/sh

doas pacman -S --no-confirm \
    foot                    \
    grim                    \
    mako                    \
    river                   \
    rofi-wayland            \
    slurp                   \
    swaylock                \
    waybar                  \
    wl-clipboard            \
    xdg-desktop-portal      \
    xdg-desktop-portal-wlr  \
;

paru -S                     \
    gromit-mpx              \
    lswt                    \
    wideriver               \
;
