# Make it search to search the apt-cache
alias search='apt-cache search'

# Fix my typos
alias cd..='cd ..'

# Aliases for ls
alias ll='ls -alF'
alias la='ls -A'
alias lsa='ls -A'
alias l='ls -CF'

alias lec='ssh cachapline8@lectura.cs.arizona.edu'

# Make cpr copy with the recursive flag
alias cpr='cp -r'

# Map cmd so that it opens the terminal
alias cmd='gnome-terminal'

# Open a javascript interpreter with jsc (Shamelessly stolen from Gary Bernhart)
alias jsc='rhino'

# Aliases for easily creating virtualenvs for Python
alias py3vm='mkvirtualenv --python=/usr/bin/python3.3'
alias py2vm='mkvirtualenv --python=/usr/bin/python2.7'
