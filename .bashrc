[[ $- != *i* ]] && return # return if not running bash interactive

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ ' # [user@host working_directory]$

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

set -o vi # vi mode

alias xclipboard="xclip -selection clipboard"
alias dotfiles="git --git-dir='$HOME/.dotfiles/' --work-tree='$HOME'"

export TERM=xterm # compatibility with ssh'd machines

# source anything that I may have wanted in only a local configuration.
shopt -s nullglob # prevents errors from no files.
for file in $XDG_CONFIG_HOME/bash/*; do
    source $file
done
shopt -u nullglob
