#!/bin/bash

scriptdir=$(dirname $(readlink -f $0))
cd $scriptdir

git submodule update --recursive --init
git submodule foreach 'git checkout master; git pull'

( cd bundle/vimproc && make -f make_gcc.mak )
( cd bundle/vim-metarw && make )
( cd bundle/metarw-git && make )
( cd bundle/vim-ref-gtkdoc/gtkdoc && make )
( cd bundle/vim-altr && make )

vim +UpdateHelp +q

