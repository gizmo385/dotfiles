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

###################################################################################################
### Installing nix if necessary and sourcing the nix environment
###################################################################################################
NIX_SOURCE_SCRIPT=""
find_nix_install() {
    # Figure out which script to source
    if [[ -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh ]]; then
        NIX_SOURCE_SCRIPT="/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh"
    elif [[ -f $HOME/.nix-profile/etc/profile.d/nix.sh ]]; then
        NIX_SOURCE_SCRIPT="$HOME/.nix-profile/etc/profile.d/nix.sh"
    fi
}

## Install nix if necessary
find_nix_install
if [[ -z "${NIX_SOURCE_SCRIPT}" ]]; then
    curl -L https://nixos.org/nix/install | sh
    find_nix_install
    . $NIX_SOURCE_SCRIPT
    nix-channel --update
fi

###################################################################################################
### Installing some python packages
###################################################################################################
if [[ $OSTYPE == 'linux*' ]]; then
    sudo pip install python-lsp-server python-lsp-ruff
fi

###################################################################################################
### Symlinking and setting up the necessary configs
###################################################################################################
echo "Symlinking config files into ${HOME}"
mkdir -p $HOME/.config/nvim $HOME/.config/fish
ln -sf ${DOTFILES_DIR}/configs/shells/bash/bash_profile $HOME/.bash_profile
ln -sf ${DOTFILES_DIR}/configs/shells/bash/bashrc $HOME/.bashrc
ln -sf ${DOTFILES_DIR}/configs/shells/common/aliases $HOME/shell_aliases
ln -sf ${DOTFILES_DIR}/configs/shells/fish/config.fish $HOME/.config/fish/config.fish
ln -sf ${DOTFILES_DIR}/configs/shells/zsh/zshrc $HOME/.zshrc
ln -sf ${DOTFILES_DIR}/configs/tmux/tmux.conf $HOME/.tmux.conf
ln -sf ${DOTFILES_DIR}/configs/nvim/init.vim $HOME/.config/nvim/init.vim
ln -sf ${DOTFILES_DIR}/configs/vim/vimrc $HOME/.vimrc
ln -sf ${DOTFILES_DIR}/configs/vim/bindings.vim $HOME/bindings.vim
ln -sf ${DOTFILES_DIR}/configs/vim/plugin_settings.vim $HOME/plugin_settings.vim
ln -sf ${DOTFILES_DIR}/configs/vim/plugins.vim $HOME/plugins.vim
ln -sf ${DOTFILES_DIR}/configs/vim/settings.vim $HOME/settings.vim
ln -sf ${DOTFILES_DIR}/configs/git/gitconfig $HOME/.gitconfig
ln -sf ${DOTFILES_DIR}/configs/git/global_gitignore $HOME/.global_gitignore

# Symlink the VSCode config, which is in a different location depending on the system
if [[ $OSTYPE == 'darwin'* ]]; then
    mkdir -p "$HOME/Library/Application Support/Code/User"
    ln -s ${DOTFILES_DIR}/configs/vscode/settings.json $HOME/Library/Application\ Support/Code/User/settings.json
elif [[ $OSTYPE == 'linux'* ]]; then
    mkdir -p $HOME/.config/Code/User/
    mkdir -p $HOME/.vscode-remote/data/Machine
    mkdir -p $HOME/.vscode-remote/data/User
    ln -s ${DOTFILES_DIR}/configs/vscode/settings.json $HOME/.config/Code/User/settings.json
    # This is specifically for codespaces support
    ln -s ${DOTFILES_DIR}/configs/vscode/settings.json $HOME/.vscode-remote/data/Machine/settings.json
    ln -s ${DOTFILES_DIR}/configs/vscode/settings.json $HOME/.vscode-remote/data/User/settings.json
fi

# Install and update the dev env configurations
echo "Installing nix packages"
nix-env --show-trace -i -f ${DOTFILES_DIR}/configs/nix/dev-env.nix

# Install neovim on Linux
if [[ $OSTYPE == 'linux'* ]]; then
    echo "Installing neovim from apt-get"
    sudo apt-get update -y --fix-missing
    sudo DEBIAN_FRONTEND=noninteractive apt-get -y install software-properties-common
    sudo add-apt-repository -y ppa:neovim-ppa/unstable
    sudo apt-get update -y
    sudo apt-get install -y neovim
fi

# Symlink the dotfile management scripts
ln -sf ${DOTFILES_DIR}/update.sh $HOME/.update_dotfiles.sh
ln -sf ${DOTFILES_DIR}/install.sh $HOME/.install_dotfiles.sh

###################################################################################################
### ZSH Setup (specifically oh-my-zsh)
###################################################################################################
# Install oh-my-zsh if it does not exist
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo "Installing oh-my-zsh"
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" \
        --unattended --keep-zshrc
fi

###################################################################################################
### Fish-Shell setup (specifically oh-my-fish and fisher)
###################################################################################################
# Install oh-my-fish if it does not exist
OMF_INSTALL_LOCATION=$HOME/.local/share/omf
if [[ ! -d $OMF_INSTALL_LOCATION ]]; then
    echo "Installing oh-my-fish"
    curl -L https://raw.githubusercontent.com/oh-my-fish/oh-my-fish/master/bin/install > omf_install
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

# Install neovim plugins
nvim --headless +PlugInstall +qa

echo Finished installing dotfiles. Please source the relevant files for your shell.
