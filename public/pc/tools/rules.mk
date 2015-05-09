
RANLIB ?= ranlib

#HOSTOS := $(shell uname -s)
#PLATFORM ?= $(HOSTOS)

ifeq ($(RELEASE),)
DEBUG = 1
CPPFLAGS += -D_DEBUG
else
CPPFLAGS += -DNDEBUG
endif

MATH_LIBS ?= -lm

ifeq ($(PLATFORM),win32)
EXE = .exe
.SUFFIXES: .exe
CROSS_COMPILE ?= i586-mingw32msvc-
CC := $(CROSS_COMPILE)$(CC)
CXX := $(CROSS_COMPILE)$(CXX)
AR :=  $(CROSS_COMPILE)$(AR)
RANLIB :=  $(CROSS_COMPILE)$(RANLIB)
WINDRES := $(CROSS_COMPILE)windres
CPPFLAGS += -DWIN32

# add default rules for exe files
%.exe: %.o
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

%.exe: %.c
	$(LINK.c) $^ $(LOADLIBES) $(LDLIBS) -o $@

endif


ifneq ($(PLATFORM),win32)
CURSES_LIB ?= -lcurses
STDCXX_LIB ?= -lstdc++
COMMON_EXTRA_LDFLAGS += $(CURSES_LIB) $(STDCXX_LIB)
CXXSTD ?= -std=c++11
CXXFLAGS += $(CXXSTD)
CPPFLAGS += -D__cdecl=  -DPOSIX
CFLAGS   += -Wall
endif

