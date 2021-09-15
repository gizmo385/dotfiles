#!/usr/bin/env bash
NIX_BIN_LOCATION=$HOME/.nix-profile/bin
if [[ -f $NIX_BIN_LOCATION/nix-env ]]; then
    echo "Installing nix packages"
    $NIX_BIN_LOCATION/nix-channel --update
    $NIX_BIN_LOCATION/nix-env --upgrade
    $NIX_BIN_LOCATION/nix-env -iA nixpkgs.bat nixpkgs.fzf nixpkgs.gitAndTools.delta nixpkgs.neovim nixpkgs.nodePackages.pyright nixpkgs.ripgrep nixpkgs.tmux
fi
