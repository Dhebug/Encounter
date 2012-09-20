## OSDK Generic Makefile v0.1 ##

# program name (no ext, no space)
NAME=

# target type
# TAPE	(tape image, default)
# DISK	(disk image)
TYPE=

# load address (in hex)
ADDR=

# source files (no ext)
FILES=

# optional defines (-Dfoo=bar)
DEFINES=

## No user serviceable part beyond this point ##

# MAGIC: DO NOT TOUCH
#\
!if "$(MAKE)" == "NMAKE"
#\
!include $(OSDKMKENGINE)
#\
!else
include $(OSDKMKENGINE)
#\
!endif

