include	../host.mk

BUILD_SCRIPT=build-busybox.sh

TOPDIR=`pwd`
TARGETS=install
MAKE=make $(XMAKEFLAGS)

ifneq ("$(ARCH)","arm")
TARGETS=help
configure:	help
compile:	help
install:	help
else

ifndef CROSS_COMPILE
TARGETS=help
configure:	help
compile:	help
install:	help
else


SRC_URI=http://www.busybox.net/downloads/
BUSYBOX_VERSION=1.21.1
BUSYBOX=busybox-$(BUSYBOX_VERSION)
BUSYBOX_SRC=$(BUSYBOX).tar.bz2
BUSYBOX_DIR=$(BUSYBOX)

MACHINE_CONFIG=$(BUSYBOX_DIR)/.config
BOARD_CONFIG=data/$(BUSYBOX).config
BUSYBOX_IMAGE=busybox

all:	setup	$(TARGETS)

configure:	$(MACHINE_CONFIG)

compile:	$(BUSYBOX_IMAGE)

install:	compile $(NFS_PATH)
	@echo	""	>>	$(BUILD_SCRIPT)
	chmod	a+x	$(BUILD_SCRIPT)

source:		$(BUSYBOX_DIR)

setup:
	echo	"#!/bin/sh"						>	$(BUILD_SCRIPT)

$(BUSYBOX_SRC):
	@echo	"wget	$(SRC_URI)/$(BUSYBOX_SRC)"			>>	$(BUILD_SCRIPT)
	wget	$(SRC_URI)/$(BUSYBOX_SRC)
	touch	$@

$(BUSYBOX_DIR)/.extracted:	$(BUSYBOX_SRC)
	@echo	"tar	-jxvf	$(BUSYBOX_SRC)"				>>	$(BUILD_SCRIPT)
	tar	-jxvf	$(BUSYBOX_SRC)
	touch	$@

$(MACHINE_CONFIG):	$(BOARD_CONFIG)	$(BUSYBOX_DIR)/.extracted
	cp	$(BOARD_CONFIG)	$(MACHINE_CONFIG)

$(BUSYBOX_IMAGE):	$(MACHINE_CONFIG)
	$(MAKE) -C $(BUSYBOX_DIR)

endif
endif

nfs:
	mkdir -p	$(NFS_PATH)
	@echo		"$(NFS_PATH) $(IPADDR)(rw,no_root_squash,no_subtree_check)"	> etc_export

restart-nfs:
	sudo	service nfs-BUSYBOX-server restart

uEnv.txt:
	@echo	"console=console=ttyO2,115200"		>	$@
	@echo	"ipaddr=$(IPADDR)"			>>	$@
	@echo	"serverip=$(SERVER_IP)"			>>	$@
	@echo	"nfsroot=$(NFS_PATH)"			>>	$@
	@echo	"bootargs=\$${console} root=/dev/nfs ip=\$${ipaddr} nfsroot=\$${serverip}:\$${nfsroot} rw"		>>	$@



clean:
	rm	-f	uEnv.txt	etc_export

help:
	@echo "You need to have a valid arm-linux-gcc"
	@echo "CROSS_COMPILE needs to be defines"
	@echo "ARCH needs to be arm"

debug:
	@echo	MACHINE_CONFIG=$(MACHINE_CONFIG)
	@echo	KERNEL_IMAGE=$(KERNEL_IMAGE)
	@echo	KERNEL_DT=$(KERNEL_DT)
	@echo	$(MAKE) -C $(KERNEL_DIR)	$(BOARD_CONFIG)
	@echo	TARGETS=$(TARGETS)

.PHONY:	clean help debug configure compile install source

