include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes
CPPFLAGS += -Wno-unknown-pragmas

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/memmap.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=memmap$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

