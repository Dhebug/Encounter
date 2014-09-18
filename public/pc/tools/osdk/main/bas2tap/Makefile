include ../../../rules.mk

CPPFLAGS= -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDFLAGS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)
SOURCES=sources/bas2tap.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=bas2tap$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

