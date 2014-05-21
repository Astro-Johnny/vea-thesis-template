# This is a Makefile for my thesis
# author: Jānis "JohnLM" Šmēdiņš

# General flags
PDFTEX = xelatex
PDFTK = $(shell which pdftk)

# OUTPUT
NAME = masters
SUBPARTS = abstracts.tex ievads.tex conclusions.tex references.tex \
titullapa.tex \
processors.tex processors.cpu.tex processors.gpu.tex processors.fpga.tex \
processors.hetero.tex processors.comparison.tex \
algorithms.tex algorithms.matching.tex \
fast.tex fast.original.tex fast.opencv.tex fast.fpga.tex fast.comparison.tex \
rbrief.tex \
appendices.tex appx.test1.tex appx.test3.tex
IMAGES = CPU-arch.pdf_tex GPU-arch.pdf_tex snoop-cache-bottleneck.pdf_tex \
orb-match.jpg FPGA-arch.pdf_tex FPGA-arch2.pdf_tex full-hetero-system.pdf_tex \
chart-fpga.pdf chart-cpu.pdf nonmax-suppression.pdf_tex fpga-model.pdf_tex
TABLES = results1-t1.tbl_tex fpga_test-t1.tbl_tex

# First target (here - 'default') gets invoked if make is run with no target
default: $(addprefix img/,$(IMAGES)) $(addprefix img/,$(filter %.pdf,$(TABLES))) $(filter %.tbl_tex,$(TABLES)) $(SUBPARTS)
	$(PDFTEX) $(NAME).tex

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

.PHONY: default

.SECONDEXPANSION:
$(addprefix img/,$(filter %.pdf,$(TABLES))):%.pdf: $$(subst img/,tables/,$$(basename $$(subst -,.,$$*))).gnumeric
	ssconvert -O 'sheet=$(subst .,,$(suffix $(subst -,.,$*))) paper=A3' $< $*.noncropped.pdf
	pdfcrop --margins 2 $*.noncropped.pdf $@
ifneq ($(PDFTK),)
	mv $*.pdf $*.tmp.pdf
	$(PDFTK) $*.tmp.pdf output $*.pdf
endif

$(filter %.tbl_tex,$(TABLES)):%.tbl_tex: tables/$$(basename $$(subst -,.,$$*)).gnumeric
	ssconvert -T Gnumeric_stf:stf_assistant -O 'sheet=$(subst .,,$(suffix $(subst -,.,$*))) quoting-mode=never separator=& format=preserve' $< fd://1 | sed -r -e '/^\&*$$/!s/\&*$$/\\\\/' -e 's/^\&*$$/\\midrule/' -e 's/\&/ \& /g' > $@
