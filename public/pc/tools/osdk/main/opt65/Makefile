include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes
CPPFLAGS += -Wno-unknown-pragmas

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/opt65.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=opt65$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

