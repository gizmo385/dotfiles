#!/usr/bin/env bash
# Useful functions
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

# Symlink all the normal dotfiles
echo "Symlinking ${DOTFILES_DIR}/dotfiles/.[!.]* into ${HOME}"
ln -sf ${DOTFILES_DIR}/dotfiles/.[!.]* $HOME

# Symlink nixpkgs configurations
echo "Symlinking nix Darwin configs"
mkdir -p $HOME/.nixpkgs
ln -sf ${DOTFILES_DIR}/dotfiles/nixpkgs/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix

# Symlink Neovim configs
echo "Symlinking Neovim configs"
mkdir -p $HOME/.config/nvim
ln -sf ${DOTFILES_DIR}/dotfiles/config/nvim/init.vim $HOME/.config/nvim/init.vim

# Symlink the dotfile management scripts
ln -sf ${DOTFILES_DIR}/update.sh $HOME/.update_dotfiles.sh
ln -sf ${DOTFILES_DIR}/install.sh $HOME/.install_dotfiles.sh

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
