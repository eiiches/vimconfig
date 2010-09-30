"
" Maintainer: Eiichi Sato
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.gvimrc
"	      for Amiga:  s:.gvimrc
"  for MS-DOS and Win32:  $VIM\_gvimrc
"	    for OpenVMS:  sys$login:.gvimrc

" hide the mouse when typing text
set mousehide		

" make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" colorscheme
colorscheme myxoria256

" set font
set guifont=Bitstream\ Vera\ Sans\ Mono\ 7

" remove GUI features
set guioptions-=T "tool bar
set guioptions-=m "gui menu
set guioptions-=e "tab bar
set guioptions-=r "right-scrollbar
set guioptions-=L "left-scrollbar

