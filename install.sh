#!/usr/bin/env bash
set -eo pipefail

# Let's get some more verbose output when we're building the container
if ! [ -z $BUILDING_DOTFILES_CONTAINER ]; then
    set -x
fi

full_path() {
    python3 -c "import pathlib; print(pathlib.Path('$1').expanduser().resolve().parent)"
}

###################################################################################################
### Update the dotfiles repo
###################################################################################################
DOTFILES_DIR=$(full_path ${BASH_SOURCE[0]})
DOTFILES_GIT_DIR="${DOTFILES_DIR}/.git"

if [ ! -d $DOTFILES_GIT_DIR ]; then
    echo "Expected ${DOTFILES_DIR} to be dotfiles git repo, but found no git directory! Aborting..."
    exit 1
fi

# Pull the most updated copy
if [ -z $BUILDING_DOTFILES_CONTAINER ]; then
    git --git-dir ${DOTFILES_GIT_DIR} fetch
    git --git-dir ${DOTFILES_GIT_DIR} rebase --autostash FETCH_HEAD
fi

cd cli/
./dfs dotfiles all
