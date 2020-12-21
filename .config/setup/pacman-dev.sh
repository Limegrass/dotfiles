#! /bin/sh
pacman -S --noconfirm base base-devel sudo \
    nodejs npm git python python-pip git-lfs neovim
pacman -S --noconfirm docker
pip install wheel pynvim
systemctl enable --now docker
