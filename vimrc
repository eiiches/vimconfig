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
	autocmd vimrc BufWritePost .vimrc,~/.vim/vimrc,~/.vim/vimrc.local
				\  source $MYVIMRC
				\| if has('gui_running')
				\|     source $MYGVIMRC
				\| endif
endif

function! s:open_vimrc(command, vimrc)
	if empty(bufname("%")) && ! &modified && empty(&buftype)
		execute 'edit' a:vimrc
	else
		execute a:command a:vimrc
	endif
endfunction
nnoremap <silent> <leader>v :call <sid>open_vimrc('vsplit', $MYVIMRC)<CR>
nnoremap <silent> <C-w><leader>v :call <sid>open_vimrc('tabnew', $MYVIMRC)<CR>

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
" do not indent inside namespace
set cinoptions+=N-s

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

" Analogue to the standard function foldclosed()
" s:foldopened({lnum})
" The result is a Number.  If the line {lnum} is in a open
" fold, the result is the number of the first line in that fold.
" If the line {lnum} is not in a open fold, -1 is returned.
function! s:foldopened(lnum)
	" when fold is closed or fold doesn't exist, -1
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

" Analogue to the standard function foldclosedend()
" s:foldopenedend({lnum})
" The result is a Number.  If the line {lnum} is in a open
" fold, the result is the number of the last line in that fold.
" If the line {lnum} is not in a open fold, -1 is returned.
function! s:foldopenedend(lnum)
	" when fold is closed or fold doesn't exist, -1
	if foldclosedend(a:lnum) != -1 || foldlevel(a:lnum) <= 0
		return -1
	endif

	" save context
	let save_lz = &lazyredraw
	let &lazyredraw = 1
	let save_view = winsaveview()

	" close fold temporarily and find the first line of the fold
	normal! zc
	let result = foldclosedend(a:lnum)
	normal! zo

	" restore context
	call winrestview(save_view)
	let &lazyredraw = save_lz

	return result
endfunction

" close the fold, if cursor is at the first column of the first or the last line of a open fold.
" open the fold, if cursor is on a closed fold.
" otherwise, just move the cursor to the left
function! Map_h()
	let l:lnum = line('.')
	if foldlevel(l:lnum) > 0
		if col('.') == 1 && (s:foldopened(l:lnum) == l:lnum || s:foldopenedend(l:lnum) == l:lnum)
			normal! zc
			return
		elseif foldclosed(l:lnum) != -1 && ! ( col('.') == 1 && (foldclosed(l:lnum) == l:lnum || foldclosedend(l:lnum) == l:lnum))
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

" show incomplete commands
set showcmd

" list candidates in statusline for commandline completion
set wildmenu
set wildmode=longest,list
set wildignore=*~

" hide mode in command line
set noshowmode

" always show statusline
set laststatus=2

function! s:update_statusline(new_stl, type, current) " {{{
	" Inspired by StatusLineHighlight by Ingo Karkat

	let current = (a:current ? "" : "NC")
	let type = a:type
	let new_stl = a:new_stl

	" Prepare current buffer specific text
	" Syntax: <CUR> ... </CUR>
	let new_stl = substitute(new_stl, '<CUR>\(.\{-,}\)</CUR>', (a:current ? '\1' : ''), 'g')

	" Prepare statusline colors
	" Syntax: #[ ... ]
	let new_stl = substitute(new_stl, '#\[\(\w\+\)\]', '%#StatusLine'.type.'\1'.current.'#', 'g')

	if &l:statusline ==# new_stl
		" Statusline already set, nothing to do
		return
	endif

	if empty(&l:statusline)
		" No statusline is set, use my_stl
		let &l:statusline = new_stl
	else
		" Check if a custom statusline is set
		let plain_stl = substitute(&l:statusline, '%#StatusLine\w\+#', '', 'g')

		if &l:statusline ==# plain_stl
			" A custom statusline is set, don't modify
			return
		endif

		" No custom statusline is set, use my_stl
		let &l:statusline = new_stl
	endif
