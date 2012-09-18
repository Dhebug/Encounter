SUBDIRS := 4k8  old2mfm  txt2bas
#              Bin2Tap dsk  tap2dsk

all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS); \
	done

