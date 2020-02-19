#  Dev
sudo pacman -S --noconfirm base base-devel nodejs node git python python-pip git-lfs
sudo pacman -S --noconfirm neovim ranger ripgrep
sudo pacman -S mpv weechat mpd ncmpcpp
sudo pacman -S neomutt libsasl cyrus-sasl
# Note: use %40 for @ if using gmail in muttrc, can also use aerc (aur).
# Otherwise follow arch wiki

sudo pacman -S docker
sudo systemctl enable --now docker
# Not using wayland for now
# wm/de
sudo pacman -S i3-wm xorg-xbaclight xorg-xrandr alsa-utils light xorg-xinput
sudo pacman -S x11-ssh-askpass
mkdir ~/bin
ln -sv /usr/lib/ssh/x11-ssh-askpass ~/bin/ssh-askpass
# Mouse accel
# xinput set-prop 'PS/2 Synaptics TouchPad'  'Device Accel Constant Deceleration' 1

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

# WINE
# LaTeX
