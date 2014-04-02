ADDPKG=sudo apt-get install

include	host.mk

all:	prepare	nfs toolchain

prepare:
	@echo	Adding packages neccessary for build
	$(ADDPKG)	autoconf
	$(ADDPKG)	automake
	$(ADDPKG)	bison
	$(ADDPKG)	build-essential
	$(ADDPKG)	curl
	$(ADDPKG)	cvs
	$(ADDPKG)	emacs
	$(ADDPKG)	flex
	$(ADDPKG)	gawk
	$(ADDPKG)	gperf
	$(ADDPKG)	ia32-libs
	$(ADDPKG)	libexpat1-dev
	$(ADDPKG)	libglade2-dev
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
	$(ADDPKG)	subversion
	$(ADDPKG)	texinfo
	$(ADDPKG)	tftpd
	$(ADDPKG)	tftp
	$(ADDPKG)	u-boot-tools
	$(ADDPKG)	vim
	sudo		adduser	$USER	dialout


tftp:
	@sudo		mkdir	-p		/etc/xinetd.d
	@(if ! [ -e /etc/xinetd.d/tftp ] ; then 			\
		sudo	cp	network/tftp	/etc/xinetd.d;		\
	 else								\
		echo "/etc/xinetd.d/tftp exists";			\
	 fi)

toolchain:
	git clone	https://github.com/emagii/crosstool-ng-armv7a.git
	

nfs:
	mkdir -p	$(NFS_PATH)
	@echo		"$(NFS_PATH) $(IPADDR)(rw,no_root_squash,no_subtree_check)"	> etc_export

restart-nfs:
	sudo	service nfs-kernel-server restart


