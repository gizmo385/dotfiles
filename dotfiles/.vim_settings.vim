""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
""""""""""""""""""""""""""""""""""""""""""""""""""
 " Set my terminal colors
if $TERM == "xterm-256color"
  set t_Co=256
endif

let g:tex_flavor = "latex"      " Preferred version of TeX

set nocompatible                " give me vim, not vi
set modelines=0                 " no exploits plox

set showcmd                     " display incomplete commands

set encoding=utf-8              " encoding of the people
set scrolloff=5                 " start scrolling before I hit the bottom

set showmode                    " tell me what mode I'm working in
set ruler                       " show line and column of current position
set relativenumber              " show line numbers relative to the current line
set number

set hidden                      " lets us know about all buffers
set wildmenu                    " show us all completions
set wildmode=list:longest
set ttyfast                     " fast terminal = moar characters sent
set backspace=indent,eol,start  " delete anything
set laststatus=2                " always have a status line
set undofile                    " make my undos persistent
set noswapfile                  " disable swap files

set noeb vb t_vb=               " nothing should beep or flash

set mouse=a


""""""""""""""""""""""""""""""""""""""""""""""""""
" Search/Replace settings
""""""""""""""""""""""""""""""""""""""""""""""""""
set ignorecase                  " ignore case when searching
set smartcase                   " unless I mix case
set incsearch                   " search incrementally
set hlsearch                    " highlight search matches
set showmatch                   " jump to matching brackets

""""""""""""""""""""""""""""""""""""""""""""""""""
" Cursor, line formatting, column highlight
""""""""""""""""""""""""""""""""""""""""""""""""""
set cursorcolumn
"set cursorline

set wrap                        " wrap lines
set textwidth=100               " max width is 100 characters
set formatoptions=qrn1          " r = insert comment character,

set colorcolumn=+1              " highlight the column after textwidth
highlight ExtraWhitespace ctermbg=yellow guibg=yellow
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=yellow guibg=yellow
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/

""""""""""""""""""""""""""""""""""""""""""""""""""
" Tabs/Spaces/Indentation
""""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=4                   " four space indent
set shiftwidth=4
set softtabstop=4
set expandtab                   " I want spaces, not tabs
set shiftround                  " round my spaces to a multiple of shiftwidth

set autoindent                  " give me some indent
set smartindent                 " make good indentation choices

" Other settings
set lazyredraw

""""""""""""""""""""""""""""""""""""""""""""""""""
" Other useful settings
""""""""""""""""""""""""""""""""""""""""""""""""""
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
            \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
