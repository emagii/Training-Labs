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
UBOOT_SETUP=uSetup.txt

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

install:	$(UBOOT_DIR)/$(UBOOT_IMAGE)	$(UBOOT_ENV) $(UBOOT_SETUP)	
	@echo	"mkdir	-p	deploy"					>>	$(BUILD_SCRIPT)
	@echo	"cp	$(UBOOT_DIR)/$(UBOOT_IMAGE)	deploy"		>>	$(BUILD_SCRIPT)
	@echo	"cp	$(UBOOT_DIR)/MLO		deploy"		>>	$(BUILD_SCRIPT)
	mkdir	-p	deploy
	cp	$(UBOOT_DIR)/$(UBOOT_IMAGE)	deploy
	cp	$(UBOOT_DIR)/MLO		deploy
	chmod	a+x	$(BUILD_SCRIPT)
	cp	$(BUILD_SCRIPT)			deploy
	cp	$(UBOOT_ENV)			deploy
	cp	$(UBOOT_SETUP)			deploy
	
source:		$(UBOOT_DIR)/.extracted

environment:	$(UBOOT_SETUP)	$(UBOOT_ENV)

setup:	$(BUILD_SCRIPT)

$(BUILD_SCRIPT):
	echo	"#!/bin/sh"						>	$(BUILD_SCRIPT)

$(UBOOT_SRC):
	@echo	"wget	$(SRC_URI)/$(UBOOT_SRC)"			>>	$(BUILD_SCRIPT)
	wget	$(SRC_URI)/$(UBOOT_SRC)
	touch	$@

$(UBOOT_DIR)/.extracted:	$(UBOOT_SRC)
	@echo	"tar	-jxvf	$(UBOOT_SRC)"				>>	$(BUILD_SCRIPT)
	tar	-jxvf	$(UBOOT_SRC)
	touch	$@

$(UBOOT_DIR)/.gitrepo:	$(UBOOT_DIR)/.extracted
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
	touch	$@

$(UBOOT_DIR)/.patched:	$(UBOOT_DIR)/.gitrepo
	@echo	"cd	$(UBOOT_DIR)"					>>	$(BUILD_SCRIPT)
	@echo	"git	am	$(PATCH_DIR)/*.patch"			>>	$(BUILD_SCRIPT)
	@echo	"cd	.."						>>	$(BUILD_SCRIPT)
	(cd	$(UBOOT_DIR) ;					\
	git	am	$(PATCH_DIR)/*.patch			\
	)
	touch	$@

$(MACHINE_CONFIG):	$(UBOOT_DIR)/.patched
	@echo	"$(MAKE)	-C $(UBOOT_DIR)	$(BOARD_CONFIG)_config"	>>	$(BUILD_SCRIPT)
	$(MAKE) -C $(UBOOT_DIR)	$(BOARD_CONFIG)_config

$(UBOOT_DIR)/$(UBOOT_IMAGE):	$(MACHINE_CONFIG)
	@echo	"$(MAKE)	-C $(UBOOT_DIR)"			>>	$(BUILD_SCRIPT)
	$(MAKE)	-C $(UBOOT_DIR)

$(NFS_PATH):
	$(MAKE)	-C .. nfs

#	mkdir	-p	$(NFS_PATH)

$(UBOOT_SETUP):
	@echo	"ipaddr=$(IPADDR)"					>	$@
	@echo	"serverip=$(SERVER_IP)"					>>	$@
	@echo	"loadaddr=0x80200000"					>>	$@
	@echo	"fdtaddr=0x80F80000"					>>	$@
	@echo	"IMAGE=rootfs"						>>	$@
	@echo	"console=ttyO0,115200n8"				>>	$@
	@echo	"nfsopts=nolock"					>>	$@
	@echo	'netargs=setenv bootargs console=$${console} root=/dev/nfs nfsroot=$${serverip}:/tftpboot/$${IMAGE},$${nfsopts} rw ip=$${ipaddr}'	>>	$@
	@echo	'tftp_kernel=tftp $${loadaddr} zImage'			>>	$@
	@echo	'tftp_dtb=tftp $${fdtaddr} am335x-boneblack.dtb'	>>	$@
	@echo	'bootkernel=bootz $${loadaddr} - $${fdtaddr}'		>>	$@
	@echo	'mmcargs=setenv bootargs console=$${console} $${optargs} root=$${mmcroot} rootfstype=$${mmcrootfstype} rootwait'	>>	$@
	@echo	"mmcrootfstype=squashfs"				>>	$@
	@echo	"nandboot=echo NAND boot disabled"			>>	$@
	@echo	"bootcmd=run tftp_kernel tftp_dtb netargs bootkernel"	>>	$@

$(UBOOT_ENV):
	@echo	"ipaddr=$(IPADDR)"					>	$@
	@echo	"serverip=$(SERVER_IP)"					>>	$@
	@echo	"loadaddr=0x80200000"					>>	$@
	@echo	"fdtaddr=0x80F80000"					>>	$@
	@echo	"IMAGE=rootfs"						>>	$@
	@echo	"console=ttyO0,115200n8"				>>	$@
	@echo	"nfsopts=nolock"					>>	$@
	@echo	'netargs=setenv bootargs console=$${console} root=/dev/nfs nfsroot=$${serverip}:/tftpboot/$${IMAGE},$${nfsopts} rw ip=$${ipaddr}'	>>	$@
	@echo	'tftp_kernel=tftp $${loadaddr} zImage'			>>	$@
	@echo	'tftp_dtb=tftp $${fdtaddr} am335x-boneblack.dtb'	>>	$@
	@echo	'bootkernel=bootz $${loadaddr} - $${fdtaddr}'		>>	$@
	@echo	'uenvcmd=run tftp_kernel tftp_dtb netargs bootkernel'	>>	$@
	@echo	"mmcboot=echo MMC boot disabled"			>>	$@
	@echo	"nandboot=echo NAND boot disabled"			>>	$@

prepare:	$(NFS_PATH)
	$(MAKE)	-C .. prepare

endif

endif

clean:
	rm	-fr	$(UBOOT_DIR)
	rm	-f	$(UBOOT_IMAGE)
	rm	-f	*~
	rm	-f	$(BUILD_SCRIPT)
	rm	-fr	deploy

distclean:	clean
	rm	-f	$(UBOOT_SRC)

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
