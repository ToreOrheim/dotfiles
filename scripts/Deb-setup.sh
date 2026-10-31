#!/bin/bash

echo "Beginning setup"
USER_HOME=$(getent passwd ${SUDO_USER:-$USER} | cut -d: -f6)
# Create new folders
$USER_HOME/.dotfiles/scripts/Links.sh

# Install tools
$USER_HOME/.dotfiles/scripts/Tools.sh


# Install neovim
git clone https://github.com/neovim/neovim &&
cd neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo &&
cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb
cd $USER_HOME

# Install global npm packages
sudo npm install -g tree-sitter-cli neovim
sudo npm install -g @fsouza/prettierd

echo "Finsihed setup"
