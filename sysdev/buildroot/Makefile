include	../host.mk

BUILD_SCRIPT=build-buildroot.sh

TOPDIR=`pwd`
TARGETS=install
MAKE=make

SRC_URI=http://www.buildroot.org/downloads/
# BUILDROOT_VERSION=2013.11
BUILDROOT_VERSION=2014.02
BUILDROOT=buildroot-$(BUILDROOT_VERSION)
BUILDROOT_SRC=$(BUILDROOT).tar.bz2
BUILDROOT_DIR=$(BUILDROOT)

MACHINE_CONFIG=$(BUILDROOT_DIR)/.config
BOARD_CONFIG=beaglebone_defconfig
IMAGE_DIR=$(BUILDROOT_DIR)/output/images
BUILDROOT_IMAGE=$(IMAGE_DIR)/rootfs.tar.gz

DEPLOY_DIR=deploy/$(BUILDROOT_VERSION)

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



all:	setup	$(TARGETS)

configure:	$(MACHINE_CONFIG)

compile:	$(BUILDROOT_IMAGE)

install:	compile $(NFS_PATH)
	@echo	"ln	-s	$(NFS_PATH)	$(BUILDROOT_DIR)/_install"	>>	$(BUILD_SCRIPT)
	ln	-s	$(NFS_PATH)	$(BUILDROOT_DIR)/_install
	@echo	"make	-C	$(BUILDROOT_DIR)	install"		>>	$(BUILD_SCRIPT)
	make	-C	$(BUILDROOT_DIR)	install
	chmod	a+x	$(BUILD_SCRIPT)

source:		$(BUILDROOT_DIR)/.extracted

setup:
	echo	"#!/bin/sh"							>	$(BUILD_SCRIPT)

$(BUILDROOT_SRC):
	@echo	"wget	$(SRC_URI)/$(BUILDROOT_SRC)"				>>	$(BUILD_SCRIPT)
	wget	$(SRC_URI)/$(BUILDROOT_SRC)
	touch	$@

$(BUILDROOT_DIR)/.extracted:	$(BUILDROOT_SRC)
	@echo	"tar	-jxvf	$(BUILDROOT_SRC)"				>>	$(BUILD_SCRIPT)
	tar	-jxvf	$(BUILDROOT_SRC)
	@echo	"mkdir	-p downloads"						>>	$(BUILD_SCRIPT)
	mkdir	-p downloads
	@echo	"ln	-s	../downloads	$(BUILDROOT_DIR)/dl"		>>	$(BUILD_SCRIPT)
	ln	-s	../downloads	$(BUILDROOT_DIR)/dl
	touch	$@

$(MACHINE_CONFIG):	$(BUILDROOT_DIR)/.extracted
	@echo	"$(MAKE) -C	$(BUILDROOT_DIR)	$(BOARD_CONFIG)"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C	$(BUILDROOT_DIR)	$(BOARD_CONFIG)
	@echo	"# Update your config manually"	>>	$(BUILD_SCRIPT)
	@echo	"# Here we use a modified config file"				>>	$(BUILD_SCRIPT)
	@echo	"cp	beaglebone.config $(BUILDROOT_DIR)/.config"		>>	$(BUILD_SCRIPT)
	cp	beaglebone.config		$(BUILDROOT_DIR)/.config

$(BUILDROOT_IMAGE):	$(MACHINE_CONFIG)
	@echo	"$(MAKE) -C $(BUILDROOT_DIR)"					>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(BUILDROOT_DIR)
	@echo	"cp	$(BUILDROOT_DIR)/output/boot/$(BUILDROOT_IMAGE)	$(BUILDROOT_IMAGE)"	>>	$(BUILD_SCRIPT)
	cp	$(BUILDROOT_DIR)/output/boot/$(BUILDROOT_IMAGE)	$(BUILDROOT_IMAGE)

$(DEPLOY_DIR):	uEnv.txt
	mkdir	-p	$(DEPLOY_DIR)
	cp	$(BUILDROOT_IMAGE)	$(DEPLOY_DIR)
	cp	$(IMAGE_DIR)/*.dtb	$(DEPLOY_DIR)
	cp	$(IMAGE_DIR)/MLO	$(DEPLOY_DIR)
	cp	$(IMAGE_DIR)/u-boot.img	$(DEPLOY_DIR)
	cp	$(IMAGE_DIR)/uImage	$(DEPLOY_DIR)
	cp	uEnv.txt		$(DEPLOY_DIR)

endif
endif

rootfs:	nfs install lib startup webserver

restart-nfs:
	sudo	service nfs-BUILDROOT-server restart

uEnv.txt:
	@echo	"console=console=ttyO2,115200"		>	$@
	@echo	"ipaddr=$(IPADDR)"			>>	$@
	@echo	"serverip=$(SERVER_IP)"			>>	$@
	@echo	"nfsroot=$(NFS_PATH)"			>>	$@
	@echo	"bootargs=\$${console} root=/dev/nfs ip=\$${ipaddr} nfsroot=\$${serverip}:\$${nfsroot} rw"		>>	$@

clean:
	rm	-fr	$(BUILDROOT_DIR)
	rm	-f	uEnv.txt
	rm	-f build-buildroot.sh
distclean:
	rm	-f	$(BUILDROOT).tar.bz2
	rm	-fr	downloads

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
	@echo	NFS_PATH=$(NFS_PATH)


.PHONY:	clean help debug configure compile install source

