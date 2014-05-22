SYSDEVDIR=~/felabs/sysdev
include	$(SYSDEVDIR)/host.mk
include $(SYSDEVDIR)/yocto.mak

TOPDIR=~/felabs/sysdev/tinysystem
DATADIR=$(TOPDIR)/data
PATCHDIR=$(TOPDIR)/patches

CFLAGS=
BUILD_SCRIPT=build-busybox.sh

TARGETS=install
MAKE=make $(XMAKEFLAGS)

SYSROOT=$(PKG_CONFIG_SYSROOT_DIR)
# /opt/poky/1.6/sysroots/armv7a-vfp-neon-poky-linux-gnueabi/
	
-include	.config

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
BOARD_CONFIG=$(BUSYBOX).config
INITTAB=data/inittab
BUSYBOX_IMAGE=busybox

all:	setup	$(TARGETS)

source:		$(BUSYBOX_DIR)/.git

patch:		$(BUSYBOX_DIR)/.patches

configure:	$(MACHINE_CONFIG)

compile:	$(BUSYBOX_IMAGE)

install:	compile $(INSTALL_PATH)
	@echo	"make	-C	$(BUSYBOX_DIR)	CROSS_COMPILE=$(CROSS_COMPILE)install"		>>	$(BUILD_SCRIPT)
	@(LDFLAGS=$(TARGET_LDFLAGS) make	ARCH=arm -C $(BUSYBOX_DIR) CROSS_COMPILE=$(CROSS_COMPILE) install)
	chmod	a+x	$(BUILD_SCRIPT)

misc:	dev etc inittab passwd hostname init.d rcS firmware loader libc www

dev:	$(INSTALL_PATH)/dev

$(INSTALL_PATH)/dev:
	@sudo rm	-fr	$(INSTALL_PATH)/dev
	sudo install	-d	$(INSTALL_PATH)/dev
	sudo mknod 	$(INSTALL_PATH)/dev/console c 5 1
	sudo mknod 	$(INSTALL_PATH)/dev/null c 1 3

etc:	$(INSTALL_PATH)/etc

$(INSTALL_PATH)/etc:
	sudo mkdir	-p	$(INSTALL_PATH)/proc
	sudo mkdir	-p	$(INSTALL_PATH)/sys
	sudo mkdir	-p	$(INSTALL_PATH)/root
	sudo mkdir	-p	$(INSTALL_PATH)/lib
	sudo mkdir	-p	$(INSTALL_PATH)/tmp
	sudo mkdir	-p	$(INSTALL_PATH)/var/log
	sudo mkdir	-p	$(INSTALL_PATH)/root
	sudo mkdir	-p	$(INSTALL_PATH)/boot
	sudo mkdir	-p	$(INSTALL_PATH)/etc

inittab:	$(INSTALL_PATH)/etc/inittab
	
$(INSTALL_PATH)/etc/inittab:	etc
	sudo install	-m 0644	$(TOPDIR)/init/inittab	$(INSTALL_PATH)/etc/inittab

rcS:	$(INSTALL_PATH)/etc/init.d/rcS

$(INSTALL_PATH)/etc/init.d/rcS:	$(INSTALL_PATH)/etc/init.d	etc
	sudo install	-m 0644	$(TOPDIR)/init/rcS.1	$(INSTALL_PATH)/etc/init.d/rcS
	sudo chmod	a+x				$(INSTALL_PATH)/etc/init.d/rcS

passwd:	$(INSTALL_PATH)/etc/passwd

$(INSTALL_PATH)/etc/passwd: etc
	sudo install	-m 0644	$(TOPDIR)/init/group	$(INSTALL_PATH)/etc/group
	sudo install	-m 0644	$(TOPDIR)/init/passwd	$(INSTALL_PATH)/etc/passwd

hostname:	$(INSTALL_PATH)/etc/hostname

$(INSTALL_PATH)/etc/hostname:	etc
	@sudo	install	-m 0644	$(TOPDIR)/init/hostname	$(INSTALL_PATH)/etc/hostname

init.d:	$(INSTALL_PATH)/etc/init.d/rcS

$(INSTALL_PATH)/etc/init.d:	etc
	sudo	install	-d	$(INSTALL_PATH)/etc/init.d



loader:	etc
	sudo	install	-m	0755		$(SYSROOT)/lib/ld-2.19.so	$(INSTALL_PATH)/lib
	sudo	ln	-s				       ld-2.19.so	$(INSTALL_PATH)/lib/ld-linux-armhf.so.3

libc:	etc
	sudo	install	-m	0755		$(SYSROOT)/lib/libc-2.19.so	$(INSTALL_PATH)/lib
	sudo	ln	-s				       libc-2.19.so	$(INSTALL_PATH)/lib/libc.so.6	

firmware:	$(INSTALL_PATH)/lib/firmware

$(INSTALL_PATH)/lib/firmware:
	sudo install	-d	$(INSTALL_PATH)/lib
	sudo install	-d	$(INSTALL_PATH)/lib/firmware
	sudo install	-m	0644		$(DATADIR)/am335x-pm-firmware.bin	$(INSTALL_PATH)/lib/firmware

www:
	sudo	rsync	-av	$(DATADIR)/www	$(INSTALL_PATH)

eglibc:	$(INSTALL_PATH)/lib/libc.so.6

$(INSTALL_PATH)/lib/libc.so.6:	eglibc.tar
	sudo	tar	-xvf	$<	-C	$(INSTALL_PATH)
	
eglibc.tar:
	tar	-C $(SYSROOT) -cvf	$@	lib usr/lib

hello:	$(INSTALL_PATH)/usr/bin/hello

Hello:	$(INSTALL_PATH)/usr/bin/Hello

