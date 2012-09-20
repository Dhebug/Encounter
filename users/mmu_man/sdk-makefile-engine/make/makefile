## OSDK Generic Makefile v0.1 ##

# specify the program name (without extension, no space)
#
# NAME=mydemo
NAME=

# specify the type of binary
# 	TAPE:	Tape image (default)
#	DISK:	Disk image
#
# TYPE=TAPE
TYPE=

# specify the load address (in hex, no prefix)
#
# ADDR=600
ADDR=

# specify the source files (without extension)
#
# FILES=main foo bar ...
FILES=

# specify extra preprocessor defines (optional)
#
# DEFINES=-Dfoo=bar -DUSE_BAR ...
DEFINES=


## No user serviceable part beyond this point ##

# MAGIC: DO NOT TOUCH
#\
!if "$(MAKE)" == "NMAKE" || "$(MAKE)" == "nmake"
#\
!include $(OSDK)\make\engine.nmk
#\
!else
include $(OSDK)/make/engine.mk
#\
!endif