endfunction " }}}
function! s:update_statusline_colors(colors) " {{{
	for type in keys(a:colors)
		for name in keys(a:colors[type])
			let colors = {'c': a:colors[type][name][0], 'nc': a:colors[type][name][1]}
			let type = (type == 'NONE' ? '' : type)
			let name = (name == 'NONE' ? '' : name)

			if exists("colors['c'][0]")
				exec 'hi StatusLine'.type.name.' ctermbg='.colors['c'][0].' ctermfg='.colors['c'][1].' cterm='.colors['c'][2]
			endif

			if exists("colors['nc'][0]")
				exec 'hi StatusLine'.type.name.'NC ctermbg='.colors['nc'][0].' ctermfg='.colors['nc'][1].' cterm='.colors['nc'][2]
			endif
		endfor
	endfor
endfunction " }}}
" {{{ let s:statuscolors = {
let s:statuscolors = {
	\   'NONE': {
		\   'NONE'         : [[ 236, 231, 'bold'], [ 232, 244, 'none']]
	\ }
	\ , 'Normal': {
		\   'Mode'         : [[ 214, 235, 'bold'], [                 ]]
		\ , 'FileName'     : [[ 240, 231, 'bold'], [ 234, 244, 'none']]
		\ , 'ModFlag'      : [[ 240,   9, 'bold'], [ 234, 239, 'none']]
		\ , 'BufFlag'      : [[ 236, 250, 'none'], [ 233, 239, 'none']]
		\ , 'Blank'        : [[ 236, 247, 'none'], [ 233, 239, 'none']]
		\ , 'Branch'       : [[ 236, 250, 'none'], [ 233, 239, 'none']]
		\ , 'FileFormat'   : [[ 236, 250, 'none'], [ 233, 239, 'none']]
		\ , 'FileEncoding' : [[ 236, 250, 'none'], [ 233, 239, 'none']]
		\ , 'FileType'     : [[ 236, 250, 'none'], [ 233, 239, 'none']]
		\ , 'LinePercent'  : [[ 240, 250, 'none'], [ 234, 239, 'none']]
		\ , 'LineNumber'   : [[ 252, 236, 'bold'], [ 235, 244, 'none']]
		\ , 'LineColumn'   : [[ 252, 240, 'none'], [ 235, 239, 'none']]
	\ }
	\ , 'Insert': {
		\   'Mode'         : [[ 31,  231, 'bold'], [                 ]]
		\ , 'FileName'     : [[ 240, 231, 'bold'], [                 ]]
		\ , 'ModFlag'      : [[ 240,   9, 'bold'], [                 ]]
		\ , 'BufFlag'      : [[ 236, 250, 'none'], [                 ]]
		\ , 'Blank'        : [[ 236, 247, 'none'], [                 ]]
		\ , 'Branch'       : [[ 236, 250, 'none'], [                 ]]
		\ , 'FileFormat'   : [[ 236, 250, 'none'], [                 ]]
		\ , 'FileEncoding' : [[ 236, 250, 'none'], [                 ]]
		\ , 'FileType'     : [[ 236, 250, 'none'], [                 ]]
		\ , 'LinePercent'  : [[ 240, 250, 'none'], [                 ]]
		\ , 'LineNumber'   : [[ 252, 236, 'bold'], [                 ]]
		\ , 'LineColumn'   : [[ 252, 240, 'none'], [                 ]]
	\ }
\ }
" }}}

let g:default_stl  = ""
let g:default_stl .= "<CUR>#[Mode] %{&paste ? 'PASTE ' : ''}%{substitute(strtrans(mode()), '', '', 'g')} </CUR>"
let g:default_stl .= "#[FileName] %f " " File name
let g:default_stl .= "#[ModFlag]%{&readonly ? '[RO] ' : ''}" " RO flag
let g:default_stl .= "#[ModFlag]%{&modifiable && &modified ? '[+] ' : ''}" " Modified flag
let g:default_stl .= "#[Blank]" " Padding/HL group
let g:default_stl .= " %{cfi#format(\"[%s()]\", \"\")}"
let g:default_stl .= "%<" " Truncate right
let g:default_stl .= "%=" " Right align
let g:default_stl .= "#[BufFlag]%{&previewwindow ? '[Preview] ' : ''}" " PRV flags
let g:default_stl .= "#[Branch]%{strlen(fugitive#statusline()) ? fugitive#statusline().' ' : '' }"
let g:default_stl .= "#[FileEncoding][%{(&fenc == '' ? &enc : &fenc)}," " File encoding
let g:default_stl .= "#[FileFormat]%{&fileformat}] " " File format
let g:default_stl .= "#[FileType]%{strlen(&ft) ? '['.&ft.'] ' : ''}" " File type
let g:default_stl .= "#[LinePercent] %p%% " " Line/column/virtual column, Line percentage
let g:default_stl .= "#[LineNumber] %l#[LineColumn]:%c-%v " " Line/column/virtual column, Line percentage

