#! /bin/sh
cd $HOME
DOTFILES_GIT_ROOT=$HOME/.dotfiles
git clone --bare https://github.com/limegrass/dotfiles.git $DOTFILES_GIT_ROOT
function dotfiles() {
    git --git-dir=$DOTFILES_GIT_ROOT --work-tree=$HOME $@
}
dotfiles checkout
if [ $? != 0 ]; then
    BACKUP_ROOT=$DOTFILES_GIT_ROOT/backup-root
    echo "backing up to $BACKUP_ROOT then retrying"
    dotfiles checkout 2>&1 \
        | egrep "\s+\." \
        | awk {'print $1'} \
        | xargs -I{} sh -c "echo {}; cp -r {} $BACKUP_ROOT/{}; rm {};";
    dotfiles checkout
fi;

dotfiles config status.showUntrackedFiles no
source $HOME/.bashrc
source $HOME/.bash_profile
