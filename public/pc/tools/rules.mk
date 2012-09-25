
#HOSTOS := $(shell uname -s)
#PLATFORM ?= $(HOSTOS)

ifeq ($(PLATFORM),win32)
EXE = .exe
.SUFFIXES: .exe
CROSS_COMPILE ?= i586-mingw32msvc-
CC := $(CROSS_COMPILE)$(CC)
CXX := $(CROSS_COMPILE)$(CXX)
AR :=  $(CROSS_COMPILE)$(AR)
WINDRES := $(CROSS_COMPILE)windres

# add default rules for exe files
%.exe: %.o
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.exe: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

endif



