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

export PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/home/christopher/.rvm/bin:/home/christopher/.rvm/bin:/opt/gradle-1.12/bin:/home/christopher/.rvm/bin:/opt/gradle-1.12/bin:/:/home/christopher/.shell_scripts/"
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

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='mvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"
