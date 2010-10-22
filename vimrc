"
" Maintainer: Eiichi Sato
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" {{{

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" }}}

" Settings: ----------------------------
" {{{ .vimrc editing and reloading

" automatic reloading
if has("autocmd")
	autocmd BufWritePost .vimrc source $MYVIMRC
endif

nmap <leader>v :vsplit $MYVIMRC<CR>

" }}}
" {{{ encoding and format

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp

set fileformat=unix
set fileformats=unix,dos,mac

" }}}
" {{{ indenting

" these below are the defaults. maybe overridden later
set tabstop=2
set shiftwidth=2
set noexpandtab
"set cindent
"set autoindent

" }}}
" {{{ colors
"
" set terminal color
set t_Co=256

" colorscheme delek slate delek zell wombat rdark
if &t_Co >= 256
	colorscheme myxoria256
else
	colorscheme desert
endif

" }}}
" {{{ terminal titles

" for 'screen'
set t_ts=k
set t_fs=\
set titlestring=%t
set title

" }}}
" {{{ encryption

" use more secure cryptmethod
if version >= 703
	set cryptmethod=blowfish
endif

" }}}
" {{{ extended modeline

au BufReadPost * call VimModelineExec()
function! VimModelineExec()
	" read modelines
	let end = line("$")
	let tail = getline(max([end-&modelines+1, 1]), end)
	" iterate through lines
	for line in tail
		let mlist = matchlist(line, '^.*[ \t]vimexec: \?\(.*\):.*$')
		if len(mlist) > 1
			exec mlist[1]
		endif
	endfor
endfunction

" }}}
" {{{ folding

" default folding
set foldmethod=marker
set foldmarker={{{,}}}

" }}}
" {{{ undo

" enable persistent undo
if version >= 703
	set undofile
	set undodir=/tmp
endif

" }}}
" {{{ status line

