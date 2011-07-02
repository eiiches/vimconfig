# vim: ft=make

.SUFFIXES: .gnuplot .eps
.gnuplot.eps:
	gnuplot $<

