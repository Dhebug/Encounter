SUBDIRS := common \
	compiler \
	link65 \
	pictconv \
	bas2tap filepack opt65 tap2dsk Ym2Mym bin2txt \
	FloppyBuilder MemMap TapTool DskTool header \
	macrosplitter tap2cd xa


all install clean::
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done

# copy OSDK files and fix some ugly casing with symlinks
install::
	@echo "Installing OSDK files..."
	cp -a Osdk/_final_/documentation $(OSDK)/
	cp -a Osdk/_final_/include $(OSDK)/
	cp -a Osdk/_final_/lib $(OSDK)/
	cp -a Osdk/_final_/macro $(OSDK)/
	cp -a Osdk/_final_/Roms $(OSDK)/
	cp -a Osdk/_final_/sample $(OSDK)/
	cp -a Osdk/_final_/TMP $(OSDK)/
	cp -a Osdk/_final_/"read me.txt" $(OSDK)/
	ln -sfn bin $(OSDK)/Bin
	ln -sfn MACROS.H $(OSDK)/macro/macros.h
	ln -sfn Roms $(OSDK)/roms
	ln -sfn TMP $(OSDK)/tmp
# install ? extra
