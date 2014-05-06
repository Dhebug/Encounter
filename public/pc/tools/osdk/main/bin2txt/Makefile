CC=g++
CFLAGS=-c -Wall -Iincludes -I../common/includes/ -std=c++11
LDFLAGS=-L../common/ -lcommon ../common/common.o -lcurses
SOURCES=sources/bin2txt.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=bin2txt

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

