SUBDIRS := unittestcpp

all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS); \
	done

