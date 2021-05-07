" Setting up Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Colorschemes
Bundle 'croaker/mustang-vim'
Bundle 'altercation/vim-colors-solarized'
Bundle 'vim-scripts/xoria256.vim'
Bundle 'morhetz/gruvbox'

"rainbow parenthesis -- Coloring of nested parenthesis
Bundle 'kien/rainbow_parentheses.vim'

"NERDTree -- File browser in vim
Bundle 'scrooloose/nerdtree'

"NERDcommenter -- Auto comment out lines
Bundle 'scrooloose/nerdcommenter'

" Multiple cursors
Bundle 'terryma/vim-multiple-cursors'

"Ctlr-P Stuff
Bundle 'kien/ctrlp.vim'

" vim-airline
Bundle 'bling/vim-airline'

" Vim auto previews for markdown
Bundle 'shime/vim-livedown'

" fugitive: git plugin
Bundle 'tpope/vim-fugitive'

" Proper pep8 indents for python
Bundle 'hynek/vim-python-pep8-indent'

"""""""""""""""""""""""""""""""""
"Clojure stuff
"""""""""""""""""""""""""""""""""
" Clojure REPL and auto-execute
Bundle 'tpope/vim-fireplace'

" Support for the leiningen build system
Bundle 'tpope/vim-leiningen'

" Slurp, spit, and general LISP editing tools
Bundle 'vim-scripts/paredit.vim'

Bundle 'guns/vim-clojure-static'
Bundle 'gizmo385/vim-clojure-highlight'
