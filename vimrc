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
	autocmd BufWritePost .vimrc,~/.vim/vimrc source $MYVIMRC
endif

nmap <leader>v :vsplit $MYVIMRC<CR>

" }}}
" {{{ encoding and format

set encoding=utf-8
set fileencoding=utf-8
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp,cp932

set fileformat=unix
set fileformats=unix,dos,mac

" }}}
" {{{ indenting

" these below are the defaults. maybe overridden later
set tabstop=4
set shiftwidth=4
set noexpandtab
"set autoindent
set copyindent
set cindent
set cinoptions=(0,u0,U0

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

" workaround for some enviroment.
if has("terminfo")
	set t_Sf=[3%p1%dm
	set t_Sb=[4%p1%dm
else
	set t_Sf=[3%dm
	set t_Sb=[4%dm
endif

" }}}
" {{{ terminal titles

" for 'screen'
if $STY != ''
	set t_ts=k
	set t_fs=\
	set titlestring=%t
	set title
endif

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

function! MyFoldText()
	return foldtext() . '...'
endfunction
set foldtext=MyFoldText()
set fillchars-=fold:-

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
set statusline=%<%f\ %y[%{&fileencoding},%{&fileformat}]%{GitBranchInfoString()}%h%m%r%=%-14.(%l,%c%V%)\ %P
" list candidates in statusline for commandline completion
set wildmenu

" show INSERT when in the mode.
set showmode
" show incomplete commands
set showcmd

" }}}
" {{{ search

set incsearch   " do incremental searching
set smartcase   " but don't ignore it, when search string contains uppercase letters
set ignorecase  " ignore case
set showmatch   " showmatch: Show the matching bracket for the last ')'?
set wrapscan    " search wrap around the end of the file
set report=0    " report always the number of lines changed
set matchpairs+=<:>

" }}}
" {{{ key mapping

" list and open buffer
nnoremap gb :ls<CR>:buf<Space>

" natural movement for wrapped lines
nnoremap j gj
nnoremap k gk
nnoremap gj j
nnoremap gk k

"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>

" reselect visual block after indent/unindent
vnoremap < <gv
vnoremap > >gv

" command line keymap
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-b> <C-Left>
cnoremap <C-w> <C-Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" }}}
" {{{ miscellaneous

set nowrap
set ruler		" show the cursor position all the time
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
" set directory=~/.vim/swp

" tab shown as >---
set listchars+=tab:>-

" split direction
set splitbelow
set splitright

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
au FileType c,cpp set foldcolumn=2
au FileType c,cpp let g:c_space_errors = 1
au FileType   cpp let g:c_no_curly_error = 1

" }}}
" {{{ D

au FileType d setlocal commentstring=\ \/\*\ %s\ \*\/
au FileType d setlocal list listchars+=precedes:<,extends:>

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
au BufReadPost,BufWritePost *.c,*.h,*.cpp,*.hpp call CheckGtkDevehelopment()
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

au FileType vim set foldcolumn=2

" }}}
" {{{ actionscript

au BufRead,BufNewFile *.as set filetype=actionscript
au FileType actionscript setlocal dictionary+=~/.vim/dict/actionscript/actionscript.dict
au FileType actionscript set omnifunc=actionscriptcomplete#Complete

" }}}
" {{{ MS Office

au BufReadCmd *.pptx call zip#Browse(expand("<amatch>"))
au BufReadCmd *.xlsx call zip#Browse(expand("<amatch>"))
au BufReadCmd *.docx call zip#Browse(expand("<amatch>"))

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
" {{{ localvimrc (script_id = 441)

let g:localvimrc_name = '.lvimrc'
let g:localvimrc_count = -1
let g:localvimrc_sandbox = 1
let g:localvimrc_ask = 0

" }}}
" {{{ srcexpl.vim (script_id = 2179)

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
" {{{ quickrun.vim (script_id = 3146)

set runtimepath+=~/.vim/runtime/vim-quickrun
nnoremap <silent> <Leader>r :QuickRun >> -mode n<CR>
vnoremap <silent> <Leader>r :QuickRun >> -mode v<CR>

" }}}
" {{{ NERDTree (script_id = 1658)

set runtimepath+=~/.vim/runtime/nerdtree
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right"

" }}}
" {{{ taglist (script_id = 273)

set runtimepath+=~/.vim/runtime/taglist
" let Tlist_Auto_Open = 1
" let g:Tlist_Use_Rigth_Window = 1
nnoremap <silent> <Leader>f :TlistToggle<CR>

" }}}
" {{{ neocomplcache

set runtimepath+=~/.vim/runtime/neocomplcache
let g:neocomplcache_enable_at_startup = 1
inoremap <expr><C-x><C-o> &filetype == 'vim' ? "\<C-x><C-v><C-p>" : neocomplcache#manual_omni_complete()
let g:neocomplcache_dictionary_filetype_lists =
		\ {
		\ 	'default': '',
		\ 	'actionscript': $HOME.'/.vim/dict/actionscript/*.dict'
		\ }

let g:neocomplcache_snippets_dir = '~/.vim/snippets'
imap <silent> <C-l> <Plug>(neocomplcache_snippets_expand)

" }}}
" {{{ vim-ref (script_id = 3067)

set runtimepath+=~/.vim/runtime/vim-ref-gtkdoc
set runtimepath+=~/.vim/runtime/vim-ref
let g:ref_gtkdoc_cmd='gtkdoc'
let g:ref_noenter=1

" }}}
" {{{ metarw (script_id = 2335)

set runtimepath+=~/.vim/runtime/vim-metarw

" }}}
" {{{ metarw-git (script_id = 2336)

set runtimepath+=~/.vim/runtime/metarw-git

" }}}
" {{{ git-branch-info (script_id = 2258)


set runtimepath+=~/.vim/runtime/vim-git-branch-info
let g:git_branch_status_head_current=1
let g:git_branch_status_text=''
let g:git_branch_status_nogit=''
let g:git_branch_status_around='[]'
let g:git_branch_status_ignore_remotes=1

" }}}
" {{{ surround.vim (script_id = 1697)

set runtimepath+=~/.vim/runtime/vim-surround

" }}}
" {{{ GNONEAlignArguments
" http://damien.lespiau.name/blog/2009/12/07/aligning-c-function-parameters-with-vim/
" http://git.lespiau.name/cgit/sk/plain/dotfiles/vim/plugin/GNOME-align-args.vim

noremap <Leader>g :GNOMEAlignArguments<CR>

" }}}
" {{{ unite.vim

set runtimepath+=~/.vim/runtime/unite.vim

" }}}
" {{{ javacomplete (script_id = 1785)

set runtimepath+=~/.vim/runtime/javacomplete
if has("autocmd")
	au Filetype java setlocal omnifunc=javacomplete#Complete
endif

" }}}

" Disabled Plugins: --------------------
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
" {{{ xp template

" set runtimepath+=~/.vim/runtime/xpt
" set runtimepath+=~/.vim/runtime/xpt_personal
" let g:xptemplate_brace_complete = ''
" let g:xptemplate_key = '<C-\>'

" }}}
" {{{ current-func-info.vim (script_id = 3197)

" set runtimepath+=~/.vim/runtime/current-func-info

" }}}
" {{{ vim-latex

" set runtimepath+=~/.vim/runtime/vim-latex/vimfiles
" let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*'
" let g:Tex_CompileRule_pdf = 'dvipdfmx'
" let g:Tex_ViewRule_dvi = 'evince'
" let g:Tex_ViewRule_pdf = 'evince'
" let g:tex_flavor = "latex"

" }}}

" vim: ts=2:sw=2:sts=0:fdm=marker:fmr={{{,}}}
