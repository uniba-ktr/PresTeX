# Copyright 2016, Marcel Großmann <marcel.grossmann@uni-bamberg.de>
# Adjust your base GIT directory relatively to Makefile
base := .
# Internal Variables - Touch & Perish
# Folder to clone TeXMeta to, relatively to $base
meta := $(base)/meta
main := presentation
styles := beamerthemeUniBa169.sty beamerthemeUniBa43.sty
bibtexstyles := IEEEtran.bst
classes := IEEEtran.cls
# TeXMeta location
metaurl := "https://github.com/uniba-ktr/TeXMeta.git"

MAKE_FILE := $(meta)/Makefile

ifeq ($(wildcard $(MAKE_FILE)),)
.DEFAULT_GOAL := gitmodules
else
include $(MAKE_FILE)
endif

# Internal Targets
gitmodules: initialize
	@test -d $(meta) || git submodule add $(metaurl) $(meta)
	@git submodule update --init $(meta)
	@( git add $(meta) && git commit -m "Update meta" ) || true
	@make prepare

initialize:
	@test -f .prepared || rm -rf .git .gitmodules meta
	@test -f .prepared || ( cd $(base) && ( test -d .git || git init ) )
