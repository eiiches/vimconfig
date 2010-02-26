#!/bin/bash
IGNORE_TOKEN="-I__wur -I__THROW -I__attribute_malloc__ -I__attribute_pure__ -I__attribute_deprecated__ -I__attribute_warn_unused_result__ -I__nonnull"
ctags --c-kinds=+pxdf $IGNORE_TOKEN -R -f - /usr/include/sqlite3.h | grep -v "^_" | grep -v "^!" | cut -f 1 | sort | uniq > sqlite3.dict
