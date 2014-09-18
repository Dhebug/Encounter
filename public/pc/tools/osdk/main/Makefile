SUBDIRS := common \
	compiler \
	link65 \
	pictconv \
	bas2tap filepack opt65 tap2dsk Ym2Mym bin2txt \
	FloppyBuilder MemMap TapTool DskTool header \
	macrosplitter tap2cd xa \
	Osdk/_final_/sample


all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done

