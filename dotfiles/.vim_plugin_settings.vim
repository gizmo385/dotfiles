
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

" Nerdtree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

 "Neocomplete
let g:neocomplcache_enable_at_startup = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_smart_case = 1
let g:neocomplcache_force_overwrite_completefunc = 1

autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
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

" Setting the Colorscheme
let t_Co=256
set background=dark
set termguicolors
let g:edge_style = 'neon'
let g:everforest_background = 'hard'
colorscheme everforest

" Neovim specific configurations
if has('nvim-0.5')
lua << EOF
require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true,              -- false will disable the whole extension
        disable = { "clojure" }
    },
}
EOF
endif
