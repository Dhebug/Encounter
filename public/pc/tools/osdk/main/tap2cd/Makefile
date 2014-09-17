CC=gcc
CFLAGS=-c -Wall -Iincludes -I../common/includes/ -Wno-deprecated-declarations
LDFLAGS=-lcurses
SOURCES=sources/tap2cd.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=tap2cd

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.c.o:
	$(CC) $(CFLAGS) $< -o $@

