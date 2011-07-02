# vim: ft=make

.SUFFIXES: .dot .png
.dot.png:
	dot -Tpng -o$@ $<

