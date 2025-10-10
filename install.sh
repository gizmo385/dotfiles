#!/usr/bin/env bash
set -eo pipefail

# Let's get some more verbose output when we're building the container
if [ -n "$BUILDING_DOTFILES_CONTAINER" ]; then
    set -x
fi

###################################################################################################
### Update the dotfiles repo
###################################################################################################
SCRIPT_SOURCE=$(realpath "${BASH_SOURCE[0]}")
DOTFILES_DIR=$(dirname "$SCRIPT_SOURCE")
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"

if [ ! -d "$DOTFILES_GIT_DIR" ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

# Pull the most updated copy
if [ -z "$BUILDING_DOTFILES_CONTAINER" ]; then
    git --git-dir "${DOTFILES_GIT_DIR}" fetch
    git --git-dir "${DOTFILES_GIT_DIR}" rebase --autostash FETCH_HEAD
fi


###################################################################################################
### Installing nix if necessary and sourcing the nix environment
###################################################################################################
NIX_SOURCE_SCRIPT=""
find_nix_install() {
    # Figure out which script to source
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        NIX_SOURCE_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    elif [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
        NIX_SOURCE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

## Install nix if necessary
find_nix_install
if [[ -z "${NIX_SOURCE_SCRIPT}" ]]; then
    curl -L https://nixos.org/nix/install | sh
    find_nix_install
fi

. $NIX_SOURCE_SCRIPT

# Copy some configs over
mkdir -p "$HOME/.config/home-manager"
mkdir -p "$HOME/.config/nix"

# Ensure the configs exist
ln -sf "${DOTFILES_DIR}/modules/home.nix" "${HOME}/.config/home-manager/home.nix"
ln -sf "${DOTFILES_DIR}/configs/nix.conf" "${HOME}/.config/nix/nix.conf"

USE_NEW_NIX=1 nix run .#setupDotfiles
