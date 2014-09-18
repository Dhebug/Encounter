SUBDIRS := assembly c mixed

all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done

