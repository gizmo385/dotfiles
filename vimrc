"Vundle Stuff
filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

if $TERM == "xterm-256color"
  set t_Co=256
endif

" let Vundle manage Vundle
Bundle 'gmarik/vundle'

"Mustang Color Scheme
Bundle 'croaker/mustang-vim'
colorscheme mustang

"Solarized Color Scheme
Bundle 'altercation/vim-colors-solarized'
let g:solarized_termcolors=256

"colorscheme solarized
"set background=light
set background=dark

"rainbow parenthesis -- Coloring of nested parenthesis
Bundle 'kien/rainbow_parentheses.vim'
au VimEnter * RainbowParenthesesToggle
au VimEnter * RainbowParenthesesLoadBraces

"NERDTree -- File browser in vim
Bundle 'scrooloose/nerdtree'

"quit if its the only buffer left
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"NERDcommenter -- Auto comment out lines
Bundle 'scrooloose/nerdcommenter'

"vim-snipmate, dependencies, and snippet files. Useful snippet completion
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'garbas/vim-snipmate'
Bundle 'honza/vim-snippets'

"Snips settings
let g:snips_email='cachapline8@gmail.com'
let g:snips_github='gizmo385'
let g:snips_authro='Christopher'

"Ctlr-P Stuff
Bundle 'kien/ctrlp.vim'
set runtimepath^=~/.vim/bundle/ctrlp.vim

filetype plugin indent on
filetype plugin on

let &t_Co=16
syntax enable

set nocompatible              " give me vim, not vi
set modelines=0               " no exploits plox

set tabstop=4                 " four space indent
set shiftwidth=4
set softtabstop=4
set expandtab                 " I want spaces, not tabs
set shiftround                " round my spaces to a multiple of shiftwidth

set showcmd                   " display incomplete commands

set encoding=utf-8            " encoding of the people
set scrolloff=5               " start scrolling before I hit the bottom
set autoindent                " give me some indent
set smartindent               " make good indentation choices
set showmode                  " tell me what mode I'm working in
set showcmd                   " tells us useful thing about what we are doing
set hidden                    " lets us know about all buffers
set wildmenu                  " show us all completions
set wildmode=list:longest
set ttyfast                   " fast terminal = moar characters sent
set ruler                     " show line and column of current position
set backspace=indent,eol,start  " delete anything
set laststatus=2                " always have a status line
set relativenumber            " show line numbers relative to the current line
set number
set undofile                  " make my undos persistent

let mapleader = ","     " make , the <leader> instead of \
" leader is useful for custom commands

"sane regexes, like perl and python
nnoremap / /\v
vnoremap / /\v
nnoremap \ :%s/\v
vnoremap \ :%s/\v

set ignorecase  " ignore case when searching
set smartcase   " unless I mix case
set gdefault    " replace everything on a line by default
set incsearch   " search incrementally
set hlsearch    " highlight search matches
set showmatch   " jump to matching brackets

"clear out highlighting by hitting ', '
nnoremap <leader><space> :noh<cr>

"make tab match bracket pairs
"nnoremap <tab> %
"vnoremap <tab> %

set wrap              " wrap lines
set textwidth=80      " max width is 81 characters
set formatoptions=qrn1 " r = insert comment character,
" q = format comments with gq,
" n1 = recognize formatted lists
set colorcolumn=+1     " highlight the column after textwidth
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=yellow guibg=yellow
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
"call matchadd('ErrorMsg', '\%>79v.\+')

" If you want to make sure not to use arrow keys,
" uncomment the following lines.
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" fix file lines vs. editor lines
nnoremap j gj
nnoremap k gk


" use ; for commands instead of :
nnoremap ; :

au FocusLost * :wa    " save on losing focus

" ,W strips trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" jj for escape
inoremap jj <ESC>
inoremap JJ <ESC>

"make a new window and switch to it
"nnoremap <leader>w <C-w>v<C-w>l

"change windows with <C-movement>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" nothing should beep or flash
set noeb vb t_vb=

fixdel   " makes the delete key work better

set mouse=a

" automatically save and restore my folds
autocmd BufWinLeave *.* mkview
autocmd BufWinEnter *.* silent loadview

"bundle related mappings

"turn off numbering and reenable for copy/paste ease
"nnoremap <leader>nn :set nu!<cr>:set nu!<cr>
"nnoremap <leader>rn :set relativenumber<cr>

"nerdtree is ,n
map <leader>n :NERDTreeToggle<CR>

"CtrlP search buffers is ,b
"nmap <leader>b :CtrlPBuffer<CR>

"force the use of latex style tex files
let g:tex_flavor = "latex"

if has('gui_running')
    colorscheme default
endif
