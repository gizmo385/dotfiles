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

# Directory tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Remove files created by vim (.swp & .un~)
alias clean='python $HOME/.scripts/clean_files.py'

# Create new latex files easily
alias newlatex='cat ~/.scripts/template.tex >'

# cd aliases
cdof_func() {
    result=$(python ${HOME}/.scripts/cdof.py \
        $(git rev-parse --show-toplevel 2>/dev/null || echo ".") \
        $1)
    cd $result
}

alias cdof='cdof_func'

# Application aliases
alias latex='pdflatex -interaction=nonstopmode'
alias untar='tar -xf'
alias commajoin='paste -s -d","'

# Git aliases
alias groot='cd "$(git rev-parse --show-toplevel)"'
alias gs='git status'

# Package manager upgrades
alias pipupgrade='pip list | grep -Po "^[A-Za-z0-9\-]+" | xargs sudo -H pip install --upgrade'
alias globalignore='gibo --upgrade --list | grep -A 30 Global | tail -n +3 | tr "\n" " " | xargs gibo'

# Managing dotfiles
GIT_FILE_HOST="https://raw.githubusercontent.com"
GIT_USER="gizmo385"
REPO_NAME="dotfiles"
REPO_BRANCH="master"
alias update_dotfiles="cd ${HOME}/.dotfiles && git pull"

# Application aliases which have dependencies
function command_exists {
    command -v $1 > /dev/null 2>&1
    return $?
}

if command_exists bat; then
    alias cat=bat
fi

if command_exists nvim; then
    alias vim=nvim
fi


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
        #alias vim="mvim -v"
        alias clip="pbcopy"
        alias alert="terminal-notifier -message"
        ;;
    *) ;;
esac
