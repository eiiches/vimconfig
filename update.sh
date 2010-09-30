#!/bin/bash

VIM_ROOT=$(readlink -f $(dirname $0))

cd $VIM_ROOT
git submodule init
git submodule update

(
	cd runtime/neocomplcache && \
	git checkout master && \
	git pull
)

(
	cd runtime/vim-quickrun && \
	git checkout master && \
	git pull
)

(
# TODO...
	git svn fetch vim-latex
)

