#!/usr/bin/env bash
full_path() {
    python3 -c "import pathlib; print(pathlib.Path('$1').expanduser().resolve().parent)"
}

DOTFILES_DIR=$(full_path ${BASH_SOURCE[0]})
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"

if [ ! -d $DOTFILES_GIT_DIR ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

# Pull the most updated copy
git --git-dir ${DOTFILES_GIT_DIR} stash > /dev/null
git --git-dir ${DOTFILES_GIT_DIR} pull
git --git-dir ${DOTFILES_GIT_DIR} stash pop > /dev/null
