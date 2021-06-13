# \ var
MODULE  = $(notdir $(CURDIR))
OS      = $(shell uname -s)
MACHINE = $(shell uname -m)
NOW     = $(shell date +%d%m%y)
REL     = $(shell git rev-parse --short=4 HEAD)
BRANCH  = $(shell git rev-parse --abbrev-ref HEAD)
CORES   = $(shell grep processor /proc/cpuinfo| wc -l)
# / var

# \ dir
CWD     = $(CURDIR)
BIN     = $(CWD)/bin
DOC     = $(CWD)/doc
TMP     = $(CWD)/tmp
LIB     = $(CWD)/lib
SRC     = $(CWD)/src
TEST    = $(CWD)/test
GZ      = $(HOME)/gz
# / dir

# \ tool
CURL    = curl -L -o
NIMBLE  = nimble
NIMP    = nimpretty
# / tool

# \ src
N      += src/$(MODULE).nim tests/test.nim
# / src
S      += $(Y) $(N) $(E) $(X) $(C) $(LL)

# \ all
.PHONY: all
all:
	nimble run $(MODULE) $@
	$(MAKE) test
	$(MAKE) format

.PHONY: repl
repl:
	nimble run $(MODULE) $@
	$(MAKE) test
	$(MAKE) format
	$(MAKE) $@

.PHONY: test
test:
	nimble test

.PHONY: format
format: tmp/format
tmp/format: $(N)
	$(NIMP) --indent:2 $?
# / all


# \ doc
.PHONY: doc
doc: \
	doc/week12-2013.pdf doc/LispInSmallPieces_ru.pdf
doc/week12-2013.pdf:
	$(CURL) $@ https://www.epfl.ch/labs/lamp/wp-content/uploads/2019/01/week12-2013.pdf
doc/LispInSmallPieces_ru.pdf:
	$(CURL) $@ https://github.com/ilammy/lisp/releases/download/v.1.2/lisp.pdf

.PHONY: doxy
doxy: doxy.gen
	doxygen $< 1>/dev/null
# / doc

# \ install
.PHONY: install update
install: $(OS)_install doc
	curl https://nim-lang.org/choosenim/init.sh -sSf | sh
	$(MAKE) update
update: $(OS)_update
	choosenim update self
	choosenim update stable
	nimble    install nimble
	nimble    refresh

.PHONY: Linux_install Linux_update
Linux_install Linux_update:
	sudo apt update
	sudo apt install -u `cat apt.txt`
# / install

# \ merge
MERGE  = README.md LICENSE Makefile .gitignore apt.txt apt.dev .vscode $(S)
MERGE += bin doc lib src test tmp
MERGE += $(MODULE).nimble nim.cfg

.PHONY: zip
zip:
	git archive \
		--format zip \
		--output $(TMP)/$(MODULE)_$(BRANCH)_$(NOW)_$(REL).src.zip \
	HEAD

.PHONY: dev
dev:
	git push -v
	git checkout $@
	git pull -v
	git checkout ponymuck -- $(MERGE)

.PHONY: ponymuck
ponymuck:
	git push -v
	git checkout $@
	git pull -v
# / merge
