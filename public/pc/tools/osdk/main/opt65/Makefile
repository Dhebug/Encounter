CC=gcc
CFLAGS=-c -Wall -Iincludes -I../common/includes/
LDFLAGS=-lcurses
SOURCES=sources/opt65.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=opt65

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.c.o:
	$(CC) $(CFLAGS) $< -o $@