augroup vimrc-statusline
	au!
	au ColorScheme * call <sid>update_statusline_colors(s:statuscolors)
	au BufEnter,BufWinEnter,WinEnter,CmdwinEnter,CursorHold,BufWritePost,InsertLeave * call <sid>update_statusline((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 1)
	au BufLeave,BufWinLeave,WinLeave,CmdwinLeave * call <sid>update_statusline((exists('b:stl') ? b:stl : g:default_stl), 'Normal', 0)
	au InsertEnter,CursorHoldI * call <sid>update_statusline((exists('b:stl') ? b:stl : g:default_stl), 'Insert', 1)
augroup END
call s:update_statusline_colors(s:statuscolors)

" update statusline immediately after entering normal mode.
if has('unix') && !has('gui_running')
	inoremap <silent> <ESC> <ESC>
	inoremap <silent> <C-[> <ESC>
endif

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
" {{{ functions

function! s:quote(str)
	return '"'. a:str . '"'
endfunction
function! s:expandcmddyn(orig, repl)
	execute "cnoreabbrev <expr>" a:orig
				\ "(getcmdtype() == ':' && getcmdline() ==# " s:quote(a:orig) ")"
				\ "?" a:repl
				\ ":" s:quote(a:orig)
endfunction
function! s:expandcmd(orig, repl)
	call s:expandcmddyn(a:orig, s:quote(a:repl))
endfunction

function! WrapTextRange(line1, line2, list1, list2)
	for text in reverse(a:list2)
		call append(a:line2, text)
	endfor
	for text in reverse(a:list1)
		call append(a:line1, text)
	endfor
endfunction

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

" toggle wrap
nnoremap <silent> mw :set wrap!<CR>

" toggle list
nnoremap <silent> ml :set list!<CR>

" clipboard
nnoremap ,pa "+p
vnoremap ,co "+y
vnoremap ,cu "+d

" define text objects like in( or an}
function! s:define_text_objects()
	for mode in ['i', 'a']
		for type in ['(', ')', '{', '}', '[', ']', '<', '>', "'", '"']
			execute 'onoremap <expr>' mode.'n'.type '"\<ESC>f'.type.'".v:operator."'.mode.type.'"'
			execute 'vnoremap <expr>' mode.'n'.type '"\<ESC>f'.type.'v'.mode.type.'"'
		endfor
	endfor
endfunction
call s:define_text_objects()

" disable command-line window
nnoremap q: :q

" delete word
inoremap <C-b> <C-w>

" }}}
" {{{ wincmd

let s:wincmd_keys = ['h', 'j', 'k', 'l', 'w', 'p']
let s:wincmd_keys_keep_insert = ['H', 'J', 'K', 'L', '=', '>', '<', '+', '-']

" <C-w> in insert mode.
function! s:define_wincmds()
	for cmd in s:wincmd_keys
		execute 'inoremap <silent>' '<C-w>'.cmd '<ESC>:wincmd '.cmd.'<CR>'
	endfor
	for cmd in s:wincmd_keys_keep_insert
		execute 'inoremap <silent>' '<C-w>'.cmd '<C-o>:wincmd '.cmd.'<CR>'
	endfor
endfunction
call s:define_wincmds()

" wincmd mode
function! s:echomode(...)
	if ! &showmode
		return
	endif

	let mode = ''
	if a:0 > 0
		let mode = '-- '.a:000[0].' --'
	endif

	echohl ModeMsg | echo mode | echohl None
	redraw
endfunction

function! s:wincmdmode()
	while 1
		call s:echomode('RESIZE')
		let key = nr2char(getchar())
		if index(s:wincmd_keys, key) < 0 &&
					\ index(s:wincmd_keys_keep_insert, key) < 0
			break
		endif
		execute 'wincmd' key
		redraw
	endwhile
	call s:echomode()
endfunction

let s:wincmd_mode_trigger_keys = ['>', '<', '+', '-']
function! s:define_wincmd_mode_triggers()
	for cmd in s:wincmd_mode_trigger_keys
		execute 'nnoremap <silent>' '<C-w>'.cmd '<C-w>'.cmd.':call <sid>wincmdmode()<CR>'
	endfor
endfunction
call s:define_wincmd_mode_triggers()

" reset window size on VimResized
function! s:on_resized()
	let tab = tabpagenr()
	tabdo wincmd =
	execute 'normal!' tab.'gt'
endfunction
au vimrc VimResized * call <sid>on_resized()

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

" try to keep current column
set nostartofline

function! s:ibusdisable()
if has('python')
python << EOF
try:
	import ibus
	bus = ibus.Bus()
	ic = ibus.InputContext(bus, bus.current_input_contxt())
	ic.disable()
except: pass
EOF
endif
endfunction
autocmd vimrc InsertLeave * call <sid>ibusdisable()

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
call s:expandcmd('cd', 'CD')

command! -bar -complete=dir -nargs=? LCD TabCD <args>
call s:expandcmd('lcd', 'LCD')

" cd when switing tabs
function! TabCDTabEnter()
	if !exists('t:cwd')
		let t:cwd = getcwd()
	endif
	execute 'cd' fnameescape(expand(t:cwd))
endfunction
function! TabCDWinEnter()
	call TabCDTabEnter()
endfunction
autocmd vimrc TabEnter * call TabCDTabEnter()
autocmd vimrc WinEnter * call TabCDWinEnter()

" cdd expands to CD %:p:h
call s:expandcmddyn('cdd', "'CD '.(empty(expand('%:p:h'))?getcwd():expand('%:p:h'))")

" }}}
" {{{ syntax

" show synstack for debugging colorscheme
let g:synstack_enabled = 0
function! s:toggle_synstack()
	let g:synstack_enabled = ! g:synstack_enabled
	augroup vimrc-synstack
		au!
		if g:synstack_enabled
			au CursorMoved * echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
		else
			echo
		endif
	augroup END
endfunction
nnoremap <silent> ,syn :<C-u>call <sid>toggle_synstack()<CR>

" }}}
" {{{ suspend

let g:session_dir_suspend = '/tmp'
function! s:suspend()
	let pid = getpid()
	let timestamp = localtime()
	execute 'mksession!' g:session_dir_suspend . '/vim-session-'.pid.'-'.timestamp.'.vim'
	suspend
endfunction
noremap <silent> <C-z> :call <sid>suspend()<CR>

" }}}
" {{{ tabline

function! s:get_tabpage_label(n)
	let bufnrs = tabpagebuflist(a:n)
	let hi = a:n is tabpagenr() ? '%#TabLineSel#' : '%#TabLine#'

	let no = len(bufnrs)
	if no is 1
		let no = ''
	endif

	let mod = len(filter(copy(bufnrs), 'getbufvar(v:val, "&modified")')) ? '+' : ''
	let sp = (no . mod) ==# '' ? '' : ' '
	let curbufnr = bufnrs[tabpagewinnr(a:n) - 1]
	let fname = fnamemodify(bufname(curbufnr), ':t')
	if empty(fname)
		let fname = '[No Name]'
	endif

	let label = no . mod . sp . fname

	return '%' . a:n . 'T' . hi . ' ' . label . ' %T%#TabLineFill#'
endfunction

function! MyTabline()
	let titles = map(range(1, tabpagenr('$')), 's:get_tabpage_label(v:val)')
	let separator = ''
	let tabpages = join(titles, separator) . separator . '%#TabLineFill#%T'
	let info = '%#TabLineSel# ' . fnamemodify(getcwd(), ":~") . ' '
	return tabpages . '%=' . info
endfunction
set tabline=%!MyTabline()
set showtabline=2

" }}}
" {{{ langauge

language en_US.utf-8

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

	" indent guide
	au FileType python syn match pythonIndent /\%(\_^\s*\)\@<=\%(\%1v\|\%5v\|\%9v\|\%13v\)\s/
	au FileType python hi link pythonIndent CursorColumn
augroup END

" }}}
" {{{ C/C++

function! IncludeGuard(macro)
	call WrapTextRange(0, line('$'),
				\ ['#ifndef '.a:macro, '#define '.a:macro],
				\ ['#endif /* '.a:macro.' */'])
endfunction

function! Namespace(line1, line2, identifier)
	call WrapTextRange(a:line1-1, a:line2,
				\ ['', 'namespace '.a:identifier.' {'],
				\ ['} /* namespace '.a:identifier.' */', ''])
endfunction
command! -range -nargs=1 Namespace call Namespace(<line1>, <line2>, <f-args>)
call s:expandcmd('namespace', 'Namespace')

function! ExternC(line1, line2)
	call WrapTextRange(a:line1-1, a:line2,
				\ ['#ifdef __cplusplus', 'extern "C" {', '#endif'],
				\ ['#ifdef __cplusplus', '}', '#endif'])
endfunction
command! -range ExternC call ExternC(<line1>, <line2>)
call s:expandcmd('externc', 'ExternC')


augroup vimrc-c
	au!
	au FileType c,cpp setlocal commentstring=\ \/\*\ %s\ \*\/
	au FileType c,cpp setlocal list listchars+=precedes:<,extends:>
	au FileType c,cpp set foldcolumn=2
	au FileType c,cpp let g:c_space_errors = 1
	au FileType   cpp let g:c_no_curly_error = 1
	au BufNewFile *.{h,hpp} call IncludeGuard("_" . substitute(toupper(expand("%:t")), "[\\.-]", "_", "g") . "_")
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
	au BufRead *.vala,*.vapi setlocal efm& efm+=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
	au BufRead *.vala,*.vapi setlocal smartindent
	au BufRead *.vala,*.vapi setlocal cindent
	au BufRead,BufNewFile *.vala,*.vapi setfiletype vala
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
	au FileType vim nnoremap <buffer><silent> K :vert help <C-R>=expand('<cword>')<CR> <bar> wincmd p<CR>
	au FileType vim set formatoptions-=t
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
" {{{ Javascript / JSON

augroup vimrc-javascript
	autocmd!
	autocmd BufNewFile,BufRead *.json setfiletype javascript
augroup END

" }}}
" {{{ markdown

function! s:preview_markdown(path)
	call vimproc#system('markdown '.a:path.' > '.a:path.'.html')
	call vimproc#system_bg(g:viewer_html.' file://'.a:path.'.html')
endfunction

augroup vimrc-markdown
	au!
	au BufRead,BufNewFile *.md set filetype=markdown
	au FileType markdown nnoremap <silent><buffer> <Leader>r
				\ :call <sid>preview_markdown(expand('%:p'))<CR>
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

command! Hex set binary | edit | execute ':%!xxd' | set ft=xxd
command! Unhex %!xxd -r

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
call s:expandcmd('qq', 'Qq')

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
call s:expandcmd('chomp', 'Chomp')

" }}}
" {{{ :Ronbun

command! -range=% -nargs=0 Ronbun :<line1>,<line2>Subvert/{、,。}/{，,．}/g
call s:expandcmd('ronbun', 'Ronbun')

" }}}
" {{{ :Mktag

command! -nargs=0 Mktag silent exe '!ctags -R .' | normal! <C-l>
call s:expandcmd('mktag', 'Mktag')
call s:expandcmd('mkt', 'Mktag')

" }}}

" Plugins: -----------------------------
" {{{ quickrun.vim

Bundle 'vim-quickrun'
nnoremap <silent> <Leader>r :QuickRun -mode n<CR>
vnoremap <silent> <Leader>r :QuickRun -mode v<CR>

let g:quickrun_config = {}
let g:quickrun_config['cpp'] = {
			\ 'type': 'cpp',
			\ 'cmdopt': '-std=c++0x'
			\ }

let g:quickrun_config['postscr'] = {
			\ 'type': 'postscr',
			\ 'command': 'gs',
			\ }

" }}}
" {{{ repeat.vim

Bundle 'vim-repeat'

" }}}
" {{{ surround.vim

Bundle 'vim-surround'

" }}}
" {{{ vim-abolish

Bundle 'vim-abolish'

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
let g:ref_source_webdict_sites = {
			\ 'alc': {
			\	'url': 'http://eow.alc.co.jp/search?q=%s',
			\	'keyword_encoding': 'utf-8',
			\	'cache': 1,
			\ },
			\ 'wikipedia:ja': 'http://ja.wikipedia.org/wiki/%s',
			\ 'wikipedia:en': 'http://en.wikipedia.org/wiki/%s',
			\ }

let g:ref_source_webdict_sites.default = 'wikipedia:ja'
function! g:ref_source_webdict_sites.alc.filter(output)
	return join(split(a:output, "\n")[32:], "\n")
endfunction

command! -nargs=1 Alc Ref webdict alc <args>
call s:expandcmd('alc', 'Alc')

let g:ref_open = 'vsplit'

" }}}
" {{{ vim-ref-gtk

Bundle 'vim-ref-gtkdoc'

" }}}
" {{{ vim-ref-info

Bundle 'vim-ref-info'

" }}}
" {{{ metarw

Bundle 'vim-metarw'

" }}}
" {{{ metarw-git

Bundle 'metarw-git'

" }}}
" {{{ current-func-info.vim

Bundle 'current-func-info'

" }}}
" {{{ unite.vim

Bundle 'unite.vim'

" <ESC> to leave Unite mode
autocmd vimrc FileType unite nmap <buffer> <ESC> <Plug>(unite_exit)
autocmd vimrc FileType unite imap <buffer> jj <Plug>(unite_insert_leave)

" Unite action mapping
autocmd vimrc FileType unite nnoremap <buffer><expr> sp unite#do_action('split')
autocmd vimrc FileType unite nnoremap <buffer><expr> vsp unite#do_action('vsplit')
autocmd vimrc FileType unite nnoremap <buffer><expr> tab unite#do_action('tabopen')

" NOTE: overriding the mapping for 'gb', which was :ls :buf
nnoremap gb :UniteWithBufferDir -buffer-name=files buffer file_mru file<CR>
nnoremap gc :UniteWithCurrentDir -buffer-name=files buffer file_mru file<CR>
nnoremap gl :Unite -buffer-name=files buffer file_mru file<CR>

" resume
nnoremap gn :UniteResume<CR>

" config
let g:unite_source_file_mru_limit = 200
let g:unite_kind_openable_cd_command = 'CD'
let g:unite_kind_openable_lcd_command = 'LCD'
let g:unite_source_file_mru_filename_format = ''

" unite-grep
function! s:unite_grep_interactive(target)
	let pattern = input('Pattern: ')
	if empty(pattern)
		" try to use the current search
		let pattern = substitute(@/,'\\', '\\\\', 'g')
	else
		" set as current search (if not empty)
		let @/ = pattern
	endif
	let command = 'Unite -buffer-name=search grep:'.a:target.'::'.pattern
	execute command
	echo ':'.command
endfunction
nnoremap <silent> g/ :call <sid>unite_grep_interactive('%')<CR>
nnoremap <silent> g? :call <sid>unite_grep_interactive('')<CR>

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

nnoremap gH :<C-u>Unite -start-insert help<CR>

" }}}
" {{{ unite-colorscheme

Bundle 'unite-colorscheme'

" }}}
" {{{ unite-tselect

Bundle 'unite-tselect'
nnoremap g<C-]> :<C-u>Unite -immediately tselect:<C-r>=expand('<cword>')<CR><CR>
nnoremap g] :<C-u>Unite -auto-preview tselect:<C-r>=expand('<cword>')<CR><CR>

