include ../../../rules.mk

CPPFLAGS += -Wall -Iincludes

CPPFLAGS += -I ../common/includes
LDFLAGS += -L ../common -lcommon $(COMMON_EXTRA_LDFLAGS)

SOURCES=sources/lzhlib.cpp  \
	sources/Ym2Mym.cpp

OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=Ym2Mym$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

