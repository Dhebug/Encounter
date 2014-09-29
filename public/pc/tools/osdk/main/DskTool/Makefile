include ../../../rules.mk

CPPFLAGS= -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)
SOURCES=sources/DskTool.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=DskTool$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

