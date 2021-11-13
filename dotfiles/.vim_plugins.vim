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
Plug 'sainnhe/everforest'

" rainbow parenthesis -- Coloring of nested parenthesis
Plug 'kien/rainbow_parentheses.vim'

" NERDcommenter -- Auto comment out lines
Plug 'scrooloose/nerdcommenter'

" Multiple cursors
Plug 'mg979/vim-visual-multi'

" Bottom bar line in vim
Plug 'bling/vim-airline'

" Vim auto previews for markdown
Plug 'shime/vim-livedown'

" Clojure REPL and auto-execute
Plug 'tpope/vim-fireplace'

" Support for the leiningen build system
Plug 'tpope/vim-leiningen'

" Slurp, spit, and general LISP editing tools
Plug 'vim-scripts/paredit.vim'

" Syntax highlighting
Plug 'ryanoasis/vim-devicons'

"""""""""""""""""""""""""""""""""
" Language syntax highlighting
"""""""""""""""""""""""""""""""""
Plug 'guns/vim-clojure-static'
Plug 'gizmo385/vim-clojure-highlight'
Plug 'LnL7/vim-nix'
Plug 'pangloss/vim-javascript'
Plug 'raimon49/requirements.txt.vim'
Plug 'google/vim-jsonnet'
Plug 'dag/vim-fish'
Plug 'ocaml/vim-ocaml'
Plug 'simrat39/rust-tools.nvim'

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

    " Auto-complete
    Plug 'hrsh7th/cmp-nvim-lsp'
    Plug 'hrsh7th/cmp-buffer'
    Plug 'hrsh7th/cmp-path'
    Plug 'hrsh7th/cmp-cmdline'
    Plug 'hrsh7th/nvim-cmp'

    " Formatting
    Plug 'sbdchd/neoformat'

    " File Explorer
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'kyazdani42/nvim-tree.lua'

    " Neovim specific colorschemes
    Plug 'sainnhe/edge'
    Plug 'rktjmp/lush.nvim'
    Plug 'lourenci/github-colors'
else
    " FZF is a file-finder plugin
    Plug 'junegunn/fzf'
    Plug 'junegunn/fzf.vim'

    " NERDTree -- File browser in vim
    Plug 'scrooloose/nerdtree'
endif

call plug#end()
