CC=g++
CFLAGS=-c -Wall -Iincludes -I../common/includes/ -std=c++11
LDFLAGS=-L../common/ -lcommon ../common/common.o ../common/lz_pack.o -lcurses
SOURCES=sources/filepack.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=filepack

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

