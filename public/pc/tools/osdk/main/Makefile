SUBDIRS := common \
	compiler \
	link65 \
	pictconv \
	bas2tap filepack opt65 tap2dsk Ym2Mym bin2txt \
	FloppyBuilder MemMap TapTool DskTool header \
	macrosplitter tap2cd xa


all install clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done

