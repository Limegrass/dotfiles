# TODO: Split into separate scripts/parameterize
# For beeps, sudo echo "blacklist pcspkr" >> /etc/modprobe.d/blacklist.conf
# For backlight without sudo, change KERNEL to whatever is at {} in  /sys/class/backlight/{}
# and add to /etc/udev/rules.d/backlight.rules
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/bin/chgrp video /sys/class/backlight/%k/brightness"
# ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="acpi_video0", RUN+="/bin/chmod g+w /sys/class/backlight/%k/brightness"

# also probably need iwd or NetworkManager.
# sudo pacman -S --noconfirm networkmanager network-manager-applet
# Make sure to turn off WiFi power saving.
sudo pacman -S --noconfirm neovim ranger w3m zathura zathura-pdf-poppler
sudo pip install neovim-remote
sudo pacman -S mpv weechat
sudo pacman -S neomutt libsasl cyrus-sasl
# Note: use %40 for @ if using gmail in muttrc, alternative: aerc (aur).
# Otherwise follow arch wiki

# Not using wayland for now
sudo pacman -S i3-wm picom rofi xorg-xbaclight xorg-xrandr \
    alsa-utils light xorg-xinput x11-ssh-askpass
mkdir ~/bin
ln -sv /usr/lib/ssh/x11-ssh-askpass ~/bin/ssh-askpass

# fonts
pacman -S adobe-source-code-pro-fonts ttf-font-awesome

# dynamic workspace names
sudo pip3 install i3-workspace-names-daemon

# Mouse accel
# xinput set-prop 'PS/2 Synaptics TouchPad'  \
#     'Device Accel Constant Deceleration' 1

docker image pull ezkrg/bitlbee-libpurple
docker run -p 6667:6667 \
    --name bitlbee \
    -v /local/path/to/configurations:/var/lib/bitlbee \
    --restart=always \
    --detach ezkrg/bitlbee-libpurple:latest

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Share(ni)X
mkdir -p $HOME/git/aur
cd $HOME/git/aur
git clone https://aur.archlinux.org/sharenix-git.git
cd sharenix-git
makepkg -si --noconfirm

# Music player daemon + client + audio scrobbler
sudo pacman -S --noconfirm mpd ncmpcpp
cd $HOME/git/aur
git clone https://aur.archlinux.org/mpdas
cd mpdas
makepkg -si
systemctl enable --now --user mpd
systemctl enable --now --user mpdas

# massive TeX dump because I'm lazy
sudo pacman -S --noconfirm texlive-most texlive-lang

# WINE - Must uncomment multilib in /etc/pacman.conf
# sudo pacman -S wine wine-gecko wine-mono

sudo pacman -S ccls

cd $HOME/git/aur
git clone https://aur.archlinux.org/auracle-git
cd auracle-git
makepkg -si
sudo pacman -S --noconfirm expac

cd $HOME/git/aur
git clone https://aur.archlinux.org/pacaur
cd pacaur
makepkg -si

pacaur -S ksnip

# gpg key of Thomas Dickey <https://invisible-island.net/>
# for ncurses dependency on android-emulator
gpg --recv-keys 702353E0F7E48ED8
pacaur -S android-studio android-sdk android-sdk-build-tools \
    android-sdk-platform-tools android-platform android-emulator

sudo pacman -S uim

# alias to corresponding commands as desired.
cargo install runiq du-dust
sudo pacman -S --noconfirm ripgrep fd bat exa jq watchexec

# For SSDs
# sudo systemctl enable --now fstrim.timer
