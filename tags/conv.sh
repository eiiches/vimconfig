#!/bin/bash

TAGS_DIR=~/.vim/tags/c
DICT_DIR=~/.vim/dict/c

for f in $TAGS_DIR/*.tags ; do
	name=`basename $f .tags`
	cat $f | grep -v "^_" | grep -v "^!" | cut -f 1 | sort | uniq > $DICT_DIR/$name.dict
done

