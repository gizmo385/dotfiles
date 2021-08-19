#!/usr/bin/env bash
echo "Installing nix packages"
nix-env -iA \
    nixpkgs.bat \
    nixpkgs.fzf \
    nixpkgs.gitAndTools.delta \
    nixpkgs.neovim \
    nixpkgs.nodePackages.pyright \
    nixpkgs.ripgrep \
    nixpkgs.tmux

echo "Changing shell to zsh"
sudo chsh -s $(which zsh) $USER
