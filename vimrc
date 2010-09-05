"
" .vimrc by Eiichi Sato
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

" Use Vim settings, rather then Vi settings (much better!).
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

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif

" }}}

" --- general settings --------------------------------------------------- {{{

set directory=~/.vim/swp
set tabstop=2

nmap gb :ls<CR>:buf 

map j gj
map k gk

set incsearch		" do incremental searching

set nowrap
set ruler		" show the cursor position all the time

set history=500 "overwrite the default above
set noerrorbells "do not ring error bells
set number
set showcmd		" display incomplete commands
set showmode
"delek slate delek zell wombat rdark
colorscheme xoria256
set iminsert=0
set imsearch=0
inoremap <ESC> <ESC>:set iminsert=0<CR>:echo<CR>
set showmatch			" showmatch: Show the matching bracket for the last ')'?

set ignorecase			" ignore case
set smartcase			" but don't ignore it, when search string contains uppercase letters

set shiftwidth=2

set laststatus=2 "always show statusline

set shellslash
set grepprg=grep\ -nH\ $* 
let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*' 
"let g:Tex_ViewRule_dvi = 'xdvik-ja'
let g:tex_flavor = "latex"

"set cindent
"set autoindent
set scrolloff=2 		" 2 lines bevore and after the current line when scrolling
"set completeopt=menu,longest,preview
set completeopt=menuone

set encoding=utf8
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp

set makeprg=make

set wildmenu "list candidates in statusline for commandline completion

" for vim7.3
if version >= 703
	set undofile
	set undodir=/tmp
	set cryptmethod=blowfish
endif

"}}}


"make <c-l> clear the highlight as well as redraw
nnoremap <C-L> :nohls<CR><C-L>
inoremap <C-L> <C-O>:nohls<CR>
 

" --- gvim settings ------------------------------------------------------ {{{

set guifont=Bitstream\ Vera\ Sans\ Mono\ 7
set guioptions-=T "remove tool bar
set guioptions-=m "remove gui menu
set guioptions-=e "remove GUI tab bar
set guioptions-=r "remove right-scrollbar
set guioptions-=L "remove left-scrollbar

" }}}

" --- filetype settings -------------------------------------------------- {{{

" for xml
let g:xml_syntax_folding=1
au FileType xml setlocal foldmethod=syntax

" for c
au FileType c,cpp setlocal dict=~/.vim/dict/c/*.dict
au FileType c,cpp setlocal foldmethod=marker
au FileType c,cpp setlocal foldmarker={{{,}}}
au FileType c,cpp setlocal commentstring=\ \/\*\ %s\ \*\/

au FileType c,cpp setlocal list listchars=tab:>-,precedes:<,extends:>
au FileType c,cpp highlight SpecialKey ctermfg=240
let g:c_space_errors = 1

" for vala
au BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
au BufRead *.vala set smartindent
au BufRead *.vala set cindent
au BufRead,BufNewFile *.vala setfiletype vala
au BufRead,BufNewFile *.vapi setfiletype vala

" for C# 
au FileType cs set foldmethod=marker
au FileType cs set foldmarker={,}
au FileType cs set foldtext=substitute(getline(v:foldstart),'{.*','{...}',)
au FileType cs set foldlevelstart=2  

" for shell scripts
au BufWritePost *.sh exe "silent !chmod +x %"

" for squirrel
au! BufRead,BufNewFile *.nut setfiletype squirrel

" for vim
au FileType vim set foldmethod=marker

" }}}

" --- functions ---------------------------------------------------------- {{{

" extended mode line
au BufReadPost * call VimModelineExec()
function VimModelineExec()
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

" write with root permission
function WriteSudo(...)
	if a:0 > 0
		exec "write !sudo tee ".a:1." > /dev/null"
		exec "file ".a:1
		set nomodified
	else
		write !sudo tee % > /dev/null
	endif
endfunction
command -nargs=? -complete=file WriteSudo call WriteSudo(<f-args>)

" }}}

" --- plugin settings ---------------------------------------------------- {{{

" for SrcExpl
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

" for VimWiki 
let wiki = {}
let wiki.path = '~/vimwiki/'
let wiki.auto_export = 1
let wiki.path_html = '~/vimwiki/html/'
let wiki.html_header = '~/vimwiki/header.html'
let g:vimwiki_list = [wiki]
let g:vimwiki_folding = 1
let g:vimwiki_camel_case = 0

" for vim-quickrun
set runtimepath+=~/.vim/runtime/vim-quickrun
nnoremap <silent> <Leader>r :QuickRun >> -mode n<CR>
vnoremap <silent> <Leader>r :QuickRun >> -mode v<CR>

" for xp template
set runtimepath+=~/.vim/runtime/xpt
set runtimepath+=~/.vim/runtime/xpt_personal
let g:xptemplate_brace_complete = ''
let g:xptemplate_key = '<C-\>'

" for NERDTree
set runtimepath+=~/.vim/runtime/nerdtree
nnoremap <silent> <Leader>n :NERDTreeToggle<CR>

" for taglist
set runtimepath+=~/.vim/runtime/taglist
"let Tlist_Auto_Open = 1
nnoremap <silent> <Leader>f :TlistToggle<CR>

" for omnicppcomplete
set runtimepath+=~/.vim/runtime/omnicppcomplete
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --exclude=*~ .<CR>
inoremap <Nul> <C-x><C-o>
let OmniCpp_ShowPrototypeInAbbr = 1

" for neocomplcache
" set runtimepath+=~/.vim/runtime/neocomplcache
" let g:neocomplcache_enable_at_startup = 1 

" for devhelp
" au CursorHold *.c,*.h call DevhelpUpdate('a')
" au CursorHoldI *.c,*.h call DevhelpUpdate('a')
" let g:devhelpSearch=1 " To enable devhelp search:
" let g:devhelpAssistant=1 " To enable devhelp assistant:
" let g:devhelpSearchKey = '<F10>' " To change the search key (e.g. to F5):
" au FileType c,cpp setlocal updatetime=150 " To change the update delay (e.g. to 150ms):
" let g:devhelpWordLength = 5 " To change the length (e.g. to 5 characters) before a word becomes relevant:

" for autocomplpop
set runtimepath+=~/.vim/runtime/autocomplpop

" for vim-ref
set runtimepath+=~/.vim/runtime/vim-ref-gtkdoc
set runtimepath+=~/.vim/runtime/vim-ref
let g:ref_gtkdoc_cmd='gtkdoc'
let g:ref_noenter=1

" --- for gtk development ---------------------------------------------------- {{{1

" emulate devhelp.vim using vim-ref
let s:lastword = ''
function RefreshGtkdoc()
		let s:word = GetCursorWord()
		if len(s:word) > 4 && s:lastword != s:word
			call ref#open('gtkdoc', s:word, {'noenter': 1})
			let s:lastword = s:word
		endif
endfunction

" for gtk development
let g:Filetype_c_gtk = 0
au BufReadPost,BufWritePost *.c,*.h call CheckGtkDevehelopment()
function CheckGtkDevehelopment()
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
