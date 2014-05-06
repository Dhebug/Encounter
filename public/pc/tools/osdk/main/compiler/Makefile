CC=gcc
CFLAGS=-c -Wall -Iincludes
LDFLAGS=
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
EXECUTABLE=compiler

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@
clean:
	rm -f $(EXECUTABLE) $(OBJECTS)
.c.o:
	$(CC) $(CFLAGS) $< -o $@

