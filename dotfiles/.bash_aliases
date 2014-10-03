# Make it easy to search the apt-cache
alias search='apt-cache search'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Fix my typos
alias cd..='cd ..'
alias celar='clear'

# Aliases for ls
alias ll='ls -alF'
alias la='ls -A'
alias lsa='ls -ACF'
alias l='ls -CF'

# Remote access aliases
alias lec='ssh cachapline8@lectura.cs.arizona.edu'

# Make cpr copy with the recursive flag
alias cpr='cp -r'

# Directory tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Remove files created by vim (.swp & .un~)
alias clean='python3 $HOME/.scripts/clean_files.py "$PWD"'

# Compile files
alias compile='bash $HOME/.scripts/compile'

# Easily access the C section of man
alias cman='man 3'


cdof_func() {
    x=$(bash $HOME/.scripts/cdof `pwd` $1) && cd $x
}

# cd aliases
alias cdof='cdof_func'
#alias cdof='cd $(bash $HOME/.scripts/cdof .)'

# Application aliases
alias groot='cd "$(git rev-parse --show-toplevel)"'
alias sgradle='gradle --build-file $(find $(git rev-parse --show-toplevel) -name "build.gradle") $1'
