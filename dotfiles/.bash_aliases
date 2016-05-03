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

# Tree-structured ls
alias lst="find . -name '*' | sed -e 's/^/|-/' -e 's/[^-][^\/]*\//|   /g' -e 's/|   \([A-Za-z0-9_.]\)/|   +--\1/'"

# Remote access aliases
alias lec='ssh lectura'

# Make cpr copy with the recursive flag
alias cpr='cp -r'

# Directory tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Remove files created by vim (.swp & .un~)
alias clean='python $HOME/.scripts/clean_files.py'

# Compile files
alias compile='bash $HOME/.scripts/compile'

# Easily access the C section of man
alias cman='man 3'
alias vim='mvim -v'

# Create new latex files easily
alias newlatex='cat ~/.scripts/template.tex >'

# cd aliases
cdof_func() {
    x=$(bash $HOME/.scripts/cdof `pwd` $1) && cd $x
}

alias cdof='cdof_func'

# Application aliases
alias sgradle='gradle --build-file $(find $(git rev-parse --show-toplevel) -name "build.gradle") $1'
alias latex='pdflatex -interaction=nonstopmode'
alias clip='xclip -sel clip'
alias untar='tar -xf'

# Git aliases
alias groot='cd "$(git rev-parse --show-toplevel)"'
alias gdd='view +:Gdiff +":nmap q :qa<CR>"'
alias gs='git status'

# Package manager upgrades
alias pipupgrade='pip list | grep -Po "^[A-Za-z0-9\-]+" | xargs sudo -H pip install --upgrade'
alias globalignore='gibo --upgrade --list | grep -A 30 Global | tail -n +3 | tr "\n" " " | xargs gibo'

# Managing dotfiles
GIT_FILE_HOST="https://raw.githubusercontent.com"
GIT_USER="gizmo385"
REPO_NAME="dotfiles"
REPO_BRANCH="master"
alias update_dotfiles='curl ${GIT_FILE_HOST}/${GIT_USER}/${REPO_NAME}/${REPO_BRANCH}/update_dotfiles | sh'

# Operating System specific aliases
OS=`uname`
case $OS in
    'Linux')
        alias search="apt-cache search"
        alias clip="xclip -sel clip"
        alias alert="notify-send -u low"
        ;;
    'Darwin')
        alias search="brew search"
        alias vim="mvim -v"
        alias clip="pbcopy"
        alias alert="terminal-notifier -message"
        ;;
    *) ;;
esac
