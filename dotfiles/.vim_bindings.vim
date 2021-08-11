"""""""""""""""""""""""""""""
" General leader commands
"""""""""""""""""""""""""""""
let mapleader = ","     " make , the <leader> instead of \

" ,ww strips trailing whitespace
nnoremap <leader>ww :%s/\s\+$//<cr>:let @/=''<CR>

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
" Plugin bindings
"""""""""""""""""""""""""""""
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap gm :LivedownPreview<CR>

if has('nvim-0.5')
    " Neovim specific bindings
    nnoremap <C-p> <cmd>:Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
    nnoremap <C-f> <cmd>:Telescope live_grep grep_open_files=true<cr>
else
    " Regular vim specific bindings
    nnoremap <C-P> :GFiles<CR>
endif

if has('nvim-0.5')
    lua << EOF
local nvim_lsp = require('lspconfig')

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', '<leader>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '<leader>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<leader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pyright', 'rust_analyzer', 'tsserver' }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
EOF
endif
