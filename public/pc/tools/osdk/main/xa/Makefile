include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDLIBS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

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
EXECUTABLE=xa$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