apps:	$(INSTALL_PATH)/usr/bin/hello	$(INSTALL_PATH)/usr/bin/Hello

$(INSTALL_PATH)/usr/bin/hello:	etc
	make -C ../hello INSTALL_PATH=$(INSTALL_PATH) install

$(INSTALL_PATH)/usr/bin/Hello:	etc
	make -C ../hello INSTALL_PATH=$(INSTALL_PATH) install

#	echo	"null::respawn:/sbin/getty -L ttyO0 115200 vt100"	>> $(INSTALL_PATH)/etc/initta
#	echo	"null::sysinit:/bin/mount -t proc proc /proc"		>  $(INSTALL_PATH)/etc/inittab
#	echo	"null::sysinit:/bin/hostname -F /etc/hostname"		>> $(INSTALL_PATH)/etc/inittab
#	echo	"null::shutdown:/sbin/mount -a -r"			>> $(INSTALL_PATH)/etc/inittab

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
	(cd $(BUSYBOX_DIR) ; git init ; git add . ; git commit -m "Initial Commit" -s)

$(BUSYBOX_DIR)/.patches:	$(BUSYBOX_DIR)/.git
	(cd $(BUSYBOX_DIR) ; git am $(PATCHDIR)/*.patch)

$(MACHINE_CONFIG):	$(BOARD_CONFIG)	$(BUSYBOX_DIR)/.git
	@echo	"ln	-s	$(INSTALL_PATH)	$(BUSYBOX_DIR)/_install"	>>	$(BUILD_SCRIPT)
	@if ! [ -e $(BUSYBOX_DIR)/_install ] ; then \
		ln	-s	$(INSTALL_PATH)	$(BUSYBOX_DIR)/_install ; \
	fi
	cp	$(BOARD_CONFIG)	$(MACHINE_CONFIG)


$(BUSYBOX_DIR)/$(BUSYBOX_IMAGE):	$(MACHINE_CONFIG)
	@echo
	@echo
	@echo
	@echo	"Perform"
	@echo	"cd $(BUSYBOX_DIR)"
	@echo	"make"
	@echo
	exit	2

$(BUSYBOX_IMAGE):	$(BUSYBOX_DIR)/$(BUSYBOX_IMAGE)
	cp	$(BUSYBOX_DIR)/$(BUSYBOX_IMAGE)	$(BUSYBOX_IMAGE)

#	(cd $(BUSYBOX_DIR) ; env | grep CC ; LDFLAGS=$(TARGET_LDFLAGS)  make)
#	 $(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) -C $(BUSYBOX_DIR)

hello:	$(INSTALL_PATH)/usr/bin/hello

Hello:	$(INSTALL_PATH)/usr/bin/Hello



endif
endif

rootfs:	nfs install lib startup webserver

lib:
	./getlib.sh	$(INSTALL_PATH)

startup:
	mkdir	-p	$(INSTALL_PATH)/etc
	mkdir	-p	$(INSTALL_PATH)/proc
	mkdir	-p	$(INSTALL_PATH)/sys
	rsync	-av	data/etc	$(INSTALL_PATH)

webserver:
	rsync	-av	data/www	$(INSTALL_PATH)

nfs:
	mkdir -p	$(INSTALL_PATH)
	@echo		"$(INSTALL_PATH) $(IPADDR)(rw,no_root_squash,no_subtree_check)"	> etc_export

restart-nfs:
	sudo	service nfs-BUSYBOX-server restart

uEnv.txt:
	@echo	"console=console=ttyO2,115200"		>	$@
	@echo	"ipaddr=$(IPADDR)"			>>	$@
	@echo	"serverip=$(SERVER_IP)"			>>	$@
	@echo	"nfsroot=$(INSTALL_PATH)"			>>	$@
	@echo	"bootargs=\$${console} root=/dev/nfs ip=\$${ipaddr} nfsroot=\$${serverip}:\$${nfsroot} rw"		>>	$@

clean:
	@echo	"INSTALL_PATH=$(INSTALL_PATH)"
	sudo rm	-fr	$(BUSYBOX_DIR)
	sudo rm	-f	uEnv.txt	etc_export
	sudo rm	-fr	$(INSTALL_PATH)/bin
	sudo rm	-fr	$(INSTALL_PATH)/etc
	sudo rm	-fr	$(INSTALL_PATH)/dev
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.o
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.a
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.so
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.so.*
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.c
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.os
	sudo rm	-fr	$(INSTALL_PATH)/lib/*.la
	sudo rm	-fr	$(INSTALL_PATH)/lib/udev
	sudo rm	-fr	$(INSTALL_PATH)/lib/modprobe.d
	sudo rm	-fr	$(INSTALL_PATH)/lib/depmod.d
	sudo rm	-fr	$(INSTALL_PATH)/lib/firmware
	sudo rm	-fr	$(INSTALL_PATH)/proc
	sudo rm	-fr	$(INSTALL_PATH)/root
	sudo rm	-fr	$(INSTALL_PATH)/sbin
	sudo rm	-fr	$(INSTALL_PATH)/sys
	sudo rm	-fr	$(INSTALL_PATH)/usr
	sudo rm	-fr	$(INSTALL_PATH)/www
	sudo rm	-fr	$(INSTALL_PATH)/linuxrc
	sudo rm	-fr	$(INSTALL_PATH)/linuxrc
	sudo rm	-fr	$(INSTALL_PATH)/tmp
	sudo rm	-fr	$(INSTALL_PATH)/var
	sudo rm	-fr	$(INSTALL_PATH)/usr

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
	@echo	INSTALL_PATH=$(INSTALL_PATH)


.PHONY:	clean help debug configure compile install source