" }}}
" {{{ neocomplcache

Bundle 'neocomplcache'
let g:neocomplcache_enable_at_startup = 1

" snippets
let g:neocomplcache_snippets_dir = '~/.vim/snippets'
imap <silent><C-l> <Plug>(neocomplcache_snippets_expand)
imap <C-s>  <Plug>(neocomplcache_start_unite_snippet)

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
" {{{ neocomplcache-snippets

Bundle 'neocomplcache-snippets-complete'

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

	" Disable cursor keys
	au FileType {vimshell,int-*} imap <buffer><silent> OA <Nop>
	au FileType {vimshell,int-*} imap <buffer><silent> OB <Nop>
	" au FileType {vimshell,int-*} imap <buffer><silent> OC <Nop>
	" au FileType {vimshell,int-*} imap <buffer><silent> OD <Nop>

	" Switch to insert mode on BufEnter
	au BufEnter *vimshell* call vimshell#start_insert()
	au BufEnter iexe-*,texe-* startinsert!
augroup END

" Interactive
function! s:open_vimshellinteractive()
	let default = ''
	if has_key(g:vimshell_interactive_interpreter_commands, &filetype)
		let default = g:vimshell_interactive_interpreter_commands[&filetype]
	endif
	let interp = input("Interpreter: ", default)
	execute 'VimShellInteractive' interp
