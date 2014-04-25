" Vim indent file
" Language:     Perl 5
" Author:       Andy Lester <andy@petdance.com>
" URL:          http://github.com/petdance/vim-perl/tree/master
" Last Change:  June 3, 2009

" Suggestions and improvements by :
"   Aaron J. Sherman (use syntax for hints)
"   Artem Chuprina (play nice with folding)

" TODO things that are not or not properly indented (yet) :
" - Continued statements
"     print "foo",
"	"bar";
"     print "foo"
"	if bar();
" - Multiline regular expressions (m//x)
" (The following probably needs modifying the perl syntax file)
" - qw() lists
" - Heredocs with terminators that don't match \I\i*

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
    finish
endif
let b:did_indent = 1
