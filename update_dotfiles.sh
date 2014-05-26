#!/usr/bin/env bash

# This bash script will clone down the dotfiles from the github repo and copy
# them into your home directory.
#
# Execute with "bash update_dotfiles.sh" or with the "dotfiles" alias defined in
# the bash_aliases file.

# Move the home directory
pushd ~

# Clone the repo
echo "Cloning dotfiles..."
git clone --quiet https://github.com/gizmo385/dotfiles.git

# Copy everything from the repo to the directory
echo "Replacing old dotfiles"
mv dotfiles/bashrc ./.bashrc
mv dotfiles/vimrc ./.vimrc
mv dotfiles/bash_aliases ./.bash_aliases
mv dotfiles/bash_profile ./.bash_profile
mv dotfiles/update_dotfiles.sh .
mv dotfiles/clean_files.py .

# Remove the cloned repo
echo "Removing cloned repo..."
rm -rf dotfiles

# Re-source the bashrc
source ~/.bashrc

# Go back to whatever directory I was in
popd
