source = $(wildcard *.vcs)
output = $(source:.vcs=.vim)

all: $(output)
$(output): csgen

.SUFFIXES: .vcs .vim
.vcs.vim:
	./csgen $< > $@
