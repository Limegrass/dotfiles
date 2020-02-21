#! /bin/bash
cd $HOME/bin
wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks
chmod +x winetricks
wget  https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks.bash-completion
sudo mv winetricks.bash-completion /usr/share/bash-completion/completions/winetricks
winetricks -q atmlib gdiplus msxml3 msxml6 vcrun2005 vcrun2005sp1 vcrun2008 ie6 fontsmooth-rgb gecko
# run winecfg and set virtual desktop on.
# Also setup nvidia drivers, PRIME, and prime-run

# Uncheck Use Graphics Processor in Preferences > Performance if editing shows nothing.
