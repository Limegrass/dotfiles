export XDG_CONFIG_HOME=$HOME/.config # default
export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH:$XDG_CONFIG_HOME/bin"
export EDITOR="$(command -v nvim || command -v vim)"
export VISUAL="$EDITOR"
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc" # Cross platform and nvim/vim agnostic
export GVIMINIT="source $XDG_CONFIG_HOME"/vim/gvimrc
export SSH_ASKPASS="$(command -v ssh-askpass)"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export WINIT_X11_SCALE_FACTOR=1 # no scaling by screen dpi

export FZF_DEFAULT_COMMAND="$([ $(command -v rg) ] \
    && echo `command -v rg` --smart-case --hidden --no-ignore-vcs)"
export FZF_DEFAULT_OPTS="
    --layout=reverse
    --info=inline
    --height=80%
    --multi
    --preview '$XDG_CONFIG_HOME/bin/fzf-preview {}'
    --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
    --prompt='∼ ' --pointer='▶' --marker='✓'
    --bind '?:toggle-preview'
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
    --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"
