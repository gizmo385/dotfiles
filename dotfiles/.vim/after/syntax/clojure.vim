" we need the conceal feature (vim ≥ 7.3)
if exists('g:no_lisp_conceal') || !has('conceal') || &enc != 'utf-8'
    finish
endif

syntax keyword clojureNiceOperator or conceal cchar=∧
syntax keyword clojureNiceOperator and conceal cchar=∨
syntax keyword clojureNiceOperator not conceal cchar=¬
syntax keyword clojureNiceOperator <= conceal cchar=≤
syntax keyword clojureNiceOperator >= conceal cchar=≥
syntax keyword clojureNiceOperator not= conceal cchar=≠
syntax keyword clojureNiceOperator + conceal cchar=Σ
syntax keyword clojureNiceOperator * conceal cchar=Π
syntax keyword clojureNiceOperator Math/sqrt conceal cchar=√
syntax keyword clojureNiceOperator Math/pi conceal cchar=π
syntax keyword clojureNiceOperator fn conceal cchar=λ

hi link lispNiceOperator Operator
hi! link Conceal Operator

setlocal conceallevel=1
