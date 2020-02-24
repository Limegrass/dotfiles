#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

export XDG_CONFIG_HOME=$HOME/.config # default
export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc" # Cross platform and nvim/vim agnostic
export GVIMINIT="source $XDG_CONFIG_HOME"/vim/gvimrc
export SSH_ASKPASS="ssh-askpass"
export TERMINAL="alacritty"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

startx
