include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/bin2txt.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=bin2txt$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

