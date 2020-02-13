[[ $- != *i* ]] && return # return if not running bash interactive

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ ' # [user@host working_directory]$

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

set -o vi # vi mode

export VIMINIT="source $HOME/.vimrc" # Cross platform and nvim/vim agnostic
export GVIMINIT="source $HOME/.gvimrc"

alias "config=$(which git) --git-dir='/$HOME/.dotfiles/' --work-tree='$HOME'"
