# Fix my typos
alias cd..='cd ..'
alias celar='clear'
alias gits='git'

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

# Application aliases
alias untar='tar -xf'
alias clip="xclip -sel clip"

# Managing dotfiles
alias update_dotfiles="$HOME/.update_dotfiles.sh"
alias reinstall_dotfiles="$HOME/.install_dotfiles.sh"

# Application aliases which have dependencies
bat --help > /dev/null && alias cat=bat
nvim --version > /dev/null && alias vim=nvim

