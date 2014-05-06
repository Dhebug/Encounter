CC=g++
CFLAGS=-c -Wall -Iincludes -I../common/includes/ -std=c++11
LDFLAGS=-L../common/ -lcommon ../common/common.o ../common/lz_pack.o -lcurses
SOURCES=sources/xaa.cpp   \
	sources/xa.cpp    \
	sources/xal.cpp   \
    	sources/xam.cpp   \
      	sources/xao.cpp   \
        sources/xap.cpp   \
	sources/xar2.cpp  \
	sources/xar.cpp   \
	sources/xat.cpp   \
	sources/xau.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=xa

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.cpp.o:
	$(CC) $(CFLAGS) $< -o $@

