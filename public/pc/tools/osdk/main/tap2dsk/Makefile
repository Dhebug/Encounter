include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes
CPPFLAGS += -Wno-unknown-pragmas

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/tap2dsk.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=tap2dsk$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

