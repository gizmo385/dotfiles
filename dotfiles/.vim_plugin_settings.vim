
" Rainbow Parenthesis
au VimEnter * RainbowParenthesesToggle
au VimEnter * RainbowParenthesesLoadBraces

" Clojure specific Rainbow Parenthesis settings
autocmd VimEnter,BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesActivate
autocmd VimEnter,BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadRound
autocmd VimEnter,BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadSquare
autocmd VimEnter,BufEnter *.cljs,*.clj,*.cljs.hl RainbowParenthesesLoadBraces
autocmd VimEnter,BufEnter *.cljs,*.clj,*.cljs.hl setlocal iskeyword+=?,-,*,!,+,/,=,<,>,.,:

" Other language Rainbow Parenthesis settings
autocmd VimEnter,BufEnter *.py,*.java RainbowParenthesesActivate
autocmd VimEnter,BufEnter *.py,*.java RainbowParenthesesLoadRound
autocmd VimEnter,BufEnter *.py,*.java RainbowParenthesesLoadSquare
autocmd VimEnter,BufEnter *.py,*.java RainbowParenthesesLoadBraces

autocmd Syntax clojure EnableSyntaxExtension

filetype plugin indent on
filetype plugin on

syntax enable

autocmd FileType python setlocal colorcolumn=120
au BufNewFile,BufRead *.gradle setf groovy

" Clojure stuff
let g:clojure_fuzzy_indent = 1
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^go']
let g:clojure_fuzzy_indent_blacklist = ['-fn$', '\v^with-%(meta|out-str|loading-context)$']
let g:clojure_align_multiline_strings = 1

let g:paredit_electric_return=0

function! SetClojureOptions()
    setlocal filetype=clojure
    setlocal autoindent
    setlocal tabstop=2
    setlocal shiftwidth=2
    setlocal expandtab
endfunction
autocmd BufNewFile,BufRead *.clj call SetClojureOptions()

au BufNewFile,BufRead *.clj setlocal sw=2 ts=2 expandtab
au BufNewFile,BufRead *.ts,*.js setlocal sw=2 ts=2 expandtab

" Setting the Colorscheme
let t_Co=256
set background=dark
set termguicolors
let g:edge_style = 'neon'
let g:everforest_background = 'hard'
colorscheme everforest

" Neovim specific configurations
if has('nvim-0.5')
    autocmd BufEnter * lua require'completion'.on_attach()
    " Configure the completion chains
	let g:completion_chain_complete_list = {
	    \ 'default': [
	    \   {'complete_items': ['lsp', 'ts']},
	    \]
	    \}

" Lua specific configuration
lua << EOF
local nvim_lsp = require('lspconfig')

-- Treesitter
require'nvim-treesitter.configs'.setup {
    -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ensure_installed = "maintained",
    highlight = {
        enable = true,
        disable = { "clojure" }
    },
    indent = {
        enable = true,
        disable = {"python"}
    },
}

 -- Python language server setup
nvim_lsp.pyright.setup{}

-- Setting up NvimTree
require'nvim-tree'.setup {}

-- Typescript language server
nvim_lsp.tsserver.setup {
    on_attach = function(client)
        client.resolved_capabilities.document_formatting = false
        on_attach(client)
    end
}

-- Use a loop to conveniently call 'setup' on multiple servers and map buffer local keybindings
-- when the language server attaches
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
