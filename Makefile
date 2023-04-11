
COMMON_DEPS =
COMMON_DEPS+=../dfLibscad/Revision.scad
COMMON_DEPS+=../dfLibscad/Screws.scad
COMMON_DEPS+=../dfLibscad/RoundCornersCube.scad
COMMON_DEPS+=../dfLibscad/Enclosure.scad
COMMON_DEPS+=../dfLibscad/SlottedHole.scad
COMMON_DEPS+=../Makefile
COMMON_DEPS+=../Common/common.mk
COMMON_DEPS+=makefile.mk

###########################################################
# internal variables
REV =svn_rev
###########################################################
# do we have dfLibscad and do we use automatic versioning?
AUTO_REF:= $(wildcard Common/$(REV).tmpl)
USE_LIB := $(findstring dfLibscad,$(COMMON_DEPS))
###########################################################
ifeq ($(strip $(AUTO_REF)),)
else
COMMON_DEPS+=../$(REV).scad
endif

###########################################################
# export variables to sub makes
export COMMON_DEPS

###########################################################
# Rules
all : version bp vesa txx

.PHONY:
bp : | version Makefile
	@echo "===================== build BananaPro ====================="
	cd BananaPro && $(MAKE) -f makefile.mk
	@echo "===================== BananaPro Done ======================"

.PHONY:
vesa : | version Makefile
	@echo "===================== build Vesa ====================="
	cd Vesa && $(MAKE) -f makefile.mk
	@echo "===================== Vesa Done ======================"

.PHONY:
tx3 tx6 txx : | version Makefile
	@echo "===================== build Tx3/6 ====================="
	cd TX6 && $(MAKE) -f makefile.mk
	@echo "===================== Tx3/6 Done ======================"

###########################################################
# Rules for automatic versioning
.PHONY:
%.scad: %.tmpl
	SubWCRev . $< $@

ifeq ($(strip $(AUTO_REF)),)
version: | libversion
	@echo "no automatic version generated"
else
.PHONY:
.ONESHELL:
version $(REV).scad: Common/$(REV).tmpl | libversion
		SubWCRev . Common/$(REV).tmpl $(REV).scad
endif

ifeq ($(strip $(USE_LIB)),)
libversion: 
#	echo nothing to do
else
libversion: 
	cd dfLibscad && bash UpdateRevision.sh
endif

debug:
	@echo COMMON_DEPS=$(COMMON_DEPS)
	@echo AUTO_REF=$(AUTO_REF)
	@echo USE_LIB=$(USE_LIB)