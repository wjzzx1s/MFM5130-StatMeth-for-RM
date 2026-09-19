Makepdf = pdflatex -interaction=nonstopmode -halt-on-error
LectureNums := 01 02
HWNums := 1
HWdir := HW

# Homework sources are accepted in HW/ or in the repository root: VPATH resolves either.
VPATH := $(HWdir)
# Let pdflatex find MFM-hw.cls (and any other local input) when the source sits in HW/.
export TEXINPUTS := .:$(HWdir):$(TEXINPUTS)

# Build only the listed numbers that actually have a source, so that lecture/homework numbers
# announced in advance do not break `make all`.
Lectures-tex := $(foreach n, $(LectureNums), $(wildcard Lecture-$(n).tex))
Lectures-pdf := $(Lectures-tex:.tex=.pdf)
HWs-pdf := $(foreach n, $(HWNums), hw$(n).pdf)

missing := $(strip $(foreach n, $(LectureNums), $(if $(wildcard Lecture-$(n).tex),,Lecture-$(n).tex)) \
                  $(foreach n, $(HWNums), $(if $(wildcard hw$(n).tex $(HWdir)/hw$(n).tex),,hw$(n).tex)))
ifneq ($(missing),)
$(warning no source found for: $(missing) - skipped)
endif

.PHONY: all clean-cache clean-pdf clean-all

all: $(Lectures-pdf) $(HWs-pdf)

#Build lecture notes
#Two passes: \tableofcontents and the equation/proposition/example labels need a second run,
#so the .aux written by the first pass has to still be on disk for the second one.
Lecture-%.pdf: Lecture-%.tex
	$(Makepdf) $<
	$(Makepdf) $<
	$(MAKE) clean-cache

#Build homework
hw%.pdf: hw%.tex MFM-hw.cls
	$(Makepdf) $<
	$(MAKE) clean-cache

clean-cache:
	rm -rf *.aux *.log *.out *.toc

clean-pdf:
	rm -rf *.pdf

clean-all:
	$(MAKE) clean-cache
	$(MAKE) clean-pdf
