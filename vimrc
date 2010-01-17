
"
" Vim Setting File by Eiichi Sato
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

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

set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
" set mouse=a
endif

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

" My Settings Begin ---------------------------------------


set nocp "for omnicppcomplete
map <C-F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --exclude=*~ .<CR>
inoremap <Nul> <C-x><C-o>
let OmniCpp_ShowPrototypeInAbbr = 1


"let Tlist_Auto_Open = 1


set directory=~/.vim/swp
set tabstop=2

set guioptions-=T "remove tool bar
set guioptions-=m "remove gui menu
set guioptions-=e "remove GUI tab bar
set guioptions-=r "remove right-scrollbar
set guioptions-=L "remove left-scrollbar

nmap gb :ls<CR>:buf 

map j gj
map k gk

set nowrap

set history=500 "overwrite the default above
set noerrorbells "do not ring error bells
set number
set showmode
set guifont=Bitstream\ Vera\ Sans\ Mono\ 7
colorscheme delek "slate delek zell wombat rdark
set iminsert=0
set imsearch=0
inoremap <ESC> <ESC>:set iminsert=0<CR>:echo<CR>
set showmatch			" showmatch: Show the matching bracket for the last ')'?

set ignorecase			" ignore case
set smartcase			" but don't ignore it, when search string contains uppercase letters

set shiftwidth=2


set shellslash
set grepprg=grep\ -nH\ $* 
let g:Tex_CompileRule_dvi = 'platex --interaction=nonstopmode $*' 
"let g:Tex_ViewRule_dvi = 'xdvik-ja'
let g:tex_flavor = "latex"

"set cindent
"set autoindent
"set scrolloff=5 		" 5 lines bevore and after the current line when scrolling
"set completeopt=menu,longest,preview
set completeopt=menuone

set encoding=utf8
set fileencodings=utf-8,euc-jp,sjis,iso-2022-jp

" // The switch of the Source Explorer
nmap <F8> :SrcExplToggle<CR>

" // Set the height of Source Explorer window
let g:SrcExpl_winHeight = 8

" // Set 100 ms for refreshing the Source Explorer
let g:SrcExpl_refreshTime = 100

" // Set "Enter" key to jump into the exact definition context
let g:SrcExpl_jumpKey = "<ENTER>"

" // Set "Space" key for back from the definition context
let g:SrcExpl_gobackKey = "<SPACE>"

" // In order to Avoid conflicts, the Source Explorer should know what plugins
" // are using buffers. And you need add their bufname into the list below
" // according to the command ":buffers!"
let g:SrcExpl_pluginList = [
        \ "__Tag_List__",
        \ "_NERD_tree_",
        \ "Source_Explorer"
    \ ]
" // Enable/Disable the local definition searching, and note that this is not
" // guaranteed to work, the Source Explorer doesn't check the syntax for now.
" // It only searches for a match with the keyword according to command 'gd'
let g:SrcExpl_searchLocalDef = 1

" // Let the Source Explorer update the tags file when opening
let g:SrcExpl_isUpdateTags = 0

" // Use program 'ctags' with argument '--sort=foldcase -R' to create or
" // update a tags file
let g:SrcExpl_updateTagsCmd = "ctags -R --c++-kinds=+p --fields=+iaS --extra=+q --sort=foldcase --exclude=*~ ."

" // Set "<F12>" key for updating the tags file artificially
let g:SrcExpl_updateTagsKey = "<F12>" 

" source $VIMRUNTIME/mswin.vim
" behave mswin

autocmd FileType c set dict=~/.vim/dict/c/*.dict
autocmd BufRead *.vala set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vapi set efm=%f:%l.%c-%[%^:]%#:\ %t%[%^:]%#:\ %m
autocmd BufRead *.vala set smartindent
autocmd BufRead *.vala set cindent
au BufRead,BufNewFile *.vala            setfiletype vala
au BufRead,BufNewFile *.vapi            setfiletype vala

au BufWritePost *.sh exe "silent !chmod +x %"

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

" My Setting End ------------------------------------------
