#

$(info OSDK Makefile engine (GNU make) v0.1)

# quiet if =@
# verbose if =
Q=@

# XXX: ifdef COMSPEC ?
ifeq ($(OS),Windows_NT)
$(info Detected Windows OS type)
# useful ? DS=/
DS=\\
EXESUFF=.exe
CAT=type
CDD=cd /d
CLEAR=cls
COPY=copy /Y
RMF=del /F
RMR=del /S
RMDIR=rd
DEVNULL=NUL
OSDKB = $(OSDK)\bin
OSDKT = $(OSDK)\tmp
OSDKCPP=$(OSDKB)\cpp
OSDKCOMPILER=$(OSDKB)\compiler
OSDKLINK65=$(OSDKB)\link65
OSDKXA=$(OSDKB)\xa
OSDKMACROSPLITTER=$(OSDKB)\macrosplitter
#OSDK=$(OSDKB)/cpp$(EXESUFF)
WWWBROWSER=explorer

# function to $(call) to fix the path for windows...
fixpath = $(subst /,\,$(1))
else
EXESUFF=
DS=/
CAT=cat
CDD=cd
CLEAR=clear
COPY=cp -f
RMF=rm -f
RMR=rm -R
RMDIR=rmdir
DEVNULL=/dev/null
OSDKB = $(OSDK)/bin
OSDKT = $(OSDK)/tmp
OSDKCPP=$(shell which cpp)
OSDKCOMPILER=$(OSDKB)/compiler
OSDKLINK65=$(OSDKB)/link65
OSDKXA=$(OSDKB)/xa
OSDKMACROSPLITTER=$(OSDKB)/macrosplitter
#OSDK=$(OSDKB)/cpp$(EXESUFF)
WWWBROWSER=xdg-open

# function to $(call) to fix the path for windows...
fixpath = $(1)
endif

# Try to get infos from osdk_config.bat
ifeq ($(NAME),)
ifeq ($(wildcard osdk_config.bat),osdk_config.bat)
$(info Extracting infos from osdk_config.bat...)
$(info $(shell grep OSDKNAME osdk_config.bat))
else
$(error No NAME given in makefile and no osdk_config.bat)
endif
endif

ifeq ($(NAME),)
# try to find the info elsewhere
-include osdk_config.mk
endif



ifeq ($(NAME),)
$(error No NAME given in makefile and no osdk_config.bat)
endif

ifeq ($(TYPE),)
TYPE = TAPE
$(info No TYPE defined, defaulting to $(TYPE))
endif

ifeq ($(TYPE),TAPE)
EXT=tap
else ifeq ($(TYPE),DISK)
EXT=dsk
ORICUTRONFLAGS += -km -d
else
$(error Invalid TYPE $(TYPE))
endif

ifeq ($(ADDR),)
ADDR=600
$(info No ADDR defined, defaulting to 0x$(ADDR))
endif

# try to autodetect Euphoric
ifeq ($(EUPHORIC),)
ifneq ($(wildcard $(OSDK)/euphoric/euphoric$(EXESUFF)),)
EUPHORIC = $(OSDK)/euphoric/euphoric$(EXESUFF)
else
ifneq ($(wildcard $(OSDK)/../euphoric/euphoric$(EXESUFF)),)
EUPHORIC = $(OSDK)/../euphoric/euphoric$(EXESUFF)
else
ifneq ($(wildcard C:/PROGRA~1/euphoric/euphoric$(EXESUFF)),)
EUPHORIC = C:/PROGRA~1/euphoric/euphoric$(EXESUFF)
endif
endif
endif
endif

# try to autodetect Oricutron
ifeq ($(ORICUTRON),)
ifneq ($(wildcard $(OSDK)/oricutron/oricutron$(EXESUFF)),)
ORICUTRON = $(OSDK)/oricutron/oricutron$(EXESUFF)
else
ifneq ($(wildcard $(OSDK)/../oricutron/oricutron$(EXESUFF)),)
ORICUTRON = $(OSDK)/../oricutron/oricutron$(EXESUFF)
else
ifneq ($(wildcard C:/PROGRA~1/oricutron/oricutron$(EXESUFF)),)
ORICUTRON = C:/PROGRA~1/oricutron/oricutron$(EXESUFF)
else
ORICUTRON = oricutron
endif
endif
endif
endif


ifeq ($(EMULATOR),)
EMULATOR = oricutron
$(info Using $(EMULATOR) as default emulator)
endif


# system defines
# the -DATMOS is for Contiki
SYSDEFINES = -D__16BIT__ -D__NOFLOAT__ -DATMOS
CPPFLAGS += -I $(call fixpath,$(OSDK)/include)
CPPFLAGS += $(SYSDEFINES) $(DEFINES)
OPTIMIZE ?= -O2
CFLAGS += $(OPTIMIZE)

REALTARGET=$(NAME).$(EXT)

BUILDDIR=$(CURDIR)/BUILD

OBJS := $(addsuffix .os,$(addprefix BUILD/,$(FILES)))

.SUFFIXES: .s

# build rules
#.os = output asm

