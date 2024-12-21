[[ -f ~/.bashrc ]] && . ~/.bashrc

# source anything that I may have wanted in only a local configuration.
for file in $HOME/.config/sh/{*,**/*}; do
    [ -f $file ] && . $file
done

# if [[ -z $DISPLAY ]]; then
#     echo "Starting X in 1 seconds"
#     sleep 1s
#     startx
# fi
