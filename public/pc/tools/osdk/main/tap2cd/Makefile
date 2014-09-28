include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes
CPPFLAGS += -Wno-deprecated-declarations

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/tap2cd.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=tap2cd$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

