## OSDK Generic Makefile v0.1 ##
#
# Directives for use:
# - copy this template file to your project folder.
# - fill in the variables below.
#   - alternatively if leave them blank but have an osdk_config.bat
#     it will generate an osdk_config.mk file from it for later use.
#     In this case run make once (or nmake in windows)
# - you can now run make (or nmake in Windows)
#   from the project folder at the command line:
#   - make			without arguments will build the binary
#   - make clean	will clean the binary and temporary files
#   - make test		will run the binary in the default emulator
#   - make te		will run the binary in Euphoric if available
#   - make to		will run the binary in Oricutron

#
# specify the program name (without extension, no space)
# NAME=mydemo
NAME=A0XB

#
# specify the type of binary
# 	TAPE:	Tape image (default)
#	DISK:	Disk image
# TYPE=TAPE
TYPE=DISK

#
# specify the load address (in hex, no prefix)
# ADDR=600
ADDR=500

#
# specify the source files (without extension)
# FILES=main foo bar ...
FILES= \
	main \
	player \
	font \
	scroller \
	vipsplash \
	chars gadgets boing logoa0xb3
#	Tunnel \
#	costbl \
#	logovip3 logoua3 \
#	chars \
#	unpack \
#	misc \
#	vipsplash

#
# specify extra preprocessor defines (optional)
# DEFINES=-Dfoo=bar -DUSE_BAR ...
DEFINES=

#
#
## No user serviceable part beyond this point ##
#
#

# MAGIC: DO NOT TOUCH
#\
!ifdef COMSPEC
#\
!include $(OSDK)\make\engine.nmk
#\
!else
include $(OSDK)/make/engine.mk
#\
!endif
