include	../host.mk

INSTALL_PATH=$(NFS_PATH)
BUILD_SCRIPT=build-kernel.sh

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

KERNEL_VERSION=3.14.4
KERNEL=linux-$(KERNEL_VERSION)
# KERNEL_DIR=$(TOPDIR)/$(KERNEL)
KERNEL_DIR=$(KERNEL)
KERNEL_SRC=$(KERNEL).tar.xz

KERNEL_IMAGE_DIR=$(KERNEL_DIR)/arch/arm/boot

KERNEL_IMAGE=zImage
KERNEL_DT=am335x-boneblack.dtb

KERNEL_ENV=uEnv.txt

SRC_URI=https://www.kernel.org/pub/linux/kernel/v3.x

MACHINE_CONFIG=$(KERNEL_DIR)/.config
BOARD_CONFIG=omap2plus_defconfig

all:	setup	$(TARGETS)	environment

source:		$(KERNEL_DIR)

environment:	$(KERNEL_ENV)

configure:	$(MACHINE_CONFIG)

compile:	deploy/.kernel deploy/.modules

tftp:
	install	-m 0755	deploy/$(KERNEL_IMAGE)	/tftpboot
	install	-m 0755	deploy/$(KERNEL_DT)	/tftpboot

install:	compile	$(NFS_PATH)
	@echo	"install	-d	$(NFS_PATH)/boot"				>>	$(BUILD_SCRIPT)
	install	-d	$(NFS_PATH)/boot
	@echo	"install	-m 0755	deploy/$(KERNEL_IMAGE)	$(NFS_PATH)/boot"	>>	$(BUILD_SCRIPT)
	install	-m 0755	deploy/$(KERNEL_IMAGE)	$(NFS_PATH)/boot
	@echo	"install	-m 0755	deploy/$(KERNEL_DT)	$(NFS_PATH)/boot"	>>	$(BUILD_SCRIPT)
	install	-m 0755	deploy/$(KERNEL_DT)	$(NFS_PATH)/boot
	@echo	"$(MAKE) -C $(KERNEL_DIR) INSTALL_MOD_PATH=$(NFS_PATH) modules_install"	>>	$(BUILD_SCRIPT)
	sudo $(MAKE) -C $(KERNEL_DIR) ARCH=arm INSTALL_MOD_PATH=$(INSTALL_PATH) modules_install
	sudo chmod	-R 777	$(INSTALL_PATH)
	chmod	a+x	$(BUILD_SCRIPT)

setup:
	echo	"#!/bin/sh"						>	$(BUILD_SCRIPT)

$(KERNEL_SRC):
	@echo	"wget	$(SRC_URI)/$(KERNEL_SRC)"			>>	$(BUILD_SCRIPT)
	wget	$(SRC_URI)/$(KERNEL_SRC)
	touch	$@

$(KERNEL_DIR)/.extracted:	$(KERNEL_SRC)
	@echo	"tar	-Jxvf	$(KERNEL_SRC)"				>>	$(BUILD_SCRIPT)
	tar	-Jxvf	$(KERNEL_SRC)
	touch	$@

$(MACHINE_CONFIG):	$(KERNEL_DIR)/.extracted
	@echo	"$(MAKE) -C $(KERNEL_DIR)	$(BOARD_CONFIG)"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(KERNEL_DIR)	$(BOARD_CONFIG)

$(KERNEL_IMAGE_DIR)/$(KERNEL_IMAGE):	$(MACHINE_CONFIG)
	@echo	"$(MAKE) -C $(KERNEL_DIR)	LOADADDR=0x80008000 $@"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(KERNEL_DIR)	LOADADDR=0x80008000 $(KERNEL_IMAGE)

$(KERNEL_IMAGE_DIR)/dts/$(KERNEL_DT):	$(KERNEL_IMAGE_DIR)/$(KERNEL_IMAGE)
	@echo	"$(MAKE) -C $(KERNEL_DIR)	dtbs"			>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(KERNEL_DIR)	dtbs
	cp	$(KERNEL_DIR)/arch/arm/boot/dts/$(KERNEL_DT)	.

deploy/.modules:	$(KERNEL_IMAGE_DIR)/$(KERNEL_IMAGE)
	@echo	"$(MAKE) -C $(KERNEL_DIR)	modules"		>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(KERNEL_DIR)	modules
	touch	$@

deploy/.kernel:	$(KERNEL_IMAGE_DIR)/$(KERNEL_IMAGE) $(KERNEL_IMAGE_DIR)/dts/$(KERNEL_DT)
	@echo	"mkdir	-p					deploy"	>>	$(BUILD_SCRIPT)
	mkdir	-p					deploy
	@echo	"cp	$(KERNEL_IMAGE_DIR)/$(KERNEL_IMAGE)	deploy"	>>	$(BUILD_SCRIPT)
	cp	$(KERNEL_IMAGE_DIR)/$(KERNEL_IMAGE)	deploy
	@echo	"cp	$(KERNEL_IMAGE_DIR)/dts/$(KERNEL_DT)	deploy"	>>	$(BUILD_SCRIPT)
	cp	$(KERNEL_IMAGE_DIR)/dts/$(KERNEL_DT)	deploy
	touch	$@

$(KERNEL_ENV):
	@echo		"ipaddr=$(IPADDR)"				>	$@
	@echo		"serverip=$(SERVER_IP)"				>>	$@
	@echo -n	"uenvcmd=tftp 80000000 zImage; "		>>	$@
	@echo -n	"tftp 81000000 am335x-boneblack.dtb; "		>>	$@
	@echo		"bootz 80000000 - 81000000;"			>>	$@

$(NFS_PATH):
	$(MAKE)	-C .. nfs

#	mkdir	-p	$(NFS_PATH)

prepare:	$(NFS_PATH)
	$(MAKE)	-C .. prepare

endif

endif

clean:
	rm	-fr	$(KERNEL_DIR)	$(KERNEL_IMAGE)	$(KERNEL_DT)
	rm	-fr	$(NFS_PATH)/boot/$(KERNEL_IMAGE)
	rm	-fr	$(NFS_PATH)/boot/$(KERNEL_DT)
	rm	-fr	$(NFS_PATH)/lib/modules
	rm	-f	*~
	rm	-f	$(BUILD_SCRIPT)

help:
	@echo "You need to have a valid arm-linux-gcc"
	@echo "CROSS_COMPILE needs to be defines"
	@echo "ARCH needs to be arm"

debug:
	@echo	MACHINE_CONFIG=$(MACHINE_CONFIG)
	@echo	KERNEL_IMAGE=$(KERNEL_IMAGE)
	@echo	KERNEL_DT=$(KERNEL_DT)
	@echo	$(MAKE) -C $(KERNEL_DIR)	$(BOARD_CONFIG)
	@echo	NFS_PATH=$(NFS_PATH)
	@echo	INSTALL_PATH="$(INSTALL_PATH)"
	@sudo echo	INSTALL_PATH="$(INSTALL_PATH)"

	
.PHONY:	clean help debug configure compile install source environment
