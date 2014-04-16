include	../host.mk
include ../yocto.mak
CFLAGS=
INSTALL_PATH=$(NFS_PATH)
BUILD_SCRIPT=build-busybox.sh

TOPDIR=`pwd`
TARGETS=install
MAKE=make $(XMAKEFLAGS)
CFG?=static

SYSROOT=$(PKG_CONFIG_SYSROOT_DIR)
# /opt/poky/1.5.1/sysroots/armv7a-vfp-neon-poky-linux-gnueabi/
	
ifeq ($(CFG),static)
TARGET_LDFLAGS="--static"
else
TARGET_LDFLAGS=""
endif

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
INITTAB=data/inittab
BUSYBOX_IMAGE=busybox

all:	setup	$(TARGETS)

source:		$(BUSYBOX_DIR)/.git

patch:		$(BUSYBOX_DIR)/.patches

configure:	$(MACHINE_CONFIG)

compile:	$(BUSYBOX_IMAGE)

install:	compile $(INSTALL_PATH)
	@echo	"make	-C	$(BUSYBOX_DIR)	CROSS_COMPILE=$(CROSS_COMPILE)install"		>>	$(BUILD_SCRIPT)
	@LDFLAGS=$(TARGET_LDFLAGS) sudo make	-C $(BUSYBOX_DIR) CROSS_COMPILE=$(CROSS_COMPILE) install
	chmod	a+x	$(BUILD_SCRIPT)

misc:	dev etc inittab passwd hostname init.d rcS firmware www

dev:	$(INSTALL_PATH)/dev

$(INSTALL_PATH)/dev:
	@sudo rm	-fr	$(INSTALL_PATH)/dev
	sudo install	-d	$(INSTALL_PATH)/dev
	sudo mknod 	$(INSTALL_PATH)/dev/cohttp://lists.busybox.net/pipermail/busybox/2007-July/062218.htmlnsole c 5 1
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
	sudo install	-m 0644	init/inittab	$(INSTALL_PATH)/etc/inittab

passwd:	$(INSTALL_PATH)/etc/passwd

$(INSTALL_PATH)/etc/passwd: etc
	sudo install	-m 0644	init/group	$(INSTALL_PATH)/etc/group
	sudo install	-m 0644	init/passwd	$(INSTALL_PATH)/etc/passwd

hostname:	$(INSTALL_PATH)/etc/hostname

$(INSTALL_PATH)/etc/hostname:	etc
	@sudo	install	-m 0644	init/hostname	$(INSTALL_PATH)/etc/hostname

init.d:	$(INSTALL_PATH)/etc/init.d/rcS

$(INSTALL_PATH)/etc/init.d:	etc
	sudo	install	-d	$(INSTALL_PATH)/etc/init.d

rcS:	$(INSTALL_PATH)/etc/init.d/rcS

$(INSTALL_PATH)/etc/init.d/rcS:	$(INSTALL_PATH)/etc/init.d	etc
	sudo install	-m 0644	init/rcS	$(INSTALL_PATH)/etc/init.d/rcS
	sudo chmod	a+x			$(INSTALL_PATH)/etc/init.d/rcS


loader:	etc
	sudo	install	-m	0644		$(SYSROOT)/lib/ld-2.18.so	$(INSTALL_PATH)/lib
	sudo	ln	-s				       ld-2.18.so	$(INSTALL_PATH)/lib/ld-linux.so.3
	sudo	install	-m	0644		$(SYSROOT)/lib/libc-2.18.so	$(INSTALL_PATH)/lib
	sudo	ln	-s				       libc-2.18.so	$(INSTALL_PATH)/lib/libc.so.6	

firmware:	$(INSTALL_PATH)/lib/firmware

$(INSTALL_PATH)/lib/firmware:
	sudo install	-d	$(INSTALL_PATH)/lib
	sudo install	-d	$(INSTALL_PATH)/lib/firmware
	sudo install	-m	0644		data/am335x-pm-firmware.bin	$(INSTALL_PATH)/lib/firmware

www:
	sudo	rsync	-av	data/www	$(INSTALL_PATH)

