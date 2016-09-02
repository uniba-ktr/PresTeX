# Copyright 2016, Marcel Großmann <marcel.grossmann@uni-bamberg.de>
# Adjust your base GIT directory relatively to Makefile
base = .
# Internal Variables - Touch & Perish
main = presentation
styles= gitinfo2.sty gitexinfo.sty beamerthemeUniBa169.sty beamerthemeUniBa43.sty
bibtexstyles = IEEEtran.bst
classes = IEEEtran.cls
hooks = post-checkout post-commit post-merge
# Folder to clone TeXMeta to, relatively to $base
meta = $(base)/meta
# TeXMeta location
metaurl = "https://github.com/uniba-ktr/TeXMeta.git"
# Git Prepare message
gitprepare = "Initialized Git Foo"
# Git hooks
gitinfohook = $(meta)/style/gitinfo2-hook.txt
githooks = $(base)/.git/hooks
# Docker adjustements
uid = $(shell id -u $$USER)
gid = $(shell id -g $$USER)
dockerabsvol = $(shell git rev-parse --show-toplevel)
dockerincontainer = $(shell dirname $(shell git ls-tree --full-name --name-only HEAD Makefile))

.PHONY: all alldocker prepare init clean docker

.DEFAULT_GOAL := $(main)

# Call make prepare only once after checkout
prepare: initializegit gitmodules $(hooks)
	test -f .prepared || sed -i 's#\\newcommand\\meta.*#\\newcommand\\meta{${meta}}#g' $(main).tex
	test -f .prepared || ln -fs $(base)/.git/gitHeadInfo.gin gitHeadLocal.gin
	test -f .prepared || git add --all
	test -f .prepared || git commit -m $(gitprepare)
	test -f .prepared || touch .prepared

# Call make init to create structure and update the meta files
init: $(styles) $(bibtexstyles) $(classes)
	mkdir -p graphic code images content
	cd $(meta) && git pull origin master

# Call make [seminar]
$(main): $(main).tex
	latexmk -pdf -pdflatex="pdflatex -shell-escape -synctex=1 -interaction=nonstopmode" -use-make $<
	latexmk -c

# Call make clean
clean:
	latexmk -c
	rm -f *.synctex.gz *.bbl *.nlo *.nls *.nav *.snm

# Call make docker
docker:
	@docker run -it --rm -v $(dockerabsvol)/:/src/ -w /src unibaktr/dock-tex:jessie /bin/sh -c "cd $(dockerincontainer) && make && make clean"
	chown $(uid):$(gid) $(main).pdf

all: init $(main) clean

alldocker: init docker

# Internal Targets

initializegit:
	test -f .prepared || rm -rf .git .gitmodules meta
	test -f .prepared || ( cd $(base) && ( test -d .git || git init ) )

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
