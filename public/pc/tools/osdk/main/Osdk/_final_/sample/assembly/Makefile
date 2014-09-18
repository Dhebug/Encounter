SUBDIRS := demo_256_bytes  game_4kkong  hello_world_assembly

all clean:
	@for d in $(SUBDIRS); do \
		$(MAKE) -C "$$d" $(MAKECMDGOALS) || exit $?; \
	done


