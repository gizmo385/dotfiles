" Setting up vim-plug (https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation)
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Colorschemes
Plug 'gruvbox-community/gruvbox'

" rainbow parenthesis -- Coloring of nested parenthesis
Plug 'kien/rainbow_parentheses.vim'

" NERDTree -- File browser in vim
Plug 'scrooloose/nerdtree'

" NERDcommenter -- Auto comment out lines
Plug 'scrooloose/nerdcommenter'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Bottom bar line in vim
Plug 'bling/vim-airline'

" Vim auto previews for markdown
Plug 'shime/vim-livedown'

" fugitive: git plugin
Plug 'tpope/vim-fugitive'

" Proper pep8 indents for python
Plug 'hynek/vim-python-pep8-indent'

"""""""""""""""""""""""""""""""""
" Clojure stuff
"""""""""""""""""""""""""""""""""
" Clojure REPL and auto-execute
Plug 'tpope/vim-fireplace'

" Support for the leiningen build system
Plug 'tpope/vim-leiningen'

" Slurp, spit, and general LISP editing tools
Plug 'vim-scripts/paredit.vim'

" Syntax highlighting
Plug 'guns/vim-clojure-static'
Plug 'gizmo385/vim-clojure-highlight'

"""""""""""""""""""""""""""""""""
" Language syntax highlighting
"""""""""""""""""""""""""""""""""
Plug 'LnL7/vim-nix'
Plug 'pangloss/vim-javascript'

" If we're running in neovim (version > 0.5), we'll install some additional nvim plugins
if has('nvim-0.5')
    " Telescope, a file-finder plugin
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'

    " Tree-sitter is a parser tool
    Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
    Plug 'nvim-treesitter/playground'

    " Language Server Protocol Plugins
    Plug 'neovim/nvim-lspconfig'

    " Neovim specific colorschemes
    Plug 'sainnhe/edge'
    Plug 'sainnhe/everforest'
    Plug 'rktjmp/lush.nvim'
    Plug 'lourenci/github-colors'
else
    " FZF is a file-finder plugin
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'
endif

call plug#end()
