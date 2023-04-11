# Name of scad file without the extension:
TARGETNAME=Case

# scad files that are included inside this directory
DEPS+=Tanix.scad
DEPS+=HeatsinkHolder.scad
DEPS+=Model.scad

include ../Common/common.mk
