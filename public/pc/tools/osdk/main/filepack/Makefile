include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDFLAGS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/filepack.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=filepack$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