endfunction
nnoremap <silent> gsi :call <sid>open_vimshellinteractive()<CR>

" Terminal
function! s:open_vimshellterminal()
	let shell = input("Interpreter: ")
	execute 'VimShellTerminal' shell
endfunction
nnoremap <silent> gst :call <sid>open_vimshellterminal()<CR>

" Shell
nnoremap <silent> gsh :VimShellPop <C-R>=expand('%:h:p')<CR><CR>
au vimrc-vimshell FileType vimshell call vimshell#altercmd#define('sl', 'ls')
au vimrc-vimshell FileType vimshell call vimshell#altercmd#define('ll', 'ls -l')

" Python
nnoremap <silent> gspy :VimShellTerminal ipython -colors NoColor<CR>
hi termipythonPrompt ctermfg=40
hi termipythonOutput ctermfg=9

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
" {{{ alignta

Bundle 'vim-alignta'

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

call altr#define('vimrc', 'gvimrc', 'lvimrc', 'lgvimrc')
call altr#define('.vimrc', '.gvimrc', '.vim/lvimrc', '.vim/lgvimrc')
call altr#define('%.cpp', '%.hpp', '%.c', '%.h')

" rule for django
" call altr#define('%/views.py', '%/models.py', '%/urls.py', '%/admin.py', '%/tests.py', '%/settings.py')
call altr#define('views.py', 'models.py', 'urls.py', 'admin.py', 'tests.py', 'settings.py')

