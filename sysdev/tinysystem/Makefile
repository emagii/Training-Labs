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
BUSYBOX_VERSION=1.22.1
BUSYBOX=busybox-$(BUSYBOX_VERSION)
BUSYBOX_SRC=$(BUSYBOX).tar.bz2
BUSYBOX_DIR=$(BUSYBOX)

MACHINE_CONFIG=$(BUSYBOX_DIR)/.config
BOARD_CONFIG=data/$(BUSYBOX).config
BUSYBOX_IMAGE=busybox

all:	setup	$(TARGETS)

source:		$(BUSYBOX_DIR)/.git

patch:		$(BUSYBOX_DIR)/.patches

configure:	$(MACHINE_CONFIG)

compile:	$(BUSYBOX_IMAGE)

install:	compile $(NFS_PATH)
	@echo	"ln	-s	$(NFS_PATH)	$(BUSYBOX_DIR)/_install"	>>	$(BUILD_SCRIPT)
	ln	-s	$(NFS_PATH)	$(BUSYBOX_DIR)/_install
	@echo	"make	-C	$(BUSYBOX_DIR)	install"		>>	$(BUILD_SCRIPT)
	sudo 	make	-C	$(BUSYBOX_DIR)	install
	mkdir	-p	$(NFS_PATH)/dev
	chmod	a+x	$(BUILD_SCRIPT)

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

$(BUSYBOX_DIR)/.git:	$(BUSYBOX_DIR)/.extracted
	(cd $(BUSYBOX_DIR) ; git init ; git add . ; git commit -m "Initital Commit" -s)

$(BUSYBOX_DIR)/.patches:	$(BUSYBOX_DIR)/.git
	(cd $(BUSYBOX_DIR) ; git am ../patches/*.patch)

$(MACHINE_CONFIG):	$(BOARD_CONFIG)	$(BUSYBOX_DIR)/.git
	cp	$(BOARD_CONFIG)	$(MACHINE_CONFIG)

$(BUSYBOX_IMAGE):	$(MACHINE_CONFIG)
	$(MAKE) -C $(BUSYBOX_DIR)
	cp	$(BUSYBOX_DIR)/$(BUSYBOX_IMAGE)	$(BUSYBOX_IMAGE)

endif
endif

rootfs:	nfs install lib startup webserver

lib:
	./getlib.sh	$(NFS_PATH)

startup:
	mkdir	-p	$(NFS_PATH)/etc
	mkdir	-p	$(NFS_PATH)/proc
	mkdir	-p	$(NFS_PATH)/sys
	rsync	-av	data/etc	$(NFS_PATH)

webserver:
	rsync	-av	data/www	$(NFS_PATH)

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
	rm	-fr	$(BUSYBOX_DIR)
	rm	-f	uEnv.txt	etc_export
	rm	-fr	$(NFS_PATH)/bin
	rm	-fr	$(NFS_PATH)/etc
	rm	-fr	$(NFS_PATH)/lib/*.o
	rm	-fr	$(NFS_PATH)/lib/*.a
	rm	-fr	$(NFS_PATH)/lib/*.so
	rm	-fr	$(NFS_PATH)/lib/*.so.*
	rm	-fr	$(NFS_PATH)/lib/*.c
	rm	-fr	$(NFS_PATH)/lib/*.os
	rm	-fr	$(NFS_PATH)/proc
	rm	-fr	$(NFS_PATH)/sbin
	rm	-fr	$(NFS_PATH)/sys
	rm	-fr	$(NFS_PATH)/usr
	rm	-fr	$(NFS_PATH)/www

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

