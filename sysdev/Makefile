ADDPKG=sudo apt-get -y install

include	host.mk

all:	prepare	nfs toolchain

prepare:
	@echo	Adding packages neccessary for build
	$(ADDPKG)	autoconf
	$(ADDPKG)	automake
	$(ADDPKG)	bison
	$(ADDPKG)	build-essential
	$(ADDPKG)	chrpath
	$(ADDPKG)	compizconfig-settings-manager
	$(ADDPKG)	curl
	$(ADDPKG)	cvs
	$(ADDPKG)	diffstat
	$(ADDPKG)	emacs
	$(ADDPKG)	flex
	$(ADDPKG)	gawk
	$(ADDPKG)	gftp
	$(ADDPKG)	gperf
	$(ADDPKG)	ia32-libs
	$(ADDPKG)	libexpat1-dev
	$(ADDPKG)	libglade2-dev
	$(ADDPKG)	libglib2.0-dev
	$(ADDPKG)	libgtk2.0-dev
	$(ADDPKG)	libncurses5-dev
	$(ADDPKG)	libqt4-dev
	$(ADDPKG)	libtool
	$(ADDPKG)	lzop
	$(ADDPKG)	nfs-kernel-server
	$(ADDPKG)	patch
	$(ADDPKG)	picocom
	$(ADDPKG)	python-dev
	$(ADDPKG)	qemu-kvm-extras
	$(ADDPKG)	squashfs-tools
	$(ADDPKG)	samba
	$(ADDPKG)	squashfs-tools
	$(ADDPKG)	system-config-samba
	$(ADDPKG)	subversion
	$(ADDPKG)	texinfo
	$(ADDPKG)	tftpd
	$(ADDPKG)	tftp
	$(ADDPKG)	u-boot-tools
	$(ADDPKG)	vim
	$(ADDPKG)	wmctrl
	$(ADDPKG)	vim
	sudo		adduser	${USER}	dialout



tftp:
	@sudo		mkdir	-p		/etc/xinetd.d
	@(if ! [ -e /etc/xinetd.d/tftp ] ; then 			\
		sudo	cp	network/tftp	/etc/xinetd.d;		\
	 else								\
		echo "/etc/xinetd.d/tftp exists";			\
	 fi)

toolchain:
	git clone	https://github.com/emagii/crosstool-ng-armv7a.git

cross:	sdk

Angstrom-1.4:
	git clone https://github.com/Angstrom-distribution/setup-scripts.git	Angstrom-1.4
	(cd Angstrom-1.4 ; git checkout -b v2013.06 origin/angstrom-v2013.06-yocto1.4)

Angstrom-1.4/Makefile:	toolchain/Angstrom.mak	Angstrom-1.4
	cp	toolchain/Angstrom.mak	Angstrom-1.4/Makefile

Angstrom-SDK:
	

poky-dora:
	git clone git://git.yoctoproject.org/poky poky-dora
	(cd poky-dora ; git checkout -b dora origin/dora)

poky-dora/Makefile:	toolchain/poky/Yocto.mak
	cp	toolchain/poky/Yocto.mak	poky-dora/Makefile

poky:
	git clone git://git.yoctoproject.org/poky

poky/Makefile:	toolchain/poky/Yocto.mak
	cp	toolchain/poky/Yocto.mak	poky/Makefile


adt_installer.tar.bz2:
	wget http://downloads.yoctoproject.org/releases/yocto/yocto-1.5.1/adt-installer/adt_installer.tar.bz2

adt-installer:	adt_installer.tar.bz2
	tar -jxvf	$<

/opt/poky:
	sudo	mkdir	-p		/opt/poky
	sudo	chown	$USER:$USER	/opt/poky
	echo	"run ./adt-installer"	

adt-installer/adt_installer.conf:	toolchain/adt_installer.conf
	cp	toolchain/adt_installer.conf	adt-installer/adt_installer.conf

yocto-toolchain:
	wget	http://downloads.yoctoproject.org/releases/yocto/yocto-1.5.1/toolchain/i686/poky-eglibc-i686-core-image-sato-armv7a-vfp-neon-toolchain-1.5.1.sh
	wget	http://downloads.yoctoproject.org/releases/yocto/yocto-1.5.1/toolchain/x86_64/poky-eglibc-x86_64-core-image-sato-armv7a-vfp-neon-toolchain-1.5.1.sh
	chmod a+x poky*.sh

test-yocto:	/opt/poky	adt-installer	adt-installer/adt_installer.conf
	(cd	adt-installer ; ./adt_installer)

sdk:	Angstrom-1.4/Makefile
	make	-C Angstrom-1.4	config

nfs:
	mkdir -p	$(NFS_PATH)
	@echo		"$(NFS_PATH) $(IPADDR)(rw,no_root_squash,no_subtree_check)"	> etc_export

restart-nfs:
	sudo	service nfs-kernel-server restart

.PHONY:	cross nfs
