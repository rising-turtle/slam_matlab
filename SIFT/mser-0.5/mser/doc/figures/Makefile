## emacs:       -*- mode: Makefile -*-
## file:        Makefile
## author:      Andrea Vedaldi
## description: Convert .fig in .pdf

fig_sources := $(wildcard *.fig)
pdf_targets := $(fig_sources:.fig=.pdf)
tex_targets := $(fig_sources:.fig=.tex)

%.pdf : %.fig
	fig2dev -L pdftex $< $@

%.tex : %.fig
	fig2dev -L pdftex_t -p figures/$*.pdf $< $@

.PHONY: all
all: $(pdf_targets) $(tex_targets)

.PHONY: clean
clean:
	rm -f $(pdf_targets) $(tex_targets)

