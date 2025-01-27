#! /bin/sh

doas pacman -S --no-confirm \
    foot                    \
    mako                    \
    river                   \
    rofi-wayland            \
    waybar                  \
    wl-clipboard            \
    xdg-desktop-portal      \
    xdg-desktop-portal-wlr  \
;

paru -S                     \
    lswt                    \
    wideriver               \
;