" rule for autotools
call altr#define('Makefile.am', 'configure.ac')

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
" {{{ vim-colored-colorscheme

Bundle 'vim-colored-colorscheme/after'

" }}}
" {{{ rainbowbrackets

Bundle 'rainbowbrackets'

let g:rainbowbrackets_colors =
			\ [
			\   'ctermfg=9',
			\   'ctermfg=10',
			\   'ctermfg=33',
			\   'ctermfg=190'
			\ ]
let g:rainbowbrackets_enable_round_brackets = 1
let g:rainbowbrackets_enable_curly_brackets = 0
let g:rainbowbrackets_enable_square_brackets = 0

augroup vimrc-rainbowbrackets
	autocmd!
	autocmd FileType javascript let b:rainbowbrackets_enable_curly_brackets = 1
augroup END

" }}}
" {{{ colorconvert.vim

Bundle 'colorconvert.vim'

let g:colorconvert_profile = 'GnomeTerminal.Tango'

" }}}
" {{{ vimfiler

Bundle 'vimfiler'
let g:vimfiler_as_default_explorer = 1

" }}}

" Local: -------------------------------
" {{{ source ~/.vim/vimrc.local

let g:local_vimrc = expand('~/.vim/vimrc.local')
if filereadable(g:local_vimrc)
	execute 'source' g:local_vimrc
endif

" }}}

" Post: --------------------------------
" {{{ vimrcPost event

autocmd vimrc User vimrcPost silent
doautocmd vimrc User vimrcPost

" }}}

" vim: ts=4:sw=4:sts=0:fdm=marker:fmr={{{,}}}
