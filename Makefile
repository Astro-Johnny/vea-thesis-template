# Diplomdarba Makefile
# no J.Šmēdiņa sagataves https://github.com/Astro-Johnny/vea-thesis-template

# General flags
PDFTEX = xelatex
PDFTK = $(shell which pdftk)

# OUTPUT
IMAGES = \
	rtl-unit.pdf_tex \
	rtl-alu.pdf_tex \
	perry-cpu.pdf \


# First target (here - 'default') gets invoked if make is run with no target
default: diplomdarbs.pdf ;


diplomdarbs.pdf: diplomdarbs.tex tex/*.tex $(addprefix img/,$(IMAGES))
	$(PDFTEX) $<

%.pdf_tex:: %.svg
	inkscape -z --export-pdf=$*.pdf --export-latex $<
ifneq ($(PDFTK),)
	mv $*.pdf $*.tmp.pdf
	$(PDFTK) $*.tmp.pdf output $*.pdf
endif

%.pdf:: %.svg
	inkscape -z --export-pdf=$@ $<
ifneq ($(PDFTK),)
	mv $*.pdf $*.tmp.pdf
	$(PDFTK) $*.tmp.pdf output $*.pdf
endif

#%.png:: %.bmp
%.png:: %.BMP
	convert $< png:$@

.PHONY: default diplomdarbs.pdf
