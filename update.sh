#!/bin/bash

VIM_ROOT=$(dirname $(readlink -f $0))
cd $VIM_ROOT

git submodule init
git submodule update

git ls-files --stage --error-unmatch | grep '^160000' | while read mode sha1 num p
do
	cd $p
	echo "$p"
	git checkout master
	git pull
	cd -
done

(
	cd runtime/vim-metarw
	make
)

(
	cd runtime/metarw-git
	make
)

#(
# TODO...
#	git svn fetch vim-latex
#)

