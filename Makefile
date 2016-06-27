# Copyright 2016, Marcel Großmann <marcel.grossmann@uni-bamberg.de>
objects = presentation.pdf

.PHONY: all clean

# Builds and cleans latex crap
all: $(objects) cleanTemp

$(objects): %.pdf :%.tex
	latexmk -pdf -pdflatex="pdflatex -shell-escape -synctex=1 -interaction=nonstopmode" -use-make $<

cleanTemp:
	latexmk -c
	rm -f *.bbl *.nlo *.nls *.nav *.snm

clean: cleanTemp
	latexmk -CA
	rm -f *.synctex.gz
