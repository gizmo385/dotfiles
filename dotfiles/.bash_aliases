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
alias sgradle='gradle --build-file $(find $(git rev-parse --show-toplevel) -name "build.gradle") $1'
alias latex='pdflatex -interaction=nonstopmode'
alias untar='tar -xf'
alias commajoin='paste -s -d","'

# Screen aliases
alias lscreen='screen -ls' # List screens
alias rscreen='screen -r' # Attach to a screen

# Kills a detached named screen
_screen_kill() {
    if [ -z $1 ]; then
        echo Please supply a screen name!
        exit 1
    else
        screen -X -S $1 quit
    fi
}
alias qscreen='_screen_kill'

# Starts a detached named screen and executes the arguments after the first argument
_bg_screen() {
    screen -S $1 -dm bash -c "'${@:2}'; exec ${SHELL}"
}
alias bgscreen='_bg_screen'

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
alias update_dotfiles="cd ${HOME}/.dotfiles && git pull"

# Application aliases which have dependencies
if command -v pygmentize > /dev/null; then
    # Replaces cat with a version that includes syntax highlighting
    _cat_func() {
        cat "$@" | pygmentize -O style=monokai -f console256 -g
    }
    alias ccat=_cat_func
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
        alias vim="mvim -v"
        alias clip="pbcopy"
        alias alert="terminal-notifier -message"
        ;;
    *) ;;
esac
