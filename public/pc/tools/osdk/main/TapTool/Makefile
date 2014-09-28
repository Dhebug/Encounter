include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes
CPPFLAGS += -Wno-unknown-pragmas -Wno-deprecated-declarations

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/TapTool.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=TapTool$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

