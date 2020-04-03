[[ -f ~/.bashrc ]] && . ~/.bashrc

export XDG_CONFIG_HOME=$HOME/.config # default
export PATH="$HOME/bin:$HOME/.cargo/bin:$PATH"
export EDITOR="$(which nvim)"
export VISUAL="$EDITOR"
export VIMINIT="source $XDG_CONFIG_HOME/vim/vimrc" # Cross platform and nvim/vim agnostic
export GVIMINIT="source $XDG_CONFIG_HOME"/vim/gvimrc
export SSH_ASKPASS="ssh-askpass"
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc

export FZF_DEFAULT_OPTS="
    --layout=reverse
    --info=inline
    --height=80%
    --multi
    --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {}))
                || ([[ -d {} ]] && (tree -C {} | less))
                || echo {} 2> /dev/null | head -200'
    --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
    --prompt='∼ ' --pointer='▶' --marker='✓'
    --bind '?:toggle-preview'
    --bind 'ctrl-a:select-all'
    --bind 'ctrl-y:execute-silent(echo {+} | xclip -selection clipboard)'
    --bind 'ctrl-e:execute(echo {+} | xargs -o nvim)'"

# source anything that I may have wanted in only a local configuration.
shopt -s nullglob # prevents errors from no files.
for file in $XDG_CONFIG_HOME/bash_profile/*; do
    source $file
done
shopt -u nullglob