libc:	$(INSTALL_PATH)/lib/libc.so.6

$(INSTALL_PATH)/lib/libc.so.6:	eglibc.tar
	sudo	tar	-xvf	$<	-C	$(INSTALL_PATH)
	
eglibc.tar:
	tar	-C $(SYSROOT) -cvf	$@	lib usr/lib


dynamic:
	$(MAKE) CFG=dynamic CROSS_COMPILE=$(CROSS_COMPILE)	install
	$(MAKE) CFG=dynamic CROSS_COMPILE=$(CROSS_COMPILE)	misc
	$(MAKE) CFG=dynamic CROSS_COMPILE=$(CROSS_COMPILE)	libc

httpd:	configure compile misc libc install


#	echo	"null::respawn:/sbin/getty -L ttyO0 115200 vt100"	>> $(INSTALL_PATH)/etc/inittab
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
	(cd $(BUSYBOX_DIR) ; git am ../patches/*.patch)

$(MACHINE_CONFIG):	$(BOARD_CONFIG).${CFG}	$(BUSYBOX_DIR)/.git
	@echo	"ln	-s	$(INSTALL_PATH)	$(BUSYBOX_DIR)/_install"	>>	$(BUILD_SCRIPT)
	@if ! [ -e $(BUSYBOX_DIR)/_install ] ; then \
		ln	-s	$(INSTALL_PATH)	$(BUSYBOX_DIR)/_install ; \
	fi
	cp	$(BOARD_CONFIG).${CFG}	$(MACHINE_CONFIG)

$(BUSYBOX_IMAGE):	$(MACHINE_CONFIG)
	(cd $(BUSYBOX_DIR) ; LDFLAGS=$(TARGET_LDFLAGS)  make)
	cp	$(BUSYBOX_DIR)/$(BUSYBOX_IMAGE)	$(BUSYBOX_IMAGE)

#	 $(MAKE) CROSS_COMPILE=$(CROSS_COMPILE) -C $(BUSYBOX_DIR)

hello:	$(INSTALL_PATH)/usr/bin/hello

Hello:	$(INSTALL_PATH)/usr/bin/Hello

$(INSTALL_PATH)/usr/bin/hello:	data/hello.c
	$(CC)	-o $(INSTALL_PATH)/usr/bin/hello	data/hello.c

$(INSTALL_PATH)/usr/bin/Hello:	data/hello.c
	$(CC) --static -o $(INSTALL_PATH)/usr/bin/Hello	data/hello.c

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
	rm	-fr	$(BUSYBOX_DIR)
	rm	-f	uEnv.txt	etc_export
	sudo rm	-fr	$(INSTALL_PATH)/bin
	rm	-fr	$(INSTALL_PATH)/etc
	sudo rm	-fr	$(INSTALL_PATH)/dev
	rm	-fr	$(INSTALL_PATH)/lib/*.o
	rm	-fr	$(INSTALL_PATH)/lib/*.a
	rm	-fr	$(INSTALL_PATH)/lib/*.so
	rm	-fr	$(INSTALL_PATH)/lib/*.so.*
	rm	-fr	$(INSTALL_PATH)/lib/*.c
	rm	-fr	$(INSTALL_PATH)/lib/*.os
	rm	-fr	$(INSTALL_PATH)/lib/*.la
	rm	-fr	$(INSTALL_PATH)/lib/udev
	rm	-fr	$(INSTALL_PATH)/lib/modprobe.d
	rm	-fr	$(INSTALL_PATH)/lib/depmod.d
	rm	-fr	$(INSTALL_PATH)/proc
	rm	-fr	$(INSTALL_PATH)/root
	sudo rm	-fr	$(INSTALL_PATH)/sbin
	rm	-fr	$(INSTALL_PATH)/sys
	rm	-fr	$(INSTALL_PATH)/usr
	rm	-fr	$(INSTALL_PATH)/www
	rm	-fr	$(INSTALL_PATH)/linuxrc
	rm	-fr	$(INSTALL_PATH)/linuxrc
	rm	-fr	$(INSTALL_PATH)/var
	rm	-fr	$(INSTALL_PATH)/usr

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

