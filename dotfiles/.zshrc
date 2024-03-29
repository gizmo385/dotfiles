# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="crcandy"

# The plugins to load
plugins=()

source $ZSH/oh-my-zsh.sh

# Forming the path
export PATH=$PATH:".scripts"
export PATH=$PATH:"/bin"
export PATH=$PATH:"/opt/local/bin"
export PATH=$PATH:"/sbin"
export PATH=$PATH:"/usr/bin"
export PATH=$PATH:"/usr/games"
export PATH=$PATH:"/usr/local/bin"
export PATH=$PATH:"/usr/local/sbin"
export PATH=$PATH:"/usr/sbin"

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

if [ -e ${HOME}/.nix-profile/etc/profile.d/nix.sh ]; then . ${HOME}/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer
fpath=($fpath "${HOME}/.zfunctions")

if [ -n "${commands[fzf-share]}" ]; then
  source "$(fzf-share)/key-bindings.zsh"
  source "$(fzf-share)/completion.zsh"
fi

source $HOME/.bash_aliases

# User configuration
if command -v nvim > /dev/null 2>&1; then
    export VISUAL=nvim
    alias vim=nvim
else
    export VISUAL=vim
fi
export EDITOR="$VISUAL"

if command -v bat > /dev/null 2>&1; then
    alias cat=bat
fi
