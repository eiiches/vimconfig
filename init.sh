#!/bin/bash

VIM_ROOT=$(readlink -f $(dirname $0))

cd $VIM_ROOT
git submodule init
git submodule update

(
	cd runtime/vim-metarw
	git submodule init
	git submodule update
	make
)

(
	cd runtime/metarw-git
	git submodule init
	git submodule update
	make
)

(
	cd
	ln -s .vim/vimrc .vimrc
	ln -s .vim/gvimrc .gvimrc
)
