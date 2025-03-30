# Diplomdarba Makefile
# no J.Šmēdiņa sagataves https://github.com/Astro-Johnny/vea-thesis-template

# General flags
PDFTEX = xelatex
PDFTK = $(shell which pdftk)

# OUTPUT
SUBPARTS = abstracts.tex ievads.tex conclusions.tex references.tex \
titullapa.tex \
processors.tex processors.cpu.tex processors.gpu.tex processors.fpga.tex \
processors.hetero.tex processors.comparison.tex \
algorithms.tex algorithms.matching.tex \
fast.tex fast.original.tex fast.opencv.tex fast.fpga.tex fast.comparison.tex \
brief.tex \
appendices.tex appx.test1.tex appx.test2.tex appx.test3.tex appx.tools.tex
IMAGES = CPU-arch.pdf_tex GPU-arch.pdf_tex snoop-cache-bottleneck.pdf_tex \
orb-match.jpg FPGA-arch.pdf_tex FPGA-arch2.pdf_tex full-hetero-system.pdf_tex \
chart-fpga.pdf chart-cpu.pdf nonmax-suppression.pdf_tex fpga-model.pdf_tex \
rBRIEF.pdf_tex orb.pdf_tex chunk-overhead.pdf_tex brief-fpga.pdf_tex \
gauss+brief.pdf_tex

# First target (here - 'default') gets invoked if make is run with no target
default: diplomdarbs.pdf ;


diplomdarbs.pdf: diplomdarbs.tex $(addprefix img/,$(IMAGES)) $(SUBPARTS)
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
