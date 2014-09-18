include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDLIBS += -lstdc++ -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=FloppyBuilder.cpp  Floppy.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=FloppyBuilder$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

