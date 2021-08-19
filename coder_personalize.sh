#!/usr/bin/env bash
NIX_ENV_LOCATION=$HOME/.nix-profile/bin/nix-env
if [[ -f $NIX_ENV_LOCATION ]]; then
    echo "Installing nix packages"
    $NIX_ENV_LOCATION -iA nixpkgs.bat nixpkgs.fzf nixpkgs.gitAndTools.delta nixpkgs.neovim nixpkgs.nodePackages.pyright nixpkgs.ripgrep nixpkgs.tmux
fi

echo "Changing shell to zsh"
sudo chsh -s $(which zsh) $USER
