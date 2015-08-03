" Setting up Vundle
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

" Colorschemes
"Bundle 'lsdr/monokai'
Bundle 'croaker/mustang-vim'

"rainbow parenthesis -- Coloring of nested parenthesis
Bundle 'kien/rainbow_parentheses.vim'

" Taglist - displays important code elements
Bundle 'vim-scripts/taglist.vim'

"NERDTree -- File browser in vim
Bundle 'scrooloose/nerdtree'

"NERDcommenter -- Auto comment out lines
Bundle 'scrooloose/nerdcommenter'

" Multiple cursors
Bundle 'terryma/vim-multiple-cursors'

"Ctlr-P Stuff
Bundle 'kien/ctrlp.vim'

" Neocomplete with cache
Bundle 'Shougo/neocomplcache.vim'

" vim-airline
Bundle 'bling/vim-airline'

" Vim auto previews for markdown
Bundle 'shime/vim-livedown'

" fugitive: git plugin
Bundle 'tpope/vim-fugitive'

" Scratch pad for vim
Bundle 'mtth/scratch.vim'

" Proper pep8 indents for python
Bundle 'hynek/vim-python-pep8-indent'

" Control spotify from vim
Bundle 'gizmo385/spotify.vim'

"""""""""""""""""""""""""""""""""
"Clojure stuff
"""""""""""""""""""""""""""""""""
" Typed clojure support
Bundle 'typedclojure/vim-typedclojure'

" Clojure REPL and auto-execute
Bundle 'tpope/vim-fireplace'

" Support for the leiningen build system
Bundle 'tpope/vim-leiningen'

" Slurp, spit, and general LISP editing tools
Bundle 'vim-scripts/paredit.vim'

Bundle 'guns/vim-clojure-static'
Bundle 'guns/vim-clojure-highlight'
