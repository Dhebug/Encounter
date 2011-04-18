#

BINS = bin2tap tap2bin

all: $(BINS)

bin2tap: bin2tap.c

# should use ln -s but some platforms don't support symlinks
tap2bin: bin2tap
	cp -p $< $@


clean:
	rm -f $(BINS)
