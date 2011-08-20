# dxa makefile
# marko's originally, hacked up by cameron

TARGET = dxa
OBJECTS = scan.o vector.o dump.o table.o label.o main.o
VERSION = 0.1.3

# choose the compiler and flags

CC = gcc
CFLAGS = -Wall -Wmissing-prototypes -O6
#CFLAGS = -Wall -Wmissing-prototypes -ggdb

#CC = cc
#CFLAGS = -O
#CFLAGS = -O2

all: $(TARGET)

$(TARGET) : $(OBJECTS)
	$(CC) $(LDFLAGS) -o $@ $(OBJECTS)

scan.o : structures.h proto.h options.h opcodes.h
vector.o : structures.h proto.h options.h
dump.o : structures.h proto.h options.h opcodes.h
table.o : structures.h proto.h
label.o : structures.h proto.h
main.o : structures.h proto.h options.h opcodes.h

clean:
	rm -f $(OBJECTS) $(TARGET) core

dist: clean
	cd ..;tar cvf dxa-$(VERSION).tar dxa-$(VERSION);gzip dxa-$(VERSION).tar
