" Colorscheme
":silent! colorscheme monokai
let g:solarized_termcolors=256
colorscheme gruvbox
set background=dark


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


let &t_Co=256
syntax enable

" Taglist settings
let Tlist_WinWidth = 60

" Nerdtree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Ctrl-P stuff
" set runtimepath^=~/.vim/bundle/ctrlp.vim
" set wildignore+=*.class,*.o,*.a,*.pyc
" let g:ctrlp_custom_ignore= '\v(.*[\/](node_modules|doc|build|bin|gen|res)[\/].*)|(*.(o|class))'

 "Neocomplete
let g:neocomplcache_enable_at_startup = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_smart_case = 1
let g:neocomplcache_force_overwrite_completefunc = 1

autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
au BufNewFile,BufRead *.gradle setf groovy


" Scratch pad for vim
let g:scratch_no_mappings = 1

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
