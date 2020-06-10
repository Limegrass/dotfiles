[[ -f ~/.bashrc ]] && . ~/.bashrc

source $HOME/.config/sh/profile.sh

# source anything that I may have wanted in only a local configuration.
shopt -s nullglob # prevents errors from no files.
for file in $HOME/.config/bash_profile/*; do
    source $file
done
shopt -u nullglob
