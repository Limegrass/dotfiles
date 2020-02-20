# TODO: Split into separate scripts/parameterize
#  Dev
sudo pacman -S --noconfirm base base-devel nodejs node \
    git python python-pip git-lfs
sudo pacman -S --noconfirm neovim ranger ripgrep
sudo pacman -S mpv weechat 
sudo pacman -S neomutt libsasl cyrus-sasl
# Note: use %40 for @ if using gmail in muttrc, alternative: aerc (aur).
# Otherwise follow arch wiki

sudo pacman -S docker sudo systemctl enable --now docker
# Not using wayland for now
# wm/de
sudo pacman -S i3-wm rofi xorg-xbaclight xorg-xrandr \
    alsa-utils light xorg-xinput x11-ssh-askpass
mkdir ~/bin
ln -sv /usr/lib/ssh/x11-ssh-askpass ~/bin/ssh-askpass

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
sudo pacman -S --noconfirm gnome-screenshot

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
