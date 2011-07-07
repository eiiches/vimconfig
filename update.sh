#!/bin/bash

scriptdir=$(dirname $(readlink -f $0))
cd $scriptdir

git submodule init
git submodule update
git submodule foreach 'git checkout master; git pull'

( cd runtime/vimproc && make -f make_gcc.mak )
( cd runtime/vim-metarw && make )
( cd runtime/metarw-git && make )
( cd runtime/vim-ref-gtkdoc/gtkdoc && make )

