"""""""""""""""""""""""""""""
" General leader commands
"""""""""""""""""""""""""""""
let mapleader = ","     " make , the <leader> instead of \

"Open in the same buffer
nnoremap <leader>ev :e ~/.vimrc <CR>

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

"""""""""""""""""""""""""""""
" Mode bindings
"""""""""""""""""""""""""""""
" Entering command mode with ; instead of :
nnoremap ; :

" Exiting insert mode
inoremap jj <ESC>
inoremap JJ <ESC>

"""""""""""""""""""""""""""""
" Plugin bindings
"""""""""""""""""""""""""""""
nnoremap gm :LivedownPreview<CR>

if has('nvim-0.5')
    " Neovim specific bindings
    nnoremap <C-p> <cmd>:Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
    nnoremap <C-f> <cmd>:Telescope live_grep<cr>
    nnoremap <leader>n :NvimTreeToggle<CR>
    nnoremap <leader>N :NvimTreeFindFile<CR>

    nnoremap <leader>a <cmd>lua vim.lsp.buf.code_action({apply = true})<CR>
else
    " Regular vim specific bindings
    nnoremap <C-P> :GFiles<CR>
    nnoremap <leader>n :NERDTreeToggle<CR>
endif

" Autocompletion
" Use <Tab> and <S-Tab> to navigate through popup menu
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect

" Avoid showing message extra message when using completion
set shortmess+=c

" Taglist
nnoremap <leader>t :TagbarToggle<CR>

" Vimwiki
nnoremap <leader>vg <cmd>lua require('telescope').extensions.vw.live_grep()<cr>
nnoremap <leader>vw <cmd>lua require('telescope').extensions.vw.live_grep()<cr>
nnoremap <leader>v/ <cmd>lua require('telescope').extensions.vw.live_grep()<cr>
nnoremap <leader>d  :VimwikiDiaryIndex<cr>:VimwikiDiaryGenerateLinks<cr>
nnoremap <leader>du :VimwikiDiaryGenerateLinks<cr>
nnoremap <leader>dn :VimwikiMakeDiaryNote<cr>

autocmd BufEnter *.wiki noremap <buffer> <C-p> <cmd>lua require('telescope').extensions.vimwiki.vimwiki()<cr>
autocmd BufEnter *.wiki noremap <buffer> <C-f> <cmd>lua require('telescope').extensions.vimwiki.live_grep()<cr>
