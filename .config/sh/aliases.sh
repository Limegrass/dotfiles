#! /bin/sh

# shellcheck disable=2139
alias ls="$( ([ "$(command -v exa)" ] && echo "$(command -v exa)" -al) || echo ls -al --color=auto )"
alias xclipboard="xclip -selection clipboard"
# shellcheck disable=2139
alias dotfiles="git --git-dir='$HOME/.dotfiles/' --work-tree='$HOME'"
alias tmux='tmux -2'
# shellcheck disable=2139
alias tree="$( ([ "$(command -v exa)" ] && echo "$(command -v exa)" --tree) || command -v tree )"
alias g="git"
