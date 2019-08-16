# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="mortalscumbag"

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

# Load the global gitignore
git config --global core.excludesfile ~/.global_gitignore

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='mvim'
fi

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

