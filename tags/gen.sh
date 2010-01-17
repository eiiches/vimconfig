#!/bin/bash

TAGS_DIR=~/.vim/tags/c

IGNORE_TOKEN="-I__wur -I__THROW -I__attribute_malloc__ -I__attribute_pure__ -I__attribute_deprecated__ -I__attribute_warn_unused_result__ -I__nonnull"

ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/getopt.tags /usr/include/getopt.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/limits.tags /usr/include/limits.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/signal.tags /usr/include/signal.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/assert.tags /usr/include/assert.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/regex.tags /usr/include/regex.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/time.tags /usr/include/time.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/stdio.tags /usr/include/stdio.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/unistd.tags /usr/include/unistd.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/stdlib.tags /usr/include/stdlib.h
ctags --c-kinds=+pxdf $IGNORE_TOKEN -f $TAGS_DIR/string.tags /usr/include/string.h

ctags --c-kinds=+pxdf $IGNORE_TOKEN -I__cleanup_fct_attribute -f $TAGS_DIR/pthread.tags /usr/include/pthread.h

cat <<EOF > c/math.tags
!_TAG_FILE_FORMAT	2	/extended format; --format=1 will not append ;" to lines/
!_TAG_FILE_SORTED	1	/0=unsorted, 1=sorted, 2=foldcase/
!_TAG_PROGRAM_AUTHOR	Darren Hiebert	/dhiebert@users.sourceforge.net/
!_TAG_PROGRAM_NAME	Exuberant Ctags	//
!_TAG_PROGRAM_URL	http://ctags.sourceforge.net	/official site/
!_TAG_PROGRAM_VERSION	5.8	//
EOF
gcc -E /usr/include/math.h > math.h
ctags --c-kinds=+pxdf -I__wur -f - math.h | grep -v "^__" >> $TAGS_DIR/math.tags
rm -rf math.h



