#! /bin/sh
cd $HOME
DOTFILES_GIT_ROOT=$HOME/.dotfiles
git clone --bare https://github.com/limegrass/dotfiles.git $DOTFILES_GIT_ROOT
dotfiles() {
    git --git-dir=$DOTFILES_GIT_ROOT --work-tree=$HOME $@
}
dotfiles checkout
if [ $? != 0 ]; then
    BACKUP_ROOT=$DOTFILES_GIT_ROOT/backup-root
    mkdir $BACKUP_ROOT
    echo "backing up to $BACKUP_ROOT then retrying"
    dotfiles checkout 2>&1 \
        | grep -E "\s+\." \
        | awk {'print $1'} \
        | xargs -I{} sh -c "
            dirname {} | xargs -I{-} mkdir -p $BACKUP_ROOT/{-};
            cp {} $BACKUP_ROOT/{};
            rm {};";
    dotfiles checkout
fi;

dotfiles config status.showUntrackedFiles no
dotfiles config user.name "James Ni"
dotfiles config user.email "james@niis.me"
dotfiles update-index --skip-worktree $HOME/.config/alacritty/alacritty.yml
. $HOME/.config/sh/aliases.sh
. $HOME/.config/sh/profile.sh
