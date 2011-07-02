# vim: ft=make

TEX = platex

.SUFFIXES: .tex .dvi
.tex.dvi:
	nkf -e $< | $(TEX) -no-parse-first-line -interaction=nonstopmode -file-line-error -jobname=$(basename $< .tex) /dev/stdin | sed "s:/dev/stdin:$<:"
	nkf -e $< | $(TEX) -no-parse-first-line -interaction=nonstopmode -file-line-error -jobname=$(basename $< .tex) /dev/stdin > /dev/null

# .SUFFIXES: .dvi .pdf
# .dvi.pdf:
# 	dvipdfmx $<

.SUFFIXES: .dvi .ps
.dvi.ps:
	dvips $<

.SUFFIXES: .ps .pdf
.ps.pdf:
	ps2pdf $<

.SUFFIXES: .dvi .png
.dvi.png:
	dvipng -D 1000 -T tight -bg Transparent -o $@ $<

