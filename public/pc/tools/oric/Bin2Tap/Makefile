SRCDIR := Source
BINDIR := Bin
BINS := Bin2Tap$(EXE) Bin2TapD$(EXE)
SRCS := Bin2Tap.cpp CommandLine.cpp OricBinaryTapeImage.cpp \
	PulseWaveWriter.cpp  TapeWriter.cpp
#                       stdafx.cpp

SRCS := $(addprefix $(SRCDIR)/, $(SRCS))
BINS := $(addprefix $(BINDIR)/, $(BINS))
OBJS := $(subst .cpp,.o,$(SRCS))

all: $(BINS)


clean:
	rm -f $(BINS)

Bin/Bin2Tap$(EXE): Bin/Bin2TapD$(EXE)
	strip -o $@ $<

Bin/Bin2TapD$(EXE): $(OBJS)
	$(LINK.c) -o $@ $<


