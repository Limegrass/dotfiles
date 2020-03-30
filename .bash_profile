[[ -f ~/.bashrc ]] && . ~/.bashrc

export XDG_CONFIG_HOME=$HOME/.config # default
export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc" # Cross platform and nvim/vim agnostic
export GVIMINIT="source $XDG_CONFIG_HOME"/vim/gvimrc
export SSH_ASKPASS="ssh-askpass"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

# source anything that I may have wanted in only a local configuration.
shopt -s nullglob # prevents errors from no files.
for file in $XDG_CONFIG_HOME/bash_profile/*; do
    source $file
done
shopt -u nullglob
