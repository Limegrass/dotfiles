#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
export EDITOR=$(which nvim)
export VISUAL=$EDITOR
export VIMINIT="source $HOME/.vimrc" # Cross platform and nvim/vim agnostic
export GVIMINIT="source $HOME/.gvimrc"
export SSH_ASKPASS=ssh-askpass

[[ $(lsmod | rg pcspkr) ]] && sudo rmmod pcspkr

startx
