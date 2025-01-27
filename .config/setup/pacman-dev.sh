#! /bin/sh
pacman -S --noconfirm base nodejs npm git python \
    python-pip git-lfs neovim bash-completion docker
pip install wheel pynvim
systemctl enable --now docker
