where-am-i = $(CURDIR)/$(word $(words $(MAKEFILE_LIST)),$(MAKEFILE_LIST))
THIS_MAKEFILE := $(call where-am-i)
#$(warning $(THIS_MAKEFILE))

export ROOT := $(dir $(THIS_MAKEFILE))
$(info ROOT $(ROOT))


all: 
	@$(MAKE) -f arch.mk ARCH="Linux-x86_64" ROOT=$(ROOT)
	@$(MAKE) -f arch.mk ARCH="Linux-armv6l" ROOT=$(ROOT)
	@$(MAKE) -f arch.mk ARCH="Linux-armv7l" ROOT=$(ROOT)

#	@$(MAKE) -f arch.mk ARCH="Linux-x86" ROOT=$(ROOT)



install:
	@$(MAKE) -f arch.mk ARCH="Linux-x86_64" ROOT=$(ROOT) install
	@$(MAKE) -f arch.mk ARCH="Linux-armv6l" ROOT=$(ROOT) install
	@$(MAKE) -f arch.mk ARCH="Linux-armv7l" ROOT=$(ROOT) install

clean:
	@$(MAKE) -f arch.mk ARCH="Linux-x86_64" ROOT=$(ROOT) clean
	@$(MAKE) -f arch.mk ARCH="Linux-armv6l" ROOT=$(ROOT) clean
	@$(MAKE) -f arch.mk ARCH="Linux-armv7l" ROOT=$(ROOT) clean


.PHONY : clean
