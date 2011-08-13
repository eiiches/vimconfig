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

" hide the mouse when typing text
set mousehide

" make shift-insert work like in Xterm
map <S-Insert> <MiddleMouse>
map! <S-Insert> <MiddleMouse>

" colorscheme
colorscheme myxoria256

" remove GUI features
set guioptions-=T "tool bar
set guioptions-=m "gui menu
set guioptions-=e "tab bar
set guioptions-=r "right-scrollbar
set guioptions-=L "left-scrollbar

" IM
set iminsert=0
set imsearch=0
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

