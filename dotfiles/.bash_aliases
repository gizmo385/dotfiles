# Fix my typos
alias cd..='cd ..'
alias celar='clear'
alias gits='git'

# Aliases for ls
alias ls='eza'
alias ll='eza -alF'
alias la='eza -A'
alias lsa='eza -ACF'
alias l='eza -F'

# Tree-structured ls
alias lst="find . -name '*' | sed -e 's/^/|-/' -e 's/[^-][^\/]*\//|   /g' -e 's/|   \([A-Za-z0-9_.]\)/|   +--\1/'"

# Directory tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"

# Remove files created by vim (.swp & .un~)
alias clean='python $HOME/.scripts/clean_files.py'

# Application aliases
alias untar='tar -xf'
alias clip="xclip -sel clip"

# Managing dotfiles
alias update_dotfiles="$HOME/.update_dotfiles.sh"
alias reinstall_dotfiles="$HOME/.install_dotfiles.sh"
alias dfs="~/.dotfiles/cli/dfs"

# Git aliases
alias gs="git status"
alias gc="git commit"
alias ga="git add"
alias gap="git add --patch"

alias gco="git checkout"
alias gcob="git checkout -b"
alias gb="git branch -vv"
alias gbd="git branch -D"

alias gd="git diff"
alias gds="git diff --staged"
alias gdp="git --no-pager diff --patch"

alias gmb="git merge-base --fork-point origin/main HEAD"
