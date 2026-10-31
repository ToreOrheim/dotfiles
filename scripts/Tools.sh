#!/bin/bash

echo "Installing tools"

# Get nodejs registry key
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20

sudo apt update && sudo apt upgrade
sudo apt install -y \
    clang \
    cmake \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    file \
    nodejs \
    ripgrep \
    fd-find \
    ca-certificates \
    curl \
    tmux \
    gnupg \
    wget

# Get dotnet registry key
sudo apt install -y wget
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
sudo apt install -y \
    dotnet-sdk-7.0 \
    aspnetcore-runtime-7.0 

if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
echo "Installed tools"
