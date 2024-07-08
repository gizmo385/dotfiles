#!/usr/bin/env bash
set -euo pipefail

SCRIPT_SOURCE=$(realpath "${BASH_SOURCE[0]}")
DOTFILES_DIR=$(dirname "$SCRIPT_SOURCE")
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"

if [ ! -d "$DOTFILES_GIT_DIR" ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

USE_NEW_NIX=1 nix develop .#setupDotfiles
