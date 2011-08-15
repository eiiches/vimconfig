"
" Maintainer: Eiichi Sato
"
" To use it, copy it to
"   for Unix and OS/2:  ~/.gvimrc
"   for Amiga:  s:.gvimrc
"   for MS-DOS and Win32:  $VIM\_gvimrc
"   for OpenVMS:  sys$login:.gvimrc

" Settings: ----------------------------
" {{{ reset augroup gvimrc

augroup gvimrc
	au!
augroup END

" }}}
" {{{ auto reload gvimrc

autocmd gvimrc BufWritePost .gvimrc,~/.vim/gvimrc,~/.vim/lgvimrc execute 'source' expand('<amatch>')

" }}}
" {{{ font

let g:fontname = 'Bitstream Vera Sans Mono'
let g:fontsize = 7

" set guifont
function! s:update_guifont()
	let &guifont = g:fontname.' '.g:fontsize
endfunction
autocmd gvimrc GUIEnter * call s:update_guifont()

" font size
function! s:inc_font_size(inc)
	let g:fontsize += a:inc
	call s:update_guifont()
endfunction
nnoremap <silent> - :call <sid>inc_font_size(-1)<CR>
nnoremap <silent> + :call <sid>inc_font_size(1)<CR>

" }}}
" {{{ GUI features

" remove toolbar
set guioptions-=T

" remove menubar
set guioptions-=m

" remove tabbar
set guioptions-=e

" remove scrollbars
set guioptions-=rL

" use console dialog
set guioptions+=c

" }}}
" {{{ IM control

set iminsert=0
set imsearch=0

" disable IM when switching to normal mode
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" }}}
" {{{ title

set t_ts=
set t_fs=
let &titlestring = "%t"
set title

" }}}

" disable visualbell
set novisualbell

" hide the mouse when typing text
set mousehide

" make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" colorscheme
colorscheme myxoria256

" Local: -------------------------------
" {{{ source ~/.vim/lgvimrc

let g:local_gvimrc = expand('~/.vim/lgvimrc')
if filereadable(g:local_gvimrc)
	execute 'source' g:local_gvimrc
endif

" }}}

" vim: ts=4:sw=4:sts=0:fdm=marker:fmr={{{,}}}
