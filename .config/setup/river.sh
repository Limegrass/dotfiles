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
    qt6-wayland             \
;

paru -S                     \
    gromit-mpx              \
    lswt                    \
    wideriver               \
;
