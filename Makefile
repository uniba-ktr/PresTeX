# Copyright 2016, Marcel Großmann <marcel.grossmann@uni-bamberg.de>
main = presentation
hooks = post-checkout post-commit post-merge
styles= gitinfo2.sty gitexinfo.sty beamerthemeUniBa169.sty beamerthemeUniBa43.sty
bibtexstyles = IEEEtran.bst
#classes = IEEEtran.cls
# Base GIT directory relatively to Makefile
base = .
# Folder to clone TeXMeta to, relatively to $base
meta = $(base)/meta
# TeXMeta location
metaurl = "https://github.com/uniba-ktr/TeXMeta.git"
# Git hooks
gitinfohook = $(meta)/style/gitinfo2-hook.txt
githooks = $(base)/.git/hooks

.PHONY: all init clean gitmodules docker

.DEFAULT_GOAL := $(main)

$(main) : $(main).tex
	latexmk -pdf -pdflatex="pdflatex -shell-escape -synctex=1 -interaction=nonstopmode" -use-make $<
	latexmk -c
	rm -f *.bbl *.nlo *.nls *.nav *.snm

clean:
	latexmk -CA
	rm -f *.synctex.gz

init: gitmodules $(hooks) $(styles) $(bibtexstyles) $(classes)
	mkdir -p graphic code images content
	test -f gitHeadLocal.gin || ln -s $(base)/.git/gitHeadInfo.gin gitHeadLocal.gin
	sed -i 's#\\newcommand\\meta.*#\\newcommand\\meta{${meta}}#g' $(main).tex

gitmodules:
	test -d $(meta) || git submodule add $(metaurl) $(meta)
	git submodule update --init

$(styles): %.sty : $(meta)/style/%.sty
	cp $^ $@

$(bibtexstyles): %.bst : $(meta)/style/%.bst
	cp $^ $@

$(classes): %.cls : $(meta)/style/%.cls
	cp $^ $@

$(hooks):
	cp $(gitinfohook) $(githooks)/$@
	chmod u+x $(githooks)/$@

absvol = $(shell git rev-parse --show-toplevel)
incontainer = $(shell dirname $(shell git ls-tree --full-name --name-only HEAD Makefile))

docker:
	@docker run -it --rm -v $(absvol)/:/src/ -w /src unibaktr/dock-tex:jessie /bin/sh -c "cd $(incontainer) && make"
