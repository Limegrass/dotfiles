[[ $- != *i* ]] && return # return if not running bash interactive

PS1='[\u@\h \W]\$ ' # [user@host working_directory]$

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

set -o vi # vi mode

export TERM=xterm # compatibility with ssh'd machines

source $HOME/.config/sh/aliases.sh

# source anything that I may have wanted in only a local configuration.
shopt -s nullglob # prevents errors from no files.
for file in $HOME/.config/bash/*; do
    source $file
done
shopt -u nullglob
