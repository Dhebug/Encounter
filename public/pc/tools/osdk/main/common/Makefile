include ../../../rules.mk

#LDFLAGS += -lstdc++

VPATH = sources
SOURCES := $(subst sources/,,$(wildcard sources/*.cpp))
OBJS := $(subst .cpp,.o,$(SOURCES))
CPPFLAGS += -I sources -I includes
CPPFLAGS += -D_LIB

all: libcommon.a

clean:
	rm -f libcommon.a *.o

libcommon.a: $(OBJS)
	$(AR) $(ARFLAGS) $@ $(^)

#	$(RANLIB) $@
