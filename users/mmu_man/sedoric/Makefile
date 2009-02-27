#!/bin/false
# not a script!


#tools
TAP2BIN=../lunix/lng/devel_utils/oric/tap2bin
DA65=da65
DA65OPTS=--hexoffs
XA=xa
STADDR=0xc400
STADDR:=$(shell echo $$(($(STADDR))))
XAOPTS=-M -bt $(STADDR) -bd $(STADDR) -v -l sedkern.labels.txt
CA2XA=ca2xa.sed

# files
TAP=SEDKERN.TAP
SEDBIN=SEDKERN.bin
SRC=sedkern.s
XASRC=sedkern.asm
XABIN=sedkern.xabin
INFOFILE=sedkern.dinfo
HD=hd
DIFF=diff


#$TAP2BIN $TAP

#$DA65 -i $INFOFILE -o sedkern.s SEDKERN.bin


all: disass

bin: $(XABIN)

$(XABIN): $(XASRC)
	$(XA) $(XAOPTS) $< -o $@


$(XASRC): $(SRC) $(CA2XA)
	sed -f $(CA2XA) $< > $@

disass: $(SRC)

$(SRC): $(TAP) $(INFOFILE)
	$(DA65) $(DA65OPTS) -i $(INFOFILE) -o $@


$(SEDBIN): $(TAP)
	$(TAP2BIN) $(TAP)

diff: $(XABIN) $(SEDBIN)
	-$(HD) $(XABIN) > $(XABIN).hd
	-$(HD) $(SEDBIN) > $(SEDBIN).hd
	$(DIFF) -s $(SEDBIN).hd $(XABIN).hd


clean:
	rm -f *.hd *.xabin *.bin *.s *.asm *.labels.txt




