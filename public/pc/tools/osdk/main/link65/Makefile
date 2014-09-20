include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

CXXFLAGS += -Wno-unknown-pragmas

SOURCES=sources/Link65.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=link65$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

