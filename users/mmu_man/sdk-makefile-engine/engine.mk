# 
$(info OSDK Makefile engine (GNU make) v0.1)

# Try to get infos from osdk_config.bat
ifeq ($(NAME),)
ifeq ($(wildcard osdk_config.bat),osdk_config.bat)
$(info Extracting infos from osdk_config.bat...)
$(info $(shell grep OSDKNAME osdk_config.bat))
else
$(error No NAME given in makefile and no osdk_config.bat)
endif
endif

TYPE ?= "TAPE"

$(info gnumake toto)

$(info Building $(NAME) at 0x$(ADDR)...)

all:
	echo $(MAKE)




