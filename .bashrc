[[ $- != *i* ]] && return # return if not running bash interactive

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ ' # [user@host working_directory]$

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

set -o vi # vi mode

[[ $DISPLAY != '' ]] \
    && alias "float_internal_keyboard=xinput float $(xinput | rg "AT Translated Set 2 keyboard" | rg -o "(id=)\d+" | rg -o "\d+")"
alias "config=$(which git) --git-dir='/$HOME/.dotfiles/' --work-tree='$HOME'"
