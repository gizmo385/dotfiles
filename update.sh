#!/usr/bin/env bash
full_path() {
    python3 -c "import pathlib; print(pathlib.Path('$1').expanduser().resolve().parent)"
}

DOTFILES_DIR=$(full_path ${BASH_SOURCE[0]})
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"
NIX_BIN=$HOME/.nix-profile/bin

if [ ! -d $DOTFILES_GIT_DIR ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

# Pull the most updated copy
git --git-dir ${DOTFILES_GIT_DIR} fetch
git --git-dir ${DOTFILES_GIT_DIR} rebase --autostash origin/main

# Update nix packages
$NIX_BIN/nix-channel --update
if [[ $OSTYPE == 'darwin'* ]]; then
    darwin-rebuild switch
else
    $NIX_BIN/nix-env -i -f "$HOME/.nixpkgs/dev-env.nix"
fi
