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
[ -f /usr/share/bash-completion/completions/git ] \
    && . /usr/share/bash-completion/completions/git \
    && ___git_complete g __git_main \
    && ___git_complete dotfiles __git_main
alias cdgroot='cd $(git rev-parse --show-toplevel)'
