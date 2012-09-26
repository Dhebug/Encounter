SUBDIRS := shared_libraries tools

all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS); \
	done

