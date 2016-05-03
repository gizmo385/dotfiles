# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="mortalscumbag"
#ZSH_THEME="frisk"
#ZSH_THEME="amuse"

# Uncomment the following line to display red dots whilst waiting for completion.
#COMPLETION_WAITING_DOTS="true"

# The plugins to load
plugins=(git)

source $ZSH/oh-my-zsh.sh
source $HOME/.bash_aliases

# User configuration

export VISUAL=vim
export EDITOR="$VISUAL"

# Forming the path
export PATH="/usr/local/sbin":$PATH
export PATH="/usr/local/bin":$PATH
export PATH="/usr/sbin":$PATH
export PATH="/usr/bin":$PATH
export PATH="/sbin":$PATH
export PATH="/bin":$PATH
export PATH="/usr/games":$PATH
export PATH="/usr/local/games":$PATH
export PATH="/home/christopher/.rvm/bin":$PATH
export PATH="/home/christopher/.rvm/bin":$PATH
export PATH="/opt/gradle-1.12/bin":$PATH
export PATH="/home/christopher/.rvm/bin":$PATH
export PATH="/opt/gradle-1.12/bin":$PATH
export PATH="/":$PATH
export PATH="/home/christopher/.shell_scripts/":$PATH
export PATH="/bin":$PATH
export PATH="/usr/bin":$PATH
export PATH="/Library/Frameworks/Python.framework/Versions/3.3/bin":$PATH
export PATH=".scripts":$PATH
export PATH="/opt/local/bin":$PATH
export PATH="/usr/texbin":$PATH
export PATH="/usr/local/bin":$PATH

# export MANPATH="/usr/local/man:$MANPATH"
export ANDROID_HOME="/home/christopher/sdk"


source $HOME/.shell_scripts/gibo-completion.zsh

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

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Load the global gitignore
git config --global core.excludesfile ~/.global_gitignore

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='mvim'
fi
