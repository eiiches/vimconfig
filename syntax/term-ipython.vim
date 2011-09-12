" Vim syntax file
" Language:     VimShell term-ipython
" Maintainer:   Eiichi Sato <sato.eiichi@gmail.com>
" Last Change:  2011 Sep 12

if exists('b:current_syntax')
	finish
endif

syntax include @Python syntax/python.vim
syntax region termipythonInput keepend oneline 
			\ matchgroup=termipythonPrompt start="^\(In \[\d\+\]\|   \.\.\.\): "
			\ matchgroup=termipythonPromptEnd end=" *$"
			\ contains=@Python
syntax match termipythonOutput "^Out\[\d\+\]: "

let b:current_syntax = 'term-ipython'
