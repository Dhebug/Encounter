#NO_LIB=1

SRC=main.c picture.s
BIN=compression_test
OBJ=$(SRC:.c=.o)
DATA=picture.s

include ../../rules.mk

all: $(DATA) $(SRC) $(BIN)

picture.s:
	$(PICTCONV) -f1 -d0 -o2 ../../data/picture.png picture.hir
	$(FILEPACK) -p picture.hir picture.pak
	$(BIN2TXT)  -s1 -f2 picture.pak picture.s _LabelPicture
	cat picture.s >> $(BIN).final.s

clean::
	rm -f $(DATA) picture.hir picture.pak
