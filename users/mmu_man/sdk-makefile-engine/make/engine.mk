#

$(info OSDK Makefile engine (GNU make) v0.1)

# quiet if =@
Q=@

# FIXME: check for wincrap
DS=/
#DS=/
#EXESUFF=.exe
#EXESUFF=

MAKEDIR=$(CURDIR)


CAT=type
#CAT=cat
DEVNULL=NUL
OSDKB = $(OSDK)\bin
OSDKCPP=$(OSDKB)\cpp
OSDKCOMPILER=$(OSDKB)\compiler
OSDKLINK65=$(OSDKB)\link65
OSDKXA=$(OSDKB)\xa
OSDKMACROSPLITTER=$(OSDKB)\macrosplitter
#OSDK=$(OSDKB)/cpp$(EXESUFF)

# function to $(call) to fix the path for windows...
fixpath = $(subst /,\,$(1))
#fixpath = $(1)


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
endif

ifeq ($(TYPE),TAPE)
EXT=tap
else ifeq ($(TYPE),DISK)
EXT=dsk
else
$(error Invalid TYPE $(TYPE))
endif


# try to autodetect Euphoric
ifeq ($(EUPHORIC),)
ifneq ($(wildcard $(OSDK)/euphoric/euphoric.exe),)
EUPHORIC = $(OSDK)/euphoric/euphoric.exe
else
ifneq ($(wildcard $(OSDK)/../euphoric/euphoric.exe),)
EUPHORIC = $(OSDK)/../euphoric/euphoric.exe
else
ifneq ($(wildcard C:/PROGRA~1/euphoric/euphoric.exe),)
EUPHORIC = C:/PROGRA~1/euphoric/euphoric.exe
endif
endif
endif
endif

# try to autodetect Oricutron
ifeq ($(ORICUTRON),)
ifneq ($(wildcard $(OSDK)/oricutron/oricutron.exe),)
ORICUTRON = $(OSDK)/oricutron/oricutron.exe
else
ifneq ($(wildcard $(OSDK)/../oricutron/oricutron.exe),)
ORICUTRON = $(OSDK)/../oricutron/oricutron.exe
else
ifneq ($(wildcard C:/PROGRA~1/oricutron/oricutron.exe),)
ORICUTRON = C:/PROGRA~1/oricutron/oricutron.exe
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

BUILDDIR=$(MAKEDIR)/BUILD

OBJS := $(addsuffix .os,$(addprefix BUILD/,$(FILES)))

.SUFFIXES: .s

# build rules
#.os = output asm

# from .c
BUILD/%.os: %.c
	@echo Compiling $<
	@echo   - preprocess
	$(Q)$(OSDKCPP) -lang-c++ $(CPPFLAGS) -nostdinc $(<) $(call fixpath,$@.c1)
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
	$(Q)copy $< $(call fixpath,$@) /Y >NUL
#	$(Q)$(CAT) $< > $@


BUILD/%.os: %.s
	@echo Assembling $<
	$(Q)copy $< $(call fixpath,$@) /Y >NUL
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
	$(Q)$(OSDKXA) BUILD/linked.s -o BUILD/final.out -e BUILD/xaerr.txt -l BUILD/symbols -bt $$$(ADDR)
	$(Q)$(OSDKB)/header $(OSDKHEAD) build/final.out BUILD/$(NAME).tap $$$(ADDR)
ifeq ($(TYPE),DISK)
	$(Q)-$(OSDKB)/tap2dsk BUILD/$(NAME).tap $@
endif
	@echo Build of $(@F) finished

#XXX: tap2dsk doesn't return anything so return value is random!!!

#	echo > $@

test-euphoric: $(BUILDDIR)/$(REALTARGET)
	$(Q)$(EUPHORIC) $(BUILDDIR)/$(REALTARGET)
	@cls
# Euphoric usually puts some garbage in the console when on white bg,
# so clear the screen on exit

test-oricutron: $(BUILDDIR)/$(REALTARGET)
	$(Q)cd /d $(call fixpath,$(dir $(ORICUTRON))) && $(call fixpath,$(ORICUTRON)) -s "$(call fixpath,$(BUILDDIR)/symbols)" "$(call fixpath,$(BUILDDIR)/$(REALTARGET))"


test: test-$(EMULATOR)

ifeq ($(BREAKPOINT),)
BREAKPOINT=_main
endif

debug-oricutron: $(BUILDDIR)/$(REALTARGET)
	$(Q)cd /d $(call fixpath,$(dir $(ORICUTRON))) && $(call fixpath,$(ORICUTRON)) -s "$(BUILDDIR)/symbols" "$(BUILDDIR)/$(REALTARGET)" -r "$(BREAKPOINT)"

debug: debug-oricutron

release: $(BUILDDIR)/$(REALTARGET)
	@echo Generating dist files
	@-mkdir REL
	@-mkdir "REL/$(NAME)"
	@copy /Y $(BUILDDIR)/$(REALTARGET) "REL/$(NAME)/"
#TODO: generate the .nfo

zip: release
#XXX: merge ?
# http://superuser.com/questions/110991/can-you-zip-a-file-from-the-command-prompt-using-only-windows-built-in-capabili


clean:
	@echo Cleaning up...
	@-del /f $(call fixpath, $(wildcard $(addprefix $(BUILDDIR)/,*.os.c1 *.os.c2 *.os.s1 *.os symbols final.out xaerr.txt linked.s $(NAME).tap $(NAME).dsk))) 2>$(DEVNULL)
	@-rd BUILD 2>$(DEVNULL)

#DEBUG:
dumpenv:
	@echo CPPFLAGS=$(CPPFLAGS)
	@echo OBJS=$(OBJS)

#echo del osdk_config.mk

# shortcuts
te: test-euphoric
to: test-oricutron


help:
	@echo possible targets:
	@echo all (default): generate the binary
	@echo clean: remove files
	@echo test: test with the default emulator ($(EMULATOR))
	@echo te, test-euphoric:	test with Euphoric
	@echo to, test-oricutron:	test with Oricutron
#	@echo release:	generate a release zip file (TODO)




