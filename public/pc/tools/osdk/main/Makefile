SUBDIRS := common compiler link65 pictconv bas2tap     common    filepack opt65 tap2dsk  Ym2Mym bin2txt compiler  FloppyBuilder  link65 MemMap TapTool  DskTool   header macrosplitter  pictconv        tap2cd          xa


all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done

