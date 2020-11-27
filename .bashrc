[[ $- != *i* ]] && return # return if not running bash interactive

PS1='[\u@\h \W]\$ ' # [user@host working_directory]$

[ -f ~/.fzf.bash ] && . ~/.fzf.bash

set -o vi # vi mode

export TERM=xterm # compatibility with ssh'd machines

# source anything that I may have wanted in only a local configuration.
for file in $HOME/.config/sh/{*,**/*}; do
    [ -f $file ] && . $file
done
