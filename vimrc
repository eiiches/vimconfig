"
" Maintainer: Eiichi Sato
"
" To use it, copy it to
"   for Unix and OS/2:  ~/.vimrc
"   for Amiga:  s:.vimrc
"   for MS-DOS and Win32:  $VIM\_vimrc
"   for OpenVMS:  sys$login:.vimrc

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
" {{{ reset augroup vimrc

augroup vimrc
	autocmd!
augroup END

" }}}
" {{{ .vimrc editing and reloading

" automatic reloading
if has("autocmd")
	autocmd vimrc BufWritePost .vimrc,~/.vim/vimrc source $MYVIMRC
endif

function! OpenVimrc(command)
	if empty(bufname("%")) && ! &modified && empty(&buftype)
		edit $MYVIMRC
	else
		execute a:command '$MYVIMRC'
	endif
endfunction
nnoremap <silent> <leader>v :call OpenVimrc('vsplit')<CR>
nnoremap <silent> <C-w><leader>v :call OpenVimrc('tabnew')<CR>

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

" define indentation around parentheses.
set cinoptions=(0,u0,U0
" do not indent before C++ scope declarations: public; protected; private;
set cinoptions+=g0
" do not indent function return type
set cinoptions+=t0

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
" {{{ folding

" default folding
set foldmethod=marker
set foldmarker={{{,}}}

function! MyFoldText()
	return foldtext() . '...'
endfunction
set foldtext=MyFoldText()
set fillchars-=fold:-

" analogue to the standard function foldclosed()
function! FoldOpened(lnum)
	" when fold is open or fold doesn't exist, -1
	if foldclosed(a:lnum) != -1 || foldlevel(a:lnum) <= 0
		return -1
	endif

	" save context
	let save_lz = &lazyredraw
	let &lazyredraw = 1
	let save_view = winsaveview()

	" close fold temporarily and find the first line of the fold
	normal! zc
	let result = foldclosed(a:lnum)
	normal! zo

	" restore context
	call winrestview(save_view)
	let &lazyredraw = save_lz

	return result
endfunction

" close the fold, if cursor is at the first column of the first line of a open fold.
" open the fold, if cursor is on a closed fold.
" otherwise, just move the cursor to the left
function! Map_h()
	let l:lnum = line('.')
	if foldlevel(l:lnum) > 0
		if col('.') == 1 && FoldOpened(l:lnum) == l:lnum
			normal! zc
			return
		elseif foldclosed(l:lnum) != -1 && ! ( col('.') == 1 && foldclosed(l:lnum) == l:lnum )
			normal! zo
			return
		endif
	endif
	normal! h
endfunction
nnoremap <silent> h :call Map_h()<CR>

" open fold if cursor is on the closed fold.
function! Map_l()
	let l:lnum = line('.')
	if foldlevel(l:lnum) > 0 && foldclosed(l:lnum) != -1
		normal! zo
		return
	endif
	normal! l
endfunction
nnoremap <silent> l :call Map_l()<CR>

" linewise text object for open folds.
vnoremap <silent> iz :normal! [zjV]zk<CR>
onoremap <silent> iz :normal Viz<CR>
vnoremap <silent> az :normal! [zV]z<CR>
onoremap <silent> az :normal Vaz<CR>

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

" statusline
set statusline=%f\ %y[%{&fileencoding},%{&fileformat}]%<%{fugitive#statusline()}%h%m%r%=%-14.(%l,%c%V%)\ %P

" list candidates in statusline for commandline completion
set wildmenu
set wildmode=longest,list
set wildignore=*~

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
" {{{ key mappings

" list and open buffer
nnoremap gb :ls<CR>:buf<Space>

" natural movement for wrapped lines
noremap j gj
noremap gj j
noremap k gk
noremap gk k

" left-right motion.
nnoremap 0 hg0
nnoremap g0 0
nnoremap $ lg$
nnoremap g$ $

" yank to end
nnoremap Y y$

" make <c-l> clear the highlight as well as redraw
nnoremap <silent> <C-L> :nohls<CR><C-L>

" reselect visual block after indent/unindent
vnoremap < <gv
vnoremap > >gv

" command line keymap
cnoremap <C-h> <Left>
cnoremap <C-l> <Right>
cnoremap <C-n> <Down>
cnoremap <C-p> <Up>

" move text linewise
" FIXME: <C-k> doesn't work when cursor is at the bottom or top of the buffer.
vnoremap <expr> <C-j> (mode() !=# 'V' ? 'V' : '') . 'dp`[V`]'
vnoremap <expr> <C-k> (mode() !=# 'V' ? 'V' : '') . 'dkP`[V`]'
nnoremap <C-j> ddp
nnoremap <C-k> ddkP

" toggle wrap
nnoremap <silent> mw :set wrap!<CR>

" toggle list
nnoremap <silent> ml :set list!<CR>

" }}}
" {{{ resize mode

function! PrintMode(mode)
	if &showmode
		echohl ModeMsg | echo a:mode | echohl None
		redraw
	endif
endfunction

function! ResizeMode()
	while 1
		call PrintMode('-- RESIZE --')
		try
			let key = nr2char(getchar())
			if index(['>', '<', '+', '-', '=', 'h', 'l', 'j', 'k'], key) < 0
				throw ''
			endif
			execute "normal! \<C-w>" . key
			redraw
		catch
			break
		endtry
	endwhile
	call PrintMode('')
endfunction

nnoremap <silent> <C-w>> <C-w>>:call ResizeMode()<CR>
nnoremap <silent> <C-w>< <C-w><:call ResizeMode()<CR>
nnoremap <silent> <C-w>- <C-w>-:call ResizeMode()<CR>
nnoremap <silent> <C-w>+ <C-w>+:call ResizeMode()<CR>

" reset window size on VimResized
au vimrc VimResized * execute "normal! \<C-w>="

" }}}
" {{{ miscellaneous

" do not wrap text by default.
set nowrap

" when wrap is on...
let &showbreak = '> '
set linebreak
set breakat&

" show line number
set number

" suppress error bells
set noerrorbells
set novisualbell

" lines before and after the current line when scrolling
set scrolloff=2

" show tab as >---
set listchars+=tab:>-

" split direction
set splitbelow
set splitright

" completion
set completeopt=menuone

" keep history
set history=500

" virtualedit in block mode
set virtualedit=block

" }}}
" {{{ make and grep

" redirect everything to stdout.
set shellpipe=&>

" shell commands for :make and :grep
set grepprg=grep\ -nH
set makeprg=make

" When b:make_after_write is 1, make target 'b:make_target'
" using first available Makefile listed in b:make_file
function! QuickMake()
	let makefiles = exists('b:make_file') ? b:make_file : 'Makefile'
	let target = exists('b:make_target') ? b:make_target : ''
	for makefile in split(makefiles, ',')
		if filereadable(glob(makefile))
			silent execute 'make -f' makefile target
			return
		endif
	endfor
	echohl ErrorMsg | echo 'Makefile not available.' | echohl None
endfunction
command! -nargs=0 QuickMake call QuickMake() | normal! <C-l>

" call _QuickMake() everytime buffer is written.
function! _QuickMake()
	if exists('b:make_after_write') && b:make_after_write
		call QuickMake()
	endif
endfunction
au vimrc BufWritePost * call _QuickMake()

" open quickfix automatically
au vimrc QuickFixCmdPost [^l]* nested cwindow
au vimrc QuickFixCmdPost l* nested lwindow

" }}}
" {{{ session autoload

" automatically restore session when vim is started without arguments.
autocmd vimrc VimEnter * if argc() == 0 | call RestoreSession() | endif

" }}}
" {{{ template

let g:template_dir = '~/.vim/templates'

function! LoadTemplate(...)
	let extension = a:0 ? a:1 : expand('%:e')
	let template_dir = expand(g:template_dir)
	let template = template_dir . '/template.' . extension
	if filereadable(template)
		" load template
		call append(0, readfile(template))
		silent normal! Gdd

		" set cursor at ${0}.
		call cursor(1, 0)
		if search('${0}', 'cW', line('$'))
			silent normal d4l
		else
			call cursor(line('$'), 0)
		endif
	endif
endfunction

function! EditTemplate(...)
	let extension = a:0 ? a:1 : expand('%:e')
	if empty(extension)
		echohl ErrorMsg | echo 'Cannot determine file extension.' | echohl
		return
	endif
	let template_dir = expand(g:template_dir)
	let template = template_dir . '/template.' . extension
	if filewritable(template) || !filereadable(template) && filewritable(template_dir) == 2
		execute 'vsplit' template
	else
		echohl ErrorMsg | echo 'Cannot open ' . template . ' for writing.' | echohl None
	endif
endfunction
command! -nargs=? EditTemplate call EditTemplate(<f-args>)

" }}}
" {{{ default viewers

let g:viewer_pdf = 'evince'
let g:viewer_html = 'firefox'

" }}}
" {{{ abbreviations

inoreabbrev lorem Lorem ipsum dolor sit amet, consectetur adipisicing elit,
			\ sed do eiusmod tempor incididunt ut labore et dolore magna
			\ aliqua. Ut enim ad minim veniam, quis nostrud exercitation
			\ ullamco laboris nisi ut aliquip ex ea commodo consequat.
			\ Duis aute irure dolor in reprehenderit in voluptate velit esse
			\ cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat
			\ cupidatat non proident, sunt in culpa qui officia deserunt
			\ mollit anim id est laborum.

" }}}
" {{{ changing directories

" default
let t:cwd = getcwd()

" per tab current directory
function! TabCD(dir)
	execute 'cd' fnameescape(expand(a:dir))
	let t:cwd = getcwd()
endfunction
command! -bar -complete=dir -nargs=? TabCD call TabCD(<q-args>)

" cd and CD expands to TabCD
command! -bar -complete=dir -nargs=? CD TabCD <args>
cnoreabbrev <expr> cd (getcmdtype() == ':' && getcmdline() ==# 'cd') ? 'CD' : 'cd'
command! -bar -complete=dir -nargs=? LCD TabCD <args>
cnoreabbrev <expr> lcd (getcmdtype() == ':' && getcmdline() ==# 'lcd') ? 'LCD' : 'lcd'

" cd when switing tabs
function! TabCDTabEnter()
	if !exists('t:cwd')
		let t:cwd = getcwd()
	endif
	execute 'cd' fnameescape(expand(t:cwd))
endfunction
autocmd vimrc TabEnter * call TabCDTabEnter()

" cdd expands to CD %:h
cnoreabbrev <expr> cdd (getcmdtype() == ':' && getcmdline() ==# 'cdd') ? 'CD %:h' : 'cdd'

" }}}

" FileTypes: ---------------------------
" {{{ XML

let g:xml_syntax_folding=1
augroup vimrc-xml
	au!
	au vimrc FileType xml setlocal foldmethod=syntax
augroup END

" }}}
" {{{ Python

augroup vimrc-python
	au!
	au BufNewFile *.py silent call LoadTemplate()
	au FileType python setlocal expandtab
	au FileType python setlocal tabstop=4
	au FileType python setlocal softtabstop=4
	au FileType python setlocal shiftwidth=4
	if version >= 703
		au FileType python setlocal colorcolumn=80
	endif
	let g:python_space_error_highlight = 1

	" highlight 'self'
	au FileType python syn keyword pythonBuiltin self
augroup END

" }}}
" {{{ C

augroup vimrc-c
	au!
	au FileType c,cpp setlocal commentstring=\ \/\*\ %s\ \*\/
	au FileType c,cpp setlocal list listchars+=precedes:<,extends:>
	au FileType c,cpp set foldcolumn=2
	au FileType c,cpp let g:c_space_errors = 1
	au FileType   cpp let g:c_no_curly_error = 1
augroup END

" gtk development
function! GtkDocOrMan()
	if exists('b:gtk_development_in_c') && b:gtk_development_in_c
		execute 'Ref gtkdoc' expand('<cword>')
	else
		execute 'Ref man' expand('<cword>')
	endif
endfunction
function! CheckGtkDevehelopmentInC()
	let b:gtk_development_in_c = 0
	for s:line in getline(0, line("$"))
		if s:line =~# '<glib.h>' || s:line =~# '<gtk/gtk.h>'
			let b:gtk_development_in_c = 1
			break
		endif
	endfor
	if b:gtk_development_in_c
		set path+=/usr/include/gtk-2.0
		set path+=/usr/include/glib-2.0
	endif
	nnoremap <buffer><silent> K :call GtkDocOrMan()<CR>
endfunction
au vimrc-c BufReadPost,BufWritePost *.c,*.h,*.cpp,*.hpp call CheckGtkDevehelopmentInC()

" }}}
" {{{ D

augroup vimrc-d
	au!
	au FileType d setlocal commentstring=\ \/\*\ %s\ \*\/
	au FileType d setlocal list listchars+=precedes:<,extends:>
augroup END

" }}}
" {{{ Vala

augroup vimrc-vala
	au!
	au BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
	au BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
	au BufRead *.vala set smartindent
	au BufRead *.vala set cindent
	au BufRead,BufNewFile *.vala setfiletype vala
	au BufRead,BufNewFile *.vapi setfiletype vala
augroup END

" }}}
" {{{ Brainfuck

augroup vimrc-brainfuck
	au!
	au BufRead,BufNewFile *.bf setfiletype brainfuck
augroup END

" }}}
" {{{ C#

augroup vimrc-csharp
	au!
	au FileType cs setlocal commentstring=\ \/\*\ %s\ \*\/
	au FileType cs setlocal efm=%f(%l,%c):\ error\ CS%n:\ %m
augroup END

" }}}
" {{{ Shell Script

augroup vimrc-shellscript
	au!
	au BufWritePost *.sh exe "silent !chmod +x %"
augroup END

" }}}
" {{{ Squirrel

augroup vimrc-squirrel
	au!
	au BufRead,BufNewFile *.nut setfiletype squirrel
augroup END

" }}}
" {{{ Vim

augroup vimrc-vim
	au!
	au FileType vim set foldcolumn=2
	au FileType vim nnoremap <buffer> K :vert help <C-R>=expand('<cword>')<CR><CR><C-w>p
augroup END

" }}}
" {{{ ActionScript

augroup vimrc-actionscript
	au!
	au BufRead,BufNewFile *.as set filetype=actionscript
	au FileType actionscript setlocal dictionary+=~/.vim/dict/actionscript/actionscript.dict
	au FileType actionscript set omnifunc=actionscriptcomplete#Complete
augroup END

" }}}
" {{{ Microsoft Office

augroup vimrc-msoffice
	au!
	au BufReadCmd *.pptx call zip#Browse(expand("<amatch>"))
	au BufReadCmd *.xlsx call zip#Browse(expand("<amatch>"))
	au BufReadCmd *.docx call zip#Browse(expand("<amatch>"))
augroup END

" }}}
" {{{ OpenGL Shader

augroup vimrc-shader
	au!
	au BufNewFile,BufRead *.frag,*.vert,*.glsl setf glsl
augroup END

" }}}
" {{{ LaTeX

augroup vimrc-tex
	au!
	au BufNewFile *.tex call LoadTemplate()
	au FileType plaintex set filetype=tex
	au FileType tex let b:make_file = 'Makefile,~/.vim/makerules/Makefile'
	au FileType tex let b:make_target = '%<.pdf'
	au FileType tex let b:make_after_write = 1
	au FileType tex setlocal errorformat=%f:%l:\ %m

	function! OpenPdf()
		let s:pdfpath = expand('%:p:r').'.pdf'
		if filereadable(s:pdfpath)
			call vimproc#system_bg(g:viewer_pdf.' '.s:pdfpath)
		else
			echohl ErrorMsg | echo 'File not found: ' . s:pdfpath | echohl None
		endif
	endfunction
	au FileType tex nnoremap <silent> <buffer> <Leader>r :call OpenPdf()<CR>

	" show math symbols using conceal feature
	if has("autocmd") && has("conceal")
		au FileType tex setlocal conceallevel=2
	endif
augroup END

" }}}
" {{{ Makefile

augroup vimrc-make
	au!
	au FileType make set noexpandtab
augroup END

" }}}
" {{{ HTML

augroup vimrc-html
	au!
	au FileType html nnoremap <silent><buffer> <Leader>r
				\ :call vimproc#system_bg(g:viewer_html.' file://'.expand('%:p'))<CR>
augroup END

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
" {{{ :Hex

command! Hex :%!xxd
command! Unhex :%!xxd -r

" }}}
" {{{ :Maps

command! -nargs=* -complete=mapping Maps map <args> | map! <args> | lmap <args>

" }}}
" {{{ :{Restore,Save}Session

function! RestoreSession()
	if filereadable('Session.vim')
		source Session.vim
	endif
endfunction
command! -nargs=0 RestoreSession call RestoreSession()

function! SaveSession()
	mksession!
endfunction
command! -nargs=0 SaveSession call SaveSession()

" :qq to save session and quit
command! -nargs=0 Qq call SaveSession() | qa
cnoreabbrev <expr> qq (getcmdtype() == ':' && getcmdline() ==# 'qq') ? 'Qq' : 'qq'

" }}}
" {{{ :UpdateHelp

function! UpdateHelp()
	for rundir in split(&rtp, ',')
		let l:docdir = rundir . '/doc'
		if isdirectory(l:docdir)
			echo l:docdir
			try
				execute 'helptags' l:docdir
			catch /^Vim\%((\a\+)\)\=:E152/
				continue
			endtry
		endif
	endfor
endfunction
command! -nargs=0 UpdateHelp call UpdateHelp()

" }}}
" {{{ :Bundle

function! Bundle(...)
	for bundle in a:000
		execute 'set runtimepath+=~/.vim/bundle/' . eval(bundle)
	endfor
endfunction
command! -nargs=* Bundle call Bundle(<f-args>)

" }}}
" {{{ :Chomp

command! -range=% -nargs=0 Chomp :<line1>,<line2>s/\s\+$//g

" FIXME: doesn't work when range is given.
cnoreabbrev <expr> chomp (getcmdtype() == ':' && getcmdline() ==# 'chomp') ?  'Chomp' : 'chomp'

" }}}

" Plugins: -----------------------------
" {{{ quickrun.vim

Bundle 'vim-quickrun'
nnoremap <silent> <Leader>r :QuickRun -mode n<CR>
vnoremap <silent> <Leader>r :QuickRun -mode v<CR>

" }}}
" {{{ surround.vim

Bundle 'vim-surround'

" }}}
" {{{ vimwiki

Bundle 'vimwiki'

" do not specify default wiki.
let g:vimwiki_list = [{}]

let g:vimwiki_folding = 1
let g:vimwiki_camel_case = 0

" }}}
" {{{ vim-ref

Bundle 'vim-ref'
let g:ref_noenter=1

" }}}
" {{{ vim-ref-gtk

Bundle 'vim-ref-gtkdoc'

" }}}
" {{{ metarw

Bundle 'vim-metarw'

" }}}
" {{{ metarw-git

Bundle 'metarw-git'

" }}}
" {{{ unite.vim

Bundle 'unite.vim'

" <ESC> to leave Unite mode
autocmd FileType unite nmap <buffer> <ESC> <Plug>(unite_exit)
autocmd FileType unite imap <buffer> jj <Plug>(unite_insert_leave)

" override mapping for :ls :buf
nnoremap gb :Unite -prompt=>>\  buffer<CR>

nnoremap gl :UniteWithBufferDir -prompt=>>\  -buffer-name=files file<CR>
nnoremap gL :UniteWithCurrentDir -prompt=>>\  -buffer-name=files file<CR>
nnoremap gr :Unite -prompt=>>\  -buffer-name=files file_mru directory_mru<CR>

if exists(':CD') == 2
	let g:unite_cd_command = 'CD'
endif

if exists(':LCD') == 2
	let g:unite_lcd_command = 'LCD'
endif

" }}}
" {{{ unite-outline

Bundle 'unite-outline'

nnoremap go :Unite outline<CR>

" }}}
" {{{ unite-history

Bundle 'unite-history'

nnoremap gh :Unite history/command<CR>

" }}}
" {{{ unite-help

Bundle 'unite-help'

command! -nargs=? -complete=help Help :Unite -prompt=>>\  -immediately -input=<args> help
cnoreabbrev <expr> help (getcmdtype() == ':' && getcmdline() ==# 'help') ? 'Help' : 'help'

" }}}
" {{{ neocomplcache

Bundle 'neocomplcache'
let g:neocomplcache_enable_at_startup = 1

" snippets
let g:neocomplcache_snippets_dir = '~/.vim/snippets'
imap <silent><C-l> <Plug>(neocomplcache_snippets_expand)

" }}}
" {{{ javacomplete

Bundle 'javacomplete'
augroup vimrc-javacomplete
	au!
	au Filetype java setlocal omnifunc=javacomplete#Complete
augroup END

" }}}
" {{{ omnicppcomplete

function! UpdateTags()
	for i in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
		execute 'setlocal tags+=' . neocomplcache#cache#encode_name('include_tags', i)
	endfor
	execute 'setlocal tags+=' . neocomplcache#cache#encode_name('tags_output', expand('%:p'))
endfunction

Bundle 'omnicppcomplete'
augroup vimrc-omnicppcomplete
	au!
	au FileType c,cpp call omni#cpp#complete#Init()
	au BufWritePost *.{cpp,c} call UpdateTags()
	au FileType c,cpp call UpdateTags()
augroup END

" show prototype in popup
let OmniCpp_ShowPrototypeInAbbr = 1

" complete after ::
let OmniCpp_MayCompleteScope = 1

" }}}
" {{{ vimproc

Bundle 'vimproc'

" }}}
" {{{ vimshell

Bundle 'vimshell'

augroup vimrc-vimshell
	au!

	" Ctrl-D to exit
	au FileType {vimshell,int-*} imap <buffer><silent> <C-d> <ESC>:q<CR>

	" Moving to other windows
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>h <ESC><C-w>h
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>j <ESC><C-w>j
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>k <ESC><C-w>k
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>l <ESC><C-w>l
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>H <ESC><C-w>Ha
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>J <ESC><C-w>Ja
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>K <ESC><C-w>Ka
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>L <ESC><C-w>La
	au FileType {vimshell,int-*} imap <buffer><silent> <C-w>= <ESC><C-w>=a

	" Disable cursor keys
	au FileType {vimshell,int-*} imap <buffer><silent> OA <Nop>
	au FileType {vimshell,int-*} imap <buffer><silent> OB <Nop>
	" au FileType {vimshell,int-*} imap <buffer><silent> OC <Nop>
	" au FileType {vimshell,int-*} imap <buffer><silent> OD <Nop>

	" Switch to insert mode on BufEnter
	au BufEnter *vimshell call vimshell#start_insert()
	au BufEnter iexe-* startinsert!

	" Orignal <C-w>
	au FileType {vimshell,int-*} inoremap <buffer><silent> <C-w><C-w> <C-w>
augroup END

" Aliases
au vimrc-vimshell FileType vimshell call vimshell#altercmd#define('sl', 'ls')
au vimrc-vimshell FileType vimshell call vimshell#altercmd#define('ll', 'ls -l')

" Python interpreter
au vimrc-vimshell FileType int-python set filetype=python

" Interactive Shell
function! OpenInteractiveShell()
	let default = ''
	if has_key(g:vimshell_interactive_interpreter_commands, &filetype)
		let default = g:vimshell_interactive_interpreter_commands[&filetype]
	endif
	let interp = input("Interpreter: ", default)
	try
		execute 'VimShellInteractive' interp
	catch
		echohl ErrorMsg
		echo empty(interp) ?
					\ ('No interpreter registered for filetype = "' .  &filetype . '"') :
					\ ('Failed to execute "' . interp . '"')
		echohl None
	endtry
endfunction
nnoremap <silent> gs :VimShellPop<CR>
nnoremap <silent> gS :call OpenInteractiveShell()<CR>

" }}}
" {{{ zencoding

Bundle 'zencoding-vim'

" }}}
" {{{ argtextobj.vim

Bundle 'argtextobj.vim'

" }}}
" {{{ drawit

Bundle 'drawit'

" }}}
" {{{ align

Bundle 'align'

" }}}
" {{{ localrc

Bundle 'localrc'

" }}}
" {{{ matchit

Bundle 'matchit'

" }}}
" {{{ matchit-python

Bundle 'matchit_python'

" }}}
" {{{ easymotion

Bundle 'easymotion'
let g:EasyMotion_leader_key = ','

" }}}
" {{{ vim-altr

Bundle 'vim-altr'
nmap ga <Plug>(altr-forward)
nmap gA <Plug>(altr-back)

call altr#define('vimrc', 'gvimrc', 'lvimrc')
call altr#define('.vimrc', '.gvimrc', '.vim/lvimrc')

" }}}
" {{{ tex.vim

Bundle 'tex.vim'

" }}}
" {{{ srcexpl.vim

Bundle 'srcexpl.vim'

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
" {{{ fugitive.vim

Bundle 'fugitive'
nnoremap ,git :Git<Space>
nnoremap <silent> ,log :silent Glog \| redraw!<CR>
nnoremap <silent> ,st :silent Gstatus<CR>
nnoremap <silent> ,diff :Gdiff<CR>
nnoremap <silent> ,commit :Gcommit<CR>
nnoremap <silent> ,orig :Gvsplit<CR>
nnoremap <silent> ,cached :Git diff --cached<CR>

" }}}
" {{{ GNONEAlignArguments
" http://damien.lespiau.name/blog/2009/12/07/aligning-c-function-parameters-with-vim/
" http://git.lespiau.name/cgit/sk/plain/dotfiles/vim/plugin/GNOME-align-args.vim

noremap <Leader>g :GNOMEAlignArguments<CR>

" }}}
" {{{  vim-css-color

Bundle 'vim-css-color/after'

" }}}
" {{{ errormarker.vim

Bundle 'errormarker'

" }}}

" Local: -------------------------------
" {{{ source ~/.vim/lvimrc

let g:local_vimrc = expand('~/.vim/lvimrc')
if filereadable(g:local_vimrc)
	execute 'source' g:local_vimrc
endif

" }}}

" vim: ts=4:sw=4:sts=0:fdm=marker:fmr={{{,}}}
