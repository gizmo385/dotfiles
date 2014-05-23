#!/usr/bin/env bash

# Move the home directory
pushd ~

# Clone the repo
git clone https://github.com/gizmo385/dotfiles.git

# Copy everything from the repo to the directory
mv dotfiles/bashrc ./.bashrc
mv dotfiles/vimrc ./.vimrc
mv dotfiles/bash_aliases ./.bash_aliases
mv dotfiles/bash_profile ./.bash_profile
mv dotfiles/clean_files.py .

# Remove the cloned repo
rm -rf dotfiles

# Resource the bashrc
source .bashrc

# Go back to whatever directory I was in
popd
