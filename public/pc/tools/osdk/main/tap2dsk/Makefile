CC=gcc
CFLAGS=-c -Wall -Iincludes -I../common/includes/
LDFLAGS=-lcurses
SOURCES=sources/tap2dsk.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=tap2dsk

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.c.o:
	$(CC) $(CFLAGS) $< -o $@