" always show statusline
set laststatus=2
set statusline=%<%f\ %y[%{&fileencoding},%{&fileformat}]%{GitBranchInfoString()}%{cfi#format(\"[%s()]\",\"\")}%h%m%r%=%-14.(%l,%c%V%)\ %P%{XPMautoUpdate(\"statusline\")}
" list candidates in statusline for commandline completion
set wildmenu

" show INSERT when in the mode.
set showmode
" show incomplete commands
set showcmd

" }}}
" {{{ miscellaneous

set incsearch		" do incremental searching
set smartcase			" but don't ignore it, when search string contains uppercase letters
set ignorecase			" ignore case

set nowrap
set ruler		" show the cursor position all the time
set showmatch			" showmatch: Show the matching bracket for the last ')'?
set number
set noerrorbells "do not ring error bells
set shellslash
set scrolloff=2 		" 2 lines bevore and after the current line when scrolling

set grepprg=grep\ -nH\ $*
set makeprg=make

set history=500 "overwrite the default above

set iminsert=0
set imsearch=0
inoremap <ESC> <ESC>:set iminsert=0<CR>:echo<CR>

"set completeopt=menu,longest,preview
set completeopt=menuone

" set swap directory
set directory=~/.vim/swp

" list and open buffer (trailing space needed)
nnoremap gb :ls<CR>:buf 

" natural movement for wrapped lines
nnoremap j gj
nnoremap k gk

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" tab shown as >---
set listchars+=tab:>-

" }}}

" FileTypes: ---------------------------
" {{{ xml

let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" }}}
" {{{ python

au FileType python setlocal expandtab
au FileType python setlocal tabstop=4
au FileType python setlocal softtabstop=4
au FileType python setlocal shiftwidth=4
if version >= 703
	au FileType python setlocal colorcolumn=80
endif
let g:python_space_error_highlight = 1
au FileType python setlocal omnifunc=pythoncomplete#Complete

" }}}
" {{{ C

au FileType c,cpp setlocal dict=~/.vim/dict/c/*.dict
au FileType c,cpp setlocal commentstring=\ \/\*\ %s\ \*\/
au FileType c,cpp setlocal list listchars+=precedes:<,extends:>
let g:c_space_errors = 1

" }}}
" {{{ gtk

" emulate devhelp.vim using vim-ref
let s:lastword = ''
function! RefreshGtkdoc()
		let s:word = GetCursorWord()
		if len(s:word) > 4 && s:lastword != s:word
			call ref#open('gtkdoc', s:word, {'noenter': 1})
			let s:lastword = s:word
		endif
endfunction

" for gtk development
let g:Filetype_c_gtk = 0
au BufReadPost,BufWritePost *.c,*.h call CheckGtkDevehelopment()
function! CheckGtkDevehelopment()
	for s:line in getline(0, line("$"))
		if s:line =~# '<glib.h>' || s:line =~# '<gtk/gtk.h>'
			let g:Filetype_c_gtk = 1
			break
		endif
	endfor

	if g:Filetype_c_gtk
"		setlocal updatetime=150
"		au CursorHold <buffer> call RefreshGtkdoc()
"		au CursorHoldI <buffer> call RefreshGtkdoc()
"		inoremap <buffer> <silent> <C-n> <C-n><C-r>=RefreshGtkdoc()?'':''<Esc><C-n><C-p>
"		inoremap <buffer> <silent> <C-p> <C-p><C-r>=RefreshGtkdoc()?'':''<Esc><C-n><C-p>
		nnoremap <buffer> <silent> K :call RefreshGtkdoc()<CR>
	endif
endfunction

" }}}
" {{{ vala

au BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead *.vala set smartindent
au BufRead *.vala set cindent
au BufRead,BufNewFile *.vala setfiletype vala
au BufRead,BufNewFile *.vapi setfiletype vala

" }}}
" {{{ brainfuck
au BufRead *.bf setfiletype brainfuck
" }}}
" {{{ C#

au FileType cs setlocal commentstring=\ \/\*\ %s\ \*\/
au FileType cs setlocal efm=%f(%l,%c):\ error\ CS%n:\ %m

" }}}
" {{{ shell script
"
au BufWritePost *.sh exe "silent !chmod +x %"

" }}}
" {{{ squirrel

au! BufRead,BufNewFile *.nut setfiletype squirrel

" }}}
" {{{ vim script

" }}}
" {{{ actionscript

au BufRead,BufNewFile *.as set filetype=actionscript
au FileType actionscript setlocal dictionary+=~/.vim/dict/actionscript/actionscript.dict
au FileType actionscript set omnifunc=actionscriptcomplete#Complete

" }}}

" Commands: ----------------------------
" {{{ :WriteSudo

" write with root permission
function! WriteSudo(...)
	if a:0 > 0
		exec "write !sudo tee ".a:1." > /dev/null"
		exec "file ".a:1
		set nomodified
	else
		write !sudo tee % > /dev/null
	endif
endfunction
command! -nargs=? -complete=file WriteSudo call WriteSudo(<f-args>)

" }}}
" {{{ :DiffOrig

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" }}}

" Plugins: -----------------------------
" {{{ vim-latex

set runtimepath+=~/.vim/runtime/vim-latex/vimfiles
let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
"let g:Tex_ViewRule_dvi = 'xdvik-ja'
let g:tex_flavor = "latex"

" }}}
" {{{ localvimrc (script_id = 441)

let g:localvimrc_name = '.lvimrc'
let g:localvimrc_count = -1
let g:localvimrc_sandbox = 1
let g:localvimrc_ask = 0

" }}}
" {{{ SrcExpl

nnoremap <silent> <Leader>j :SrcExplToggle<CR>
let g:SrcExpl_winHeight = 8 " // Set the height of Source Explorer window
let g:SrcExpl_refreshTime = 100 " // Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_jumpKey = "<ENTER>" " // Set "Enter" key to jump into the exact definition context
let g:SrcExpl_gobackKey = "<SPACE>" " // Set "Space" key for back from the definition context
" // In order to Avoid conflicts, the Source Explorer should know what plugins
" // are using buffers. And you need add their bufname into the list below
" // according to the command ":buffers!"
let g:SrcExpl_pluginList = [
        \ "__Tag_List__",
        \ "_NERD_tree_",
        \ "Source_Explorer"
    \ ]
let g:SrcExpl_searchLocalDef = 0 " search local file for the keyword
let g:SrcExpl_isUpdateTags = 0 " // Let the Source Explorer update the tags file when opening
let g:SrcExpl_updateTagsCmd = "ctags --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --exclude=*~ ." " // Use program 'ctags' with argument '--sort=foldcase -R' to update a tags file
let g:SrcExpl_updateTagsKey = "<F12>" " // Set <F12> key for updating the tags file artificially

" }}}
" {{{ VimWiki

let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.auto_export = 1
let wiki.path_html = '~/vimwiki/html/'
let wiki.html_header = '~/vimwiki/header.html'
let g:vimwiki_list = [wiki]
let g:vimwiki_folding = 1
let g:vimwiki_camel_case = 0

" }}}
" {{{ vim-quickrun

set runtimepath+=~/.vim/runtime/vim-quickrun
nnoremap <silent> <Leader>r :QuickRun >> -mode n<CR>
vnoremap <silent> <Leader>r :QuickRun >> -mode v<CR>

" }}}
" {{{ xp template

set runtimepath+=~/.vim/runtime/xpt
set runtimepath+=~/.vim/runtime/xpt_personal
let g:xptemplate_brace_complete = ''
let g:xptemplate_key = '<C-\>'

" }}}
" {{{ NERDTree

set runtimepath+=~/.vim/runtime/nerdtree
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>

" }}}
" {{{ taglist

set runtimepath+=~/.vim/runtime/taglist
"let Tlist_Auto_Open = 1
nnoremap <silent> <Leader>f :TlistToggle<CR>

" }}}
" {{{ neocomplcache

set runtimepath+=~/.vim/runtime/neocomplcache
let g:neocomplcache_enable_at_startup = 1
inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()
" let g:neocomplcache_dictionary_filetype_lists =
"			\ {
"			\ 	'default': '',
"			\ 	'actionscript': $HOME.'/.vim/dict/actionscript/*.dict'
"			\ }

" }}}
" {{{ devhelp

" au CursorHold *.c,*.h call DevhelpUpdate('a')
" au CursorHoldI *.c,*.h call DevhelpUpdate('a')
" let g:devhelpSearch=1 " To enable devhelp search:
" let g:devhelpAssistant=1 " To enable devhelp assistant:
" let g:devhelpSearchKey = '<F10>' " To change the search key (e.g. to F5):
" au FileType c,cpp setlocal updatetime=150 " To change the update delay (e.g. to 150ms):
" let g:devhelpWordLength = 5 " To change the length (e.g. to 5 characters) before a word becomes relevant:

" }}}
" {{{ autocomplpop

"set runtimepath+=~/.vim/runtime/autocomplpop

" }}}
" {{{ vim-ref

set runtimepath+=~/.vim/runtime/vim-ref-gtkdoc
set runtimepath+=~/.vim/runtime/vim-ref
let g:ref_gtkdoc_cmd='gtkdoc'
let g:ref_noenter=1

" }}}
" {{{ current-func-info.vim

set runtimepath+=~/.vim/runtime/current-func-info

" }}}
" {{{ metarw-git

set runtimepath+=~/.vim/runtime/vim-metarw
set runtimepath+=~/.vim/runtime/metarw-git

" }}}
" {{{ git-branch-info.vim

let g:git_branch_status_head_current=1
let g:git_branch_status_text=''
let g:git_branch_status_nogit=''
let g:git_branch_status_around='[]'
let g:git_branch_status_ignore_remotes=1

" }}}
" {{{ surround.vim (script_id = 1697)

set runtimepath+=~/.vim/runtime/vim-surround

" }}}

" vim: ts=2:sw=2:sts=0:fdm=marker:fmr={{{,}}}
