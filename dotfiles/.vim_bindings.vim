"""""""""""""""""""""""""""""
" General leader commands
"""""""""""""""""""""""""""""
let mapleader = ","     " make , the <leader> instead of \

" ,ww strips trailing whitespace
nnoremap <leader>ww :%s/\s\+$//<cr>:let @/=''<CR>

" Open in a separate buffer
"nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC <CR>

"Open in the same buffer
nnoremap <leader>ev :e $MYVIMRC <CR>

"""""""""""""""""""""""""""""
" Search and Replace bindings
"""""""""""""""""""""""""""""
" Use sane regexes
nnoremap / /\v
vnoremap / /\v
nnoremap \ :%s/\v
vnoremap \ :%s/\v

"clear out highlighting by hitting ', '
nnoremap <leader><space> :noh<cr>

"""""""""""""""""""""""""""""
" Movement bindings
"""""""""""""""""""""""""""""
" Disable the arrow keys
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" File lines -> editor lines
nnoremap j gj
nnoremap k gk

" Moving the beginning of a line or end of a line
nnoremap H ^
nnoremap L $

" Change windows with <C-movement>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
noremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

"""""""""""""""""""""""""""""
" Copy/Paste bindings
"""""""""""""""""""""""""""""
" vp doesn't replace paste buffer
function! RestoreRegister()
  let @" = s:restore_reg
  return ''
endfunction
function! s:Repl()
  let s:restore_reg = @"
  return "p@=RestoreRegister()\<cr>"
endfunction
vmap <silent> <expr> p <sid>Repl()

" Copying to system clipboard (if installed)
vnoremap <C-c> "+y

" Toggle paste mode
nnoremap <C-p> :set paste!<cr>

"""""""""""""""""""""""""""""
" Mode bindings
"""""""""""""""""""""""""""""
" Entering command mode with ; instead of :
nnoremap ; :

" Exiting insert mode
inoremap jj <ESC>
inoremap JJ <ESC>

"""""""""""""""""""""""""""""
" Custom commands
"""""""""""""""""""""""""""""
" Allow saving of files as sudo when I forgot to start vim using sudo.
 cmap w!! w !sudo tee > /dev/null %


"""""""""""""""""""""""""""""
" Plugin bindings
"""""""""""""""""""""""""""""
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>t :TlistToggle<CR>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap gm :LivedownPreview<CR>

" Fugitive git commands
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gw :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>
nnoremap gb :Gblame<CR>

" Scratch pad
nnoremap sp :ScratchInsert<CR>
nnoremap cp :ScratchInsert!<CR>
xnoremap sp :ScratchSelection<CR>
xnoremap cp :ScratchSelection!<CR>

" Necomplete
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
