#!/usr/bin/env bash
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
git --git-dir ${DOTFILES_GIT_DIR} stash > /dev/null
git --git-dir ${DOTFILES_GIT_DIR} pull
git --git-dir ${DOTFILES_GIT_DIR} stash pop > /dev/null

###################################################################################################
### Installing nix
###################################################################################################
curl -L https://nixos.org/nix/install | sh
source $HOME/.nix-profile/etc/profile.d/nix.sh

###################################################################################################
### Symlinking and setting up the necessary configs
###################################################################################################
echo "Symlinking ${DOTFILES_DIR}/dotfiles/.[!.]* into ${HOME}"
ln -sf ${DOTFILES_DIR}/dotfiles/.[!.]* $HOME

# Install and update the nix-darwin configurations
if [[ $OSTYPE == 'darwin'* ]]; then
    # Install nix-darwin
    nix-build https://github.com/LnL7/nix-darwin/archive/master.tar.gz -A installer
    ./result/bin/darwin-installer

    # Symlink nixpkgs configurations
    echo "Symlinking nix Darwin configs"
    mkdir -p $HOME/.nixpkgs
    ln -sf $DOTFILES_DIR/dotfiles/nixpkgs/darwin-configuration.nix $HOME/.nixpkgs/darwin-configuration.nix

    darwin-rebuild switch
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
if [[ ! -d "$HOME/.config/omf" ]]; then
    echo "Installing oh-my-fish"
    curl -L https://get.oh-my.fish | fish
fi

# Install the fisher plugin manager
if [[ ! -f "$HOME/.fisher" ]]; then
    echo "Installing fisher (Fish plugin manager"
    curl -sL https://git.io/fisher > $HOME/.fisher
    fish -c "source $HOME/.fisher && fisher install jorgebucaran/fisher"
fi

# Install plugins for fish
fish -c "source $HOME/.fisher && fisher install PatrickF1/fzf.fish && fzf_configure_bindings"

# Symlink the fish config
mkdir -p $HOME/.config/fish
ln -sf ${DOTFILES_DIR}/dotfiles/config/fish/config.fish $HOME/.config/fish/config.fish

###################################################################################################
### Coder specific setup instructions
###################################################################################################
if [[ -n $CODER_ENVIRONMENT_NAME ]]; then
    echo "Running coder personalization"
    echo "Installing nix Coder packages"
    $NIX_BIN_LOCATION/nix-channel --update
    $NIX_BIN_LOCATION/nix-env --upgrade
    $NIX_BIN_LOCATION/nix-env -iA nixpkgs.bat nixpkgs.fzf nixpkgs.gitAndTools.delta nixpkgs.nodePackages.pyright nixpkgs.ripgrep nixpkgs.tmux

    echo "Installing neovim"
    $NIX_BIN_LOCATION/nix-channel --update
    sudo add-apt-repository ppa:neovim-ppa/unstable
    sudo apt-get update
    sudo apt-get install neovim
fi

echo Finished installing dotfiles. Please source the relevant files for your shell.
