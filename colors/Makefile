source = $(wildcard *.vcs)
output = $(source:.vcs=.vim)

all: $(output)

.SUFFIXES: .vcs .vim
.vcs.vim:
	./csgen $< > $@
