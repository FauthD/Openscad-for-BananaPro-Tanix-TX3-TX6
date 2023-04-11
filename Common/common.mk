
DEPS+=$(COMMON_DEPS)

# Results
OUTPUTDIR=STL
IMAGEDIR =PNG

# what
WhatToPrint =print

OPENSCAD ?= openscad-nightly --enable=fast-csg --enable=fast-csg-trust-corefinement --enable=lazy-union
#OPENSCAD ?= openscad

# Hopefully there is no need to change something below
###########################################################
# openscad options
WHAT_TO_PRINT=-D "WhatToPrint=\"$(WhatToPrint)\""

SHOW_MODULES=-D "ShowModules=1"
IMAGE_SIZE=--imgsize 1024,1024 --viewall
CAMERA=--camera=0,0,0,45,0,130,500
AUTOCENTER=--autocenter
VIEW=--view axes

PNG_CMDS  =$(SHOW_MODULES)
PNG_CMDS += $(IMAGE_SIZE)
PNG_CMDS += $(CAMERA)
PNG_CMDS += $(AUTOCENTER)
#PNG_CMDS += $(VIEW)

TARGETS_STL = $(addprefix $(OUTPUTDIR)/, $(addprefix $(TARGETNAME)_,$(addsuffix .stl, $(PARTS_STL))))
TARGETS_PNG = $(addprefix $(IMAGEDIR)/, $(addprefix $(TARGETNAME)_,$(addsuffix .png, $(PARTS_PNG))))
JSON        = $(TARGETNAME).json

###########################################################
# retrive the parts list from the json file
# Note: The trick with OPENBRACE is to avoid issues with syntax coloring in vs-code
OPENBRACE={
RAW_PARTS_PNG = $(shell grep ': $(OPENBRACE)' $(JSON) | grep -v parameterSets | grep -v 'design default values')
RAW_PARTS_STL = $(shell grep ': $(OPENBRACE)' $(JSON) | grep -v parameterSets | grep -v 'design default values' | grep -v PNG)
# remove unwanted characters
PARTS_PNG = $(subst ",, $(subst : $(OPENBRACE),,$(RAW_PARTS_PNG)))
PARTS_STL = $(subst ",, $(subst : $(OPENBRACE),,$(RAW_PARTS_STL)))
###########################################################

all: png stl

stl : $(TARGETS_STL)

png : $(TARGETS_PNG)

$(TARGETS_STL) : $(DEPS) $(JSON) | dir_build

$(TARGETS_PNG) : $(DEPS) $(JSON) | dir_build

%.stl: $(TARGETNAME).scad
	$(OPENSCAD) -p "$(JSON)" -P $(subst $(OUTPUTDIR)/$(TARGETNAME)_,,$(@:.stl=)) $(WHAT_TO_PRINT) $< -o $@

%.png: $(TARGETNAME).scad
	$(OPENSCAD) -p "$(JSON)" -P $(subst $(IMAGEDIR)/$(TARGETNAME)_,,$(@:.png=)) $(PNG_CMDS) -D "png=true" $(WHAT_TO_PRINT) $< -o $@

dir_build:
	@mkdir -p $(OUTPUTDIR)
	@mkdir -p $(IMAGEDIR)
	
clean:
	-rm -rf $(OUTPUTDIR)
	-rm $(REV).scad

debug:
	@echo DEPS=$(DEPS)
	@echo $(TARGETS_STL)
	@echo $(TARGETS_PNG)
	@echo $(RAW_PARTS_PNG)
	@echo $(PARTS_PNG)
	@echo $(RAW_PARTS_STL)
	@echo $(PARTS_STL)

# Copyright (C) 2021 Dieter Fauth
# This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
# This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details. You should have received a copy of the GNU General Public License along with this program. If not, see <http://www.gnu.org/licenses/>.
# Contact: dieter.fauth at web.de
	