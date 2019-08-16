" we need the conceal feature (vim ≥ 7.3)
if exists('g:no_lisp_conceal') || !has('conceal') || &enc != 'utf-8'
    finish
endif

hi link lispNiceOperator Operator
hi! link Conceal Operator

setlocal conceallevel=1
