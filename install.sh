#!/usr/bin/env bash

# Utility functions
function command_exists {
    command -v $1 > /dev/null 2>&1
    return $?
}

# Set the location of the repository on github
repository_host="github.com"
repository_location="gizmo385/dotfiles"
repository_branch="main"

# Check that git is installed
command -v git > /dev/null 2>&1
if (( $? != 0 )) ; then
    echo Git is required to update dotfiles 1>&2
    exit 1
fi

DOTFILE_REPO_LOCATION="${HOME}/.dotfiles"
DOTFILE_REPO_GIT_DIR="${HOME}/.dotfiles/.git"

# Clone dotfiles if they aren't present
if [ ! -d "$HOME/.dotfiles" ]; then
    # Clone the dotfiles
    echo Cloning remote dotfiles...
    git clone --recursive https://${repository_host}/${repository_location} -b ${repository_branch} ${DOTFILE_REPO_LOCATION}
fi

# Pull the most updated copy

git --git-dir ${DOTFILE_REPO_GIT_DIR} stash > /dev/null
git --git-dir ${DOTFILE_REPO_GIT_DIR} pull
git_pull_exit_status=$?
git --git-dir ${DOTFILE_REPO_GIT_DIR} stash pop > /dev/null

# If the clone/pull operation failed, exit with the exit status provided by git
if (( $git_pull_exit_status != 0 )) ; then
    echo There was an error while attempting to clone/pull dotfiles! 1>&2
    exit $git_pull_exit_status
fi

# Symlink all the normal dotfiles
echo Symlinking dotfiles into ${HOME}
ln -sf $HOME/.dotfiles/dotfiles/.[!.]* $HOME

# Symlink nixpkgs configurations
echo "Symlinking nix Darwin configs"
mkdir -p $HOME/.nixpkgs
ln -sf $HOME/.dotfiles/dotfiles/nixpkgs/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix

# Symlink nvim configs
echo "Symlinking nvim configs"
mkdir -p $HOME/.config/nvim
ln -sf $HOME/.dotfiles/dotfiles/config/nvim/init.vim $HOME/.config/nvim/init.vim

# Install oh-my-zsh if it does not exist
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

# If we're running in coder, we'll run that personalization script
if [[ -n $CODER_ENVIRONMENT_NAME ]]; then
    echo "Running coder personalization"
    ./coder_personalize.sh
fi

echo Finished installing dotfiles. Please source the relevant files for your shell.
