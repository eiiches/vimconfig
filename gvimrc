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

autocmd gvimrc BufWritePost .gvimrc,~/.vim/gvimrc execute 'source' expand('<amatch>')

" }}}
" {{{ font

let g:fontname = 'Bitstream Vera Sans Mono'
let g:fontsize = 7
let &guifont = g:fontname.' '.g:fontsize

" font size
function! s:change_font_size(inc)
	let g:fontsize += a:inc
	let &guifont = g:fontname.' '.g:fontsize
endfunction
nnoremap <silent> - :call <sid>change_font_size(-1)<CR>
nnoremap <silent> + :call <sid>change_font_size(1)<CR>

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

" disable visualbell
set novisualbell

" hide the mouse when typing text
set mousehide

" make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" colorscheme
colorscheme myxoria256

