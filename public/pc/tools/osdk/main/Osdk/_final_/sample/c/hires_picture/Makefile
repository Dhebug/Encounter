#NO_LIB=1

SRC=main.c picture.s
BIN=hires_picture
OBJ=$(SRC:.c=.o)
DATA=picture.s


include ../../rules.mk

all: $(SRC) $(BIN)

picture.s:
	$(PICTCONV) -f1 -d0 -o4 ../../data/picture.png picture.s
	cat picture.s >> $(BIN).final.s



