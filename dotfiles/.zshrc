# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="amuse"

# The plugins to load
plugins=(git)

source $ZSH/oh-my-zsh.sh

source $HOME/.bash_aliases

# User configuration
export VISUAL=vim
export EDITOR="$VISUAL"

# Forming the path
export PATH=".scripts":$PATH
export PATH="/bin":$PATH
export PATH="/opt/local/bin":$PATH
export PATH="/sbin":$PATH
export PATH="/usr/bin":$PATH
export PATH="/usr/games":$PATH
export PATH="/usr/local/bin":$PATH
export PATH="/usr/local/sbin":$PATH
export PATH="/usr/sbin":$PATH

fancy-ctrl-z () {
  if [[ $#BUFFER -eq 0 ]]; then
    BUFFER="fg"
    zle accept-line
  else
    zle push-input
    zle clear-screen
  fi
}
zle -N fancy-ctrl-z
bindkey '^Z' fancy-ctrl-z

# Disable retrieving git status in prompt
git config --global --replace-all oh-my-zsh.hide-status 1
git config --global --replace-all oh-my-zsh.hide-dirty 1


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

if [ -e /Users/gizmo385/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/gizmo385/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
fpath=($fpath "/Users/gizmo385/.zfunctions")

# Set Spaceship ZSH as a prompt
