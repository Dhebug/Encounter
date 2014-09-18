# OSDK rules.mk for GNU Make
# Copyright (c) 2014 Jean-Yves Lamoureux <jylam@lnxscene.org>


# Path of the public/ directory (for instance /home/pennysbird/oric/public/)
# OSDKPATH  = /home/user/osdkpath

CPP       = cpp
CFLAGS   += -Wall
TOOLS     =$(OSDKPATH)/pc/tools/osdk/main/
AS        =$(TOOLS)/xa/xa
CC        =$(TOOLS)/compiler/compiler
LINKER    =$(TOOLS)/link65/link65
MSPLIT    =$(TOOLS)/macrosplitter/macrosplitter
BIN2TXT   =$(TOOLS)/bin2txt/bin2txt
FILEPACK  =$(TOOLS)/filepack/filepack
PICTCONV  =$(TOOLS)/pictconv/pictconv
LINKLIB   =$(TOOLS)/Osdk/_final_/lib/
OSDKINC   =$(TOOLS)/Osdk/_final_/include/
MACROS    =$(TOOLS)/Osdk/_final_/macro/MACROS.H
.PHONY: $(DATA)

ifndef OSDKPATH
$(warning **********************************************)
$(warning You must edit this file an fill OSDKPATH   ***)
$(warning **********************************************)
$(error )
endif

RUNBEFOREHACK:=$(shell rm -f $(BIN).final.s)

%.o: %.s
	cat $< >> $(BIN).final.s
%.o: %.c
	$(CPP) -traditional-cpp -I$(OSDKINC) $< -o .1$<
	# Remove C comments
	$(CPP) -xc++ .1$< -o .2$<
	# Compile
	$(CC) -O1 .2$< .3$<
	# Apply macros
	cpp -traditional-cpp -include $(MACROS) .3$< -o .1$<.s
	# Removes #'s
	grep -v '^#' .1$<.s > .2$<.s
	# Add \n after each assembly instruction
	$(MSPLIT) .2$<.s .3$<.s
	cat .3$<.s >> $(BIN).final.s

$(BIN): $(DATA) $(OBJ)
ifneq ($(NO_LINK),1)
	$(LINKER) -d $(LINKLIB) $(BIN).final.s -o .$(BIN).linked.s
else
		cp $(BIN).final.s .$(BIN).linked.s
endif
	$(AS) .$(BIN).linked.s -o $@.bin -bt 0x500 -C -W -v -l symbols.txt
	$(TOOLS)/header/header -a1 $(BIN).bin $(BIN).tap 0x500
	chmod +x $(BIN).tap
clean:
	rm -f $(BIN) $(DATA) *.tap *.bin symbols.txt .*.c .*.s

