#!/bin/bash

echo "Creating links"

USER_HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)

if [ ! -d "$USER_HOME/.config" ]; then
    mkdir $USER_HOME/.config
fi
if [ ! -d "$USER_HOME/.config/tmux" ]; then
    mkdir $USER_HOME/.config/tmux
fi
if [ ! -d "$USER_HOME/.config/tmux/plugins" ]; then
    mkdir $USER_HOME/.config/tmux/plugins
    chown ${USER} $USER_HOME/.config/tmux/plugins
fi

# Add symbiotic links
ln -s -f -t $USER_HOME/ $USER_HOME/.dotfiles/.bashrc $USER_HOME/.dotfiles/.angular-config
ln -s -f $USER_HOME/.dotfiles/nvim $USER_HOME/.config
ln -s -f $USER_HOME/.dotfiles/tmux/tmux.conf $USER_HOME/.config/tmux 

echo "Created links"
