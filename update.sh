#!/bin/bash

verbose() { echo "$@"; "$@"; }
scriptdir=$(dirname $(readlink -f $0))
cd $scriptdir

# parse options
init=
while [ $# -ne 0 ]; do
	case "$1" in
		--init)
			shift && init=1 ;;
		*)
			shift ;;
	esac
done

# symlink .vimrc etc.
if [ -n "$init" ]; then
	verbose ln -si ~/.vim/vimrc ~/.vimrc
	verbose ln -si ~/.vim/gvimrc ~/.gvimrc
fi

# init and update submodules
git submodule update --recursive --init
git submodule foreach 'git checkout master; git pull'

# setup each plugins
( cd bundle/vimproc && make -f make_gcc.mak )
( cd bundle/vim-metarw && make )
( cd bundle/metarw-git && make )
( cd bundle/vim-ref-gtkdoc/gtkdoc && make )
( cd bundle/vim-altr && make )

# update helptags
vim +UpdateHelp +q

