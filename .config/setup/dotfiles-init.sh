#! /bin/bash
cd $HOME
DOTFILES_GIT_ROOT=$HOME/.dotfiles
git clone --bare https://github.com/limegrass/dotfiles.git $DOTFILES_GIT_ROOT
function dotfiles {
    git --git-dir=$DOTFILES_GIT_ROOT --work-tree=$HOME $@
}
dotfiles checkout
if [ $? != 0 ]; then
    BACKUP_ROOT=$DOTFILES_GIT_ROOT/backup-root
    mkdir -p $BACKUP_ROOT
    function reparenting_mv() {
        source=$1;
        target=$2;
        mkdir -p "$target"/"$(dirname $source)"
        mv "$source" "$target"/"$(dirname $source)"/
    }
    dotfiles checkout 2>&1 \
        | egrep "\s+\." \
        | awk {'print $1'} \
        | xargs -I{} reparenting_mv {} $BACKUP_ROOT/;
    echo "backed up to backup"
fi;

# TODO: Move files to a backup folder if conflicts exists.
dotfiles config status.showUntrackedFiles no
source $HOME/.bashrc
source $HOME/.bash_profile
