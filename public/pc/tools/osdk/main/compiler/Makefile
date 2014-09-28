include ../../../rules.mk

CPPFLAGS += -Iincludes -DPOSIX

SOURCES=sources/dag.c    \
	sources/debug.c  \
 	sources/decl.c   \
	sources/enode.c  \
	sources/error.c  \
	sources/expr.c   \
	sources/gen.c    \
	sources/init.c   \
	sources/input.c  \
	sources/lex.c    \
	sources/main.c   \
	sources/output.c \
	sources/profio.c \
	sources/simp.c   \
	sources/stmt.c   \
	sources/string.c \
	sources/sym.c    \
	sources/tree.c   \
	sources/types.c

OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=compiler$(EXE)

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(LINK.o) $^ $(LOADLIBES) $(LDLIBS) -o $@

clean:
	rm -f $(EXECUTABLE) $(OBJECTS)