# from .c
BUILD/%.os: %.c
	@echo Compiling $<
	@echo   - preprocess
	$(Q)$(OSDKCPP) -lang-c++ $(CPPFLAGS) -nostdinc $(<) -o $(call fixpath,$@.c1)
	@echo   - compile
	$(Q)$(OSDKCOMPILER) -N$(basename $(notdir $@)) $(CFLAGS) $(call fixpath,$@.c1) >$@.c2
	@echo   - convert C to assembly code
	$(Q)$(OSDKCPP) -lang-c++ -imacros $(call fixpath,$(OSDK)/macro/macros.h) -traditional -P $(call fixpath,$@.c2) $(call fixpath,$@.s1)
	@echo   - cleanup output
	$(Q)$(OSDKMACROSPLITTER) $@.s1 $@

# This causes a stale open file VirtualBox on shared folders
# which can't be deleted until closing the cmd.
# workaround is to pipe type's output
#	@$(OSDKB)/tr < $@.s1 > $@


# from .s .asm

BUILD/%.os: %.asm
	@echo Assembling $<
	$(Q)$(COPY) $< $(call fixpath,$@)
#	$(Q)$(CAT) $< > $@


BUILD/%.os: %.s
	@echo Assembling $<
	$(Q)$(COPY) $< $(call fixpath,$@)
#	$(Q)$(CAT) $< > $@


$(info )


# targets

all: $(BUILDDIR) $(BUILDDIR)/$(REALTARGET)

$(BUILDDIR):
	@echo Building the program $(@F) at address 0x$(ADDR)
	$(Q)mkdir "$(BUILDDIR)"

#buildmsg: makefile
#	@echo Building the program $(@F) at address 0x$(ADDR)

# add headers as dependency
#$(OBJS): *.h

$(BUILDDIR)/$(REALTARGET): $(BUILDDIR) $(OBJS)
	@echo Linking
	$(Q)$(OSDKLINK65) $(OSDKLINK) -d $(OSDK)/lib/ -o BUILD/linked.s -f -q $(OBJS)
	@echo Assembling
	$(Q)$(OSDKXA) BUILD/linked.s -o BUILD/final.out -e BUILD/xaerr.txt -l BUILD/symbols -bt '$$$(ADDR)'
	$(Q)$(OSDKB)/header $(OSDKHEAD) BUILD/final.out BUILD/$(NAME).tap '$$$(ADDR)'
ifeq ($(TYPE),DISK)
	$(Q)-$(OSDKB)/tap2dsk -i"$(NAME)" BUILD/$(NAME).tap $@
	$(Q)-$(OSDKB)/old2mfm $@
# >$(DEVNULL)
endif
	@echo Build of $(@F) finished

#XXX: tap2dsk doesn't return anything so return value is random!!!
# 2015: not true anymore (in the code)

#	echo > $@

run-euphoric: $(BUILDDIR)/$(REALTARGET)
	$(Q)$(EUPHORIC) $(BUILDDIR)/$(REALTARGET)
	@$(CLEAR)
# Euphoric usually puts some garbage in the console when on white bg,
# so clear the screen on exit

run-oricutron: $(BUILDDIR)/$(REALTARGET)
	$(Q)cd $(call fixpath,$(dir $(ORICUTRON))) && $(call fixpath,$(ORICUTRON)) -s "$(call fixpath,$(BUILDDIR)/symbols)" $(ORICUTRONFLAGS) "$(call fixpath,$(BUILDDIR)/$(REALTARGET))"


test run: run-$(EMULATOR)

ifeq ($(BREAKPOINT),)
BREAKPOINT=_main
endif

debug-oricutron: $(BUILDDIR)/$(REALTARGET)
	$(Q)$(CDD) $(call fixpath,$(dir $(ORICUTRON))) && $(call fixpath,$(ORICUTRON)) -s "$(BUILDDIR)/symbols" $(ORICUTRONFLAGS) "$(BUILDDIR)/$(REALTARGET)" -r "$(BREAKPOINT)"

debug: debug-oricutron

showmap: $(BUILDDIR)/$(REALTARGET)
	$(Q)$(OSDKB)/memmap BUILD/symbols BUILD/map.htm "$(NAME)" $(OSDK)/documentation/documentation.css
	$(Q)$(WWWBROWSER) BUILD/map.htm

release: $(BUILDDIR)/$(REALTARGET)
	@echo Generating dist files
	@-mkdir REL
	@-mkdir "REL/$(NAME)"
	@$(COPY) $(BUILDDIR)/$(REALTARGET) "REL/$(NAME)/"
#TODO: generate the .nfo

zip: release
#XXX: merge ?
# http://superuser.com/questions/110991/can-you-zip-a-file-from-the-command-prompt-using-only-windows-built-in-capabili


clean:
	@echo Cleaning up...
#	@-$(RMR) BUILD
	@-$(RMF) $(call fixpath, $(wildcard $(addprefix $(BUILDDIR)/,*.os.c1 *.os.c2 *.os.s1 *.os symbols final.out xaerr.txt linked.s $(NAME).tap $(NAME).dsk)))
	@-$(RMDIR) BUILD

#DEBUG:
dumpenv:
	@echo CPPFLAGS=$(CPPFLAGS)
	@echo OBJS=$(OBJS)

#echo del osdk_config.mk

# shortcuts
te re: run-euphoric
to ro: run-oricutron


help:
	@echo "possible targets:"
	@echo "    all (default):	generate the binary"
	@echo "            clean:	remove files"
	@echo "              run:	test with the default emulator ($(EMULATOR))"
	@echo " re, run-euphoric:	test with Euphoric"
	@echo "ro, run-oricutron:	test with Oricutron"
	@echo "          showmap:	show memory map in web browser"
#	@echo "release:	generate a release zip file (TODO)"
	@echo




