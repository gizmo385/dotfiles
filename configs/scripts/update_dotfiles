#!/usr/bin/env bash
set -euo pipefail

full_path() {
    python3 -c "import pathlib; print(pathlib.Path('$1').expanduser().resolve().parent)"
}

DOTFILES_DIR=$(full_path ${BASH_SOURCE[0]})
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"
if [[ -d /nix/var/nix/profiles/default/bin ]]; then
    NIX_BIN="/nix/var/nix/profiles/default/bin"
elif [[ -d "$HOME/.nix-profile/bin" ]]; then
    NIX_BIN="$HOME/.nix-profile/bin"
fi

if [ ! -d $DOTFILES_GIT_DIR ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

# Pull the most updated copy
git --git-dir ${DOTFILES_GIT_DIR} fetch
git --git-dir ${DOTFILES_GIT_DIR} rebase --autostash FETCH_HEAD

# Update nix packages
$NIX_BIN/nix-channel --update
$NIX_BIN/nix-env -i -f "$HOME/.nixpkgs/dev-env.nix" --show-trace
