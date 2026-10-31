#!/bin/bash

USER_HOME=$(getent passwd $SUDO_USER | cut -d: -f6)

cat > $USER_HOME/.gitconfig <<EOF
[init]
    defaultBranch = main
[user]
    email = toreorheim@gmail.com
    name = Tore Orheim
[core]
    editor = nvim
[fetch]
    prune = true
[alias]
    c = commit -m
    ca = commit -am
    sts = status
    sw = switch
    a = add
[status]
    short = true
EOF

echo "Generated .gitconfig at ~/.gitconfig"
