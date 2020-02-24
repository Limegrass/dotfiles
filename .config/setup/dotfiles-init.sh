#! /bin/bash
cd $HOME
git clone --bare https://github.com/limegrass/dotfiles.git $HOME/.dotfiles
function dotfiles {
    git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
dotfiles checkout
# TODO: Move files to a backup folder if conflicts exists.
dotfiles config status.showUntrackedFiles no
source $HOME/.bashrc
source $HOME/.bash_profile

