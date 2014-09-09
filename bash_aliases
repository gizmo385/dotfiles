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

# Map cmd so that it opens the terminal
alias cmd='gnome-terminal'

# Open a javascript interpreter with jsc (Shamelessly stolen from Gary Bernhart)
alias jsc='rhino'

# Remove files created by vim (.swp & .un~)
alias clean='python3 ~/clean_files.py "$PWD"'

# Aliases for easily creating virtualenvs for Python
alias py3vm='mkvirtualenv --python=/usr/bin/python3.3'
alias py2vm='mkvirtualenv --python=/usr/bin/python2.7'

# Application aliases
alias sql='sqlite3'
alias groot='cd "$(git rev-parse --show-toplevel)"'
alias sgradle='gradle --build-file $(find $(git rev-parse --show-toplevel) -name "build.gradle") $1'
