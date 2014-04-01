include	../host.mk

BUILD_SCRIPT=build-u-boot.sh

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

UBOOT_VERSION=2013.10
UBOOT=u-boot-$(UBOOT_VERSION)
UBOOT_DIR=$(UBOOT)
PATCH_DIR=../data
UBOOT_SRC=$(UBOOT).tar.bz2

UBOOT_IMAGE=u-boot.img

SRC_URI=ftp://ftp.denx.de/pub/u-boot/

MACHINE_CONFIG=$(UBOOT_DIR)/.config
BOARD_CONFIG=beaglebone_defconfig

all:	setup	$(TARGETS)

download:	$(UBOOT_SRC)

unpack:		$(UBOOT_DIR)/.extracted

configure:	$(MACHINE_CONFIG)

compile:	$(UBOOT_IMAGE)	$(UBOOT_DT)

patched:	$(UBOOT_DIR)/.patched

install:	compile modules	$(NFS_PATH)
	install	-d	$(NFS_PATH)/boot
	install	-m 0755	$(UBOOT_IMAGE)	$(NFS_PATH)/boot
	install	-m 0755	$(UBOOT_DT)	$(NFS_PATH)/boot
	@echo	"$(MAKE) -C $(UBOOT_DIR) INSTALL_MOD_PATH=$(NFS_PATH) modules_install"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(UBOOT_DIR) INSTALL_MOD_PATH=$(NFS_PATH) modules_install
	chmod	a+x	$(BUILD_SCRIPT)

source:		$(UBOOT_DIR)

setup:
	echo	"#!/bin/sh"						>	$(BUILD_SCRIPT)

$(UBOOT_SRC):
	@echo	"wget	$(SRC_URI)/$(UBOOT_SRC)"			>>	$(BUILD_SCRIPT)
	wget	$(SRC_URI)/$(UBOOT_SRC)
	touch	$@

$(UBOOT_DIR)/.extracted:	$(UBOOT_SRC)
	@echo	"tar	-jxvf	$(UBOOT_SRC)"				>>	$(BUILD_SCRIPT)
	tar	-jxvf	$(UBOOT_SRC)
	touch	$@

$(UBOOT_DIR)/.git:	$(UBOOT_DIR)/.extracted
	@echo	"git	init; git add . ; git commit -m \"Initial Commit\" -s"	>>	$(BUILD_SCRIPT)
	(			\
	cd $(UBOOT_DIR) ;	\
	git init ;		\
	git add .;		\
	git commit -m "Initial Commit" -s	\
	)

$(UBOOT_DIR)/.patched:	$(UBOOT_DIR)/.git
	@echo	"git	am	$(PATCH_DIR)/0001-arm-omap-i2c-don-t-zero-cnt-in-i2c_write.patch"	>>	$(BUILD_SCRIPT)
	(cd	$(UBOOT_DIR) ;	\
	git	am	$(PATCH_DIR)/0001-arm-omap-i2c-don-t-zero-cnt-in-i2c_write.patch	\
	)
	touch	$@

$(MACHINE_CONFIG):	$(UBOOT_DIR)/.patched
	@echo	"$(MAKE) -C $(UBOOT_DIR)	$(BOARD_CONFIG)"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(UBOOT_DIR)	$(BOARD_CONFIG)

$(UBOOT_IMAGE):	$(MACHINE_CONFIG)
	@echo	"$(MAKE) -C $(UBOOT_DIR)"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(UBOOT_DIR)
	cp	$(UBOOT_DIR)/$(UBOOT_IMAGE)	.


$(NFS_PATH):
	$(MAKE)	-C .. nfs

#	mkdir	-p	$(NFS_PATH)

prepare:	$(NFS_PATH)
	$(MAKE)	-C .. prepare

endif

endif

clean:
	rm	-fr	$(UBOOT_DIR)	$(UBOOT_IMAGE)	$(UBOOT_DT)
	rm	-fr	$(NFS_PATH)/boot/$(UBOOT_IMAGE)
	rm	-fr	$(NFS_PATH)/boot/$(UBOOT_DT)
	rm	-fr	$(NFS_PATH)/lib/modules
	rm	-f	*~
	rm	-f	$(BUILD_SCRIPT)

help:
	@echo "You need to have a valid arm-linux-gcc"
	@echo "CROSS_COMPILE needs to be defines"
	@echo "ARCH needs to be arm"

debug:
	@echo	MACHINE_CONFIG=$(MACHINE_CONFIG)
	@echo	UBOOT_IMAGE=$(UBOOT_IMAGE)
	@echo	UBOOT_DT=$(UBOOT_DT)
	@echo	$(MAKE) -C $(UBOOT_DIR)	$(BOARD_CONFIG)
	@echo	
	
.PHONY:	clean help debug configure compile install source
