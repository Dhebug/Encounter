SUBDIRS := compression_test  hello_world_advanced  hello_world_simple  hires_draw  hires_picture

all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done

