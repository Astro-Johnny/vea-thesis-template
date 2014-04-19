# This is a Makefile for my thesis
# author: Jānis "JohnLM" Šmēdiņš

# General flags
PDFTEX = xelatex
PDFTK = $(shell which pdftk)

# OUTPUT
NAME = masters
SUBPARTS = ievads.tex references.tex \
processors.tex processors.cpu.tex processors.gpu.tex
IMAGES = CPU-arch.pdf_tex GPU-arch.pdf_tex snoop-cache-bottleneck.pdf_tex
TABLES = 

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
	ssconvert -T Gnumeric_stf:stf_assistant -O 'sheet=$(subst .,,$(suffix $(subst -,.,$*))) quoting-mode=never separator=& format=preserve' $< fd://1 | sed -r -e '/^\&*$$/!s/$$/\\\\/' -e 's/^\&*$$/\\midrule/' -e 's/\&/ \& /g' > $@
