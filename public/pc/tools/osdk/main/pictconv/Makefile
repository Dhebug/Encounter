include ../../../rules.mk

CPPFLAGS += -I ../common/includes

FI_PATH := ../../../../shared_libraries/freeimage/v3.12.0
CPPFLAGS += -I $(FI_PATH)/Dist
LDFLAGS += -L $(FI_PATH)/Dist -lfreeimage

LDFLAGS += -lstdc++
LDFLAGS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES := $(notdir $(wildcard sources/*.cpp) $(wildcard sources/Tests/*.cpp))
VPATH = sources sources/Tests
CPPFLAGS += -I sources -I includes
OBJS := $(subst .cpp,.o,$(SOURCES))
#OBJS := $(SOURCES:.cpp,.o)

all: pictconv$(EXE)

pictconv$(EXE): $(OBJS)
	$(LINK.c) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -f pictconv$(EXE) $(OBJS)
