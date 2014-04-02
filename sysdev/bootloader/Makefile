include	../host.mk

BUILD_SCRIPT=build-u-boot.sh

TOPDIR=`pwd`
TARGETS=install
MAKE=make


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
UBOOT_PATCH=0001-arm-omap-i2c-don-t-zero-cnt-in-i2c_write.patch

UBOOT_ENV=uEnv.txt

UBOOT_IMAGE=u-boot.img

SRC_URI=ftp://ftp.denx.de/pub/u-boot

MACHINE_CONFIG=$(UBOOT_DIR)/include/autoconf.mk
BOARD_CONFIG=am335x_boneblack

all:	setup	$(TARGETS)	environment

download:	$(UBOOT_SRC)

unpack:		$(UBOOT_DIR)/.extracted

configure:	$(MACHINE_CONFIG)

compile:	$(UBOOT_DIR)/$(UBOOT_IMAGE)

patched:	$(UBOOT_DIR)/.patched

install:	$(UBOOT_DIR)/$(UBOOT_IMAGE)	
	@echo	"mkdir	-p	deploy"					>>	$(BUILD_SCRIPT)
	@echo	"cp	$(UBOOT_DIR)/$(UBOOT_IMAGE)	deploy"		>>	$(BUILD_SCRIPT)
	@echo	"cp	$(UBOOT_DIR)/MLO		deploy"		>>	$(BUILD_SCRIPT)
	mkdir	-p	deploy
	cp	$(UBOOT_DIR)/$(UBOOT_IMAGE)	deploy
	cp	$(UBOOT_DIR)/MLO		deploy
	chmod	a+x	$(BUILD_SCRIPT)

source:		$(UBOOT_DIR)

environment:	$(UBOOT_ENV)

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
	@echo	"cd	$(UBOOT_DIR)"					>>	$(BUILD_SCRIPT)
	@echo	"git	init"						>>	$(BUILD_SCRIPT)
	@echo	"git	add ."						>>	$(BUILD_SCRIPT)
	@echo	"git	commit -m \"Initial Commit\" -s"		>>	$(BUILD_SCRIPT)
	@echo	"cd	.."						>>	$(BUILD_SCRIPT)
	(			\
	cd $(UBOOT_DIR) ;	\
	git init ;		\
	git add .;		\
	git commit -m "Initial Commit" -s	\
	)

$(UBOOT_DIR)/.patched:	$(UBOOT_DIR)/.git
	@echo	"cd	$(UBOOT_DIR)"					>>	$(BUILD_SCRIPT)
	@echo	"git	am	$(PATCH_DIR)/$(UBOOT_PATCH)"		>>	$(BUILD_SCRIPT)
	@echo	"cd	.."						>>	$(BUILD_SCRIPT)
	(cd	$(UBOOT_DIR) ;					\
	git	am	$(PATCH_DIR)/$(UBOOT_PATCH)		\
	)
	touch	$@

$(MACHINE_CONFIG):	$(UBOOT_DIR)/.patched
	@echo	"$(MAKE)	-C $(UBOOT_DIR)	$(BOARD_CONFIG)_config"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(UBOOT_DIR)	$(BOARD_CONFIG)_config

$(UBOOT_DIR)/$(UBOOT_IMAGE):	$(MACHINE_CONFIG)
	@echo	"$(MAKE)	-C $(UBOOT_DIR)"				>>	$(BUILD_SCRIPT)
	$(MAKE)	-C $(UBOOT_DIR)

$(NFS_PATH):
	$(MAKE)	-C .. nfs

#	mkdir	-p	$(NFS_PATH)

$(UBOOT_ENV):
	@echo	"ipaddr=$(IPADDR)"						>	$@
	@echo	"serverip=$(SERVER_IP)"						>>	$@

prepare:	$(NFS_PATH)
	$(MAKE)	-C .. prepare

endif

endif

clean:
	rm	-fr	$(UBOOT_DIR)
	rm	-f	$(UBOOT_IMAGE)
	rm	-f	*~
	rm	-f	$(BUILD_SCRIPT)
	rm	-f	$(UBOOT_SRC)
	rm	-fr	deploy

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
