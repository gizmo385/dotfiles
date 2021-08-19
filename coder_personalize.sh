#!/usr/bin/env bash
echo "Installing nix packages"

if [[ -d "$HOME/.nix-profile/bin/nix-env" ]]; then
    echo "Installing nix packages"
    $HOME/.nix-profile/bin/nix-env -iA \
        nixpkgs.bat \
        nixpkgs.fzf \
        nixpkgs.gitAndTools.delta \
        nixpkgs.neovim \
        nixpkgs.nodePackages.pyright \
        nixpkgs.ripgrep \
        nixpkgs.tmux
fi

echo "Changing shell to zsh"
sudo chsh -s $(which zsh) $USER
