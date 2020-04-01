# file:        Makefile
# author:      Andrea Vedaldi
# description: Build mex files

# --------------------------------------------------------------------
#
# --------------------------------------------------------------------

# Determine on the flight the system we are running on
Darwin_PPC_ARCH    := mac
Darwin_i386_ARCH   := mci
Linux_i386_ARCH    := glx
Linux_unknown_ARCH := glx
Linux_i686_ARCH    := glx

ARCH             := $($(shell echo `uname -sp` | tr \  _)_ARCH)

mci_CFLAGS       := -I. -pedantic -Wall
mci_MEX_CFLAGS   := -O -g CFLAGS='$$CFLAGS $(mci_CFLAGS)'
mci_MEX_SUFFIX   := mexmaci

mac_CFLAGS       := -I. -pedantic -Wall
mac_MEX_CFLAGS   := -O -g CFLAGS='$$CFLAGS $(mac_CFLAGS)'
mac_MEX_SUFFIX   := mexmac

glx_CFLAGS       := -I. -pedantic -Wall
glx_MEX_CFLAGS   := -O -g CFLAGS='$$CFLAGS $(glx_CFLAGS)'
glx_MEX_SUFFIX   := mexglx

MEX_SUFFIX       := $($(ARCH)_MEX_SUFFIX)
MEX_CFLAGS       := $($(ARCH)_MEX_CFLAGS)

VER              := 1.0
DIST             := vicinalboost-$(VER)

# --------------------------------------------------------------------
#
# --------------------------------------------------------------------

vpath %.mex.c .

src  := $(wildcard *.c)
msrc := $(wildcard *.m)
stem := $(notdir $(basename $(basename $(src))))
tgt  := $(addsuffix .$(MEX_SUFFIX),$(stem))

%.$(MEX_SUFFIX) : %.c
	mex -I. $(MEX_CFLAGS) $<

.PHONY: all
all: $(tgt)

.PHONY: info
info :
	@echo src = $(src)
	@echo stem = $(stem)
	@echo tgt = $(tgt)

.PHONY: clean
clean:
	rm -f $(tgt)
	rm -f .DS_Store .gdb_history
	find . -name '*~' -exec rm -f \{\} \;

.PHONY: distclean
distclean: clean
	rm -f *.mexmac *.mexglx
	rm -f data/vjf_tangent.mat
	rm -f data/shapes.*
	rm -f results/*.mat
	rm -rf log

.PHONY: dist
dist: distclean
	echo Version $(VER) >TIMESTAMP
	echo Archive created on `date` >>TIMESTAMP
	d=$(notdir $(CURDIR)) ; \
	tar chzvf $(DIST).tar.gz \
	   --exclude $(DIST).tar.gz  \
	   --exclude Wavelab850 \
	   --exclude log \
	   ../$${d}

.PHONY: autorights
autorights: distclean
	autorights \
	  . \
	  --recursive    \
	  --verbose \
	  --template copylet.txt \
	  --years 2007   \
	  --authors "Andrea Vedaldi and Paolo Favaro" \
	  --holders "Andrea Vedaldi and Paolo Favaro" \
	  --program "VicinalBoost"
