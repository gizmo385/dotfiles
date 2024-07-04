#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR=$(dirname $(realpath ${BASH_SOURCE[0]}))
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"

if [ ! -d "$DOTFILES_GIT_DIR" ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

nix develop .#setupDotfiles
