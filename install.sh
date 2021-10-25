#!/usr/bin/env bash
set -eo pipefail

# Let's get some more verbose output when we're building the container
if [! -z $BUILDING_DOTFILES_CONTAINER ]; then
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

###################################################################################################
### Installing nix if necessary and sourcing the nix environment
###################################################################################################
NIX_BIN=$HOME/.nix-profile/bin
if [[ ! -d "$HOME/.nix-profile" ]]; then
    curl -L https://nixos.org/nix/install | sh
fi

. $HOME/.nix-profile/etc/profile.d/nix.sh

###################################################################################################
### Symlinking and setting up the necessary configs
###################################################################################################
echo "Symlinking ${DOTFILES_DIR}/dotfiles/.[!.]* into ${HOME}"
ln -sf ${DOTFILES_DIR}/dotfiles/.[!.]* $HOME

# Symlink nixpkgs configurations
echo "Symlinking nix configs"
mkdir -p $HOME/.nixpkgs
ln -sf $DOTFILES_DIR/dotfiles/nix/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix
ln -sf $DOTFILES_DIR/dotfiles/nix/dev-env.nix $HOME/.nixpkgs/dev-env.nix

# Install and update the nix-darwin configurations
if [[ $OSTYPE == 'darwin'* ]]; then
    # Install nix-darwin
    if ! command -v darwin-rebuild; then
        nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
        ./result/bin/darwin-installer
    fi

    # Install system packages
    darwin-rebuild switch
else
    $NIX_BIN/nix-channel --update
    $NIX_BIN/nix-env -i -f "$HOME/.nixpkgs/dev-env.nix"
fi


# Symlink Neovim configs
echo "Symlinking Neovim configs"
mkdir -p $HOME/.config/nvim
ln -sf ${DOTFILES_DIR}/dotfiles/config/nvim/init.vim $HOME/.config/nvim/init.vim

# Symlink the dotfile management scripts
ln -sf ${DOTFILES_DIR}/update.sh $HOME/.update_dotfiles.sh
ln -sf ${DOTFILES_DIR}/install.sh $HOME/.install_dotfiles.sh

###################################################################################################
### ZSH Setup (specifically oh-my-zsh)
###################################################################################################
# Install oh-my-zsh if it does not exist
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
fi

###################################################################################################
### Fish-Shell setup (specifically oh-my-fish and fisher)
###################################################################################################
# Install oh-my-fish if it does not exist
OMF_INSTALL_LOCATION=$HOME/.local/share/omf
if [[ ! -d $OMF_INSTALL_LOCATION ]]; then
    echo "Installing oh-my-fish"
    curl -L https://get.oh-my.fish > omf_install
    fish omf_install --path=$OMF_INSTALL_LOCATION --noninteractive
    rm omf_install
fi

# Install the fisher plugin manager
if [[ ! -f "$HOME/.fisher" ]]; then
    echo "Installing fisher (Fish plugin manager"
    curl -sL https://git.io/fisher > $HOME/.fisher
    fish -c "source $HOME/.fisher && fisher install jorgebucaran/fisher"
fi

# Install plugins for fish
fish -c "source $HOME/.fisher && fisher install PatrickF1/fzf.fish " # && fzf_configure_bindings"
fish "$HOME/.config/fish/functions/fzf_configure_bindings.fish"
fish -c "source $HOME/.fisher && fisher install lilyball/nix-env.fish"

# Install OMF themes
fish -c "omf install coffeeandcode 2> /dev/null"

# Symlink the fish config
mkdir -p $HOME/.config/fish
ln -sf ${DOTFILES_DIR}/dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish

# Setup (neo)vim
nvim --headless +PlugInstall +qa

echo Finished installing dotfiles. Please source the relevant files for your shell.
