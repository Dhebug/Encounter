include ../../../rules.mk

CPPFLAGS += -I ../common/includes

FI_PATH := ../../../../shared_libraries/freeimage/v3.12.0
UT_PATH := ../../../../shared_libraries/unittestcpp/v1.4
CPPFLAGS += -I $(FI_PATH)/Dist
LDFLAGS += -L $(FI_PATH)/Dist -lfreeimage

LDFLAGS += -lstdc++
LDFLAGS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES := $(notdir $(wildcard sources/*.cpp))
ifneq ($(DEBUG),)
SOURCES += $(notdir $(wildcard sources/Tests/*.cpp))
CPPFLAGS += -I $(UT_PATH)/src
LDFLAGS += -L $(UT_PATH) -lUnitTest++
endif
VPATH = sources sources/Tests
CPPFLAGS += -I sources -I includes
OBJS := $(subst .cpp,.o,$(SOURCES))
#OBJS := $(SOURCES:.cpp,.o)

all: pictconv$(EXE)

pictconv$(EXE): $(OBJS)
	$(LINK.c) -o $@ $(OBJS) $(LDFLAGS)

clean:
	rm -f pictconv$(EXE) $(OBJS)
