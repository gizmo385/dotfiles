" Colorscheme
:silent! colorscheme monokai

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

" -- Rainbow parenthesis colors
let g:rbpt_colorpairs = [
    \ ['darkyellow',  'RoyalBlue3'],
    \ ['darkgreen',   'SeaGreen3'],
    \ ['darkcyan',    'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['DarkMagenta', 'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkyellow',  'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['DarkMagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkyellow',  'DarkOrchid3'],
    \ ['darkred',     'firebrick3'],
    \ ]

" Taglist settings
let Tlist_WinWidth = 60
map <leader>t :TlistToggle<CR>

" Nerdtree settings
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
map <leader>n :NERDTreeToggle<CR>

" Ctrl-P stuff
nmap <leader>b :CtrlPBuffer<CR>
set runtimepath^=~/.vim/bundle/ctrlp.vim
set wildignore+=*.class,*.o,*.a,*.pyc
let g:ctrlp_custom_ignore= '\v(.*[\/](doc|build|bin|gen|res)[\/].*)|(*.(o|class))'

 "Neocomplete
let g:neocomplcache_enable_at_startup = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_smart_case = 1
let g:neocomplcache_force_overwrite_completefunc = 1

autocmd FileType java setlocal omnifunc=javacomplete#Complete
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
au BufNewFile,BufRead *.gradle setf groovy

inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

" Livedown Markdown previewer
nmap gm :LivedownPreview<CR>

" fugitive: git plugin
nnoremap gs :Gstatus<CR>
nnoremap ga :Gwrite<CR>
nnoremap gw :Gwrite<CR>
nnoremap gc :Gcommit<CR>
nnoremap gd :Gdiff<CR>
nnoremap gb :Gblame<CR>

" Scratch pad for vim
let g:scratch_no_mappings = 1
nnoremap sp :ScratchInsert<CR>
nnoremap cp :ScratchInsert!<CR>
xnoremap sp :ScratchSelection<CR>
xnoremap cp :ScratchSelection!<CR>

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
