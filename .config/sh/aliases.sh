alias ls='ls --color=auto'
alias xclipboard="xclip -selection clipboard"
alias dotfiles="git --git-dir='$HOME/.dotfiles/' --work-tree='$HOME'"
alias tmux='tmux -2'
alias tree="$( ([ $(command -v exa) ] && echo "$(command -v exa)" --tree) || command -v tree )"
