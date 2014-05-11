CC=g++
CFLAGS=-c -Wall -Iincludes -I../common/includes/ -std=c++11 -DPOSIX
LDFLAGS=-L../common/ -lcommon ../common/common.o -lcurses
SOURCES=sources/Link65.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=link65

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

