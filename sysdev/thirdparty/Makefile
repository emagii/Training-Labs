
TOPDIR=$(PWD)
BUILD_SCRIPT=build-thirdparty.sh

ZLIB_VERSION=1.2.8
ZLIB_SITE=http://zlib.net/
ZLIB_DIR=zlib-$(ZLIB_VERSION)
ZLIB_SOURCE=$(ZLIB_DIR).tar.gz
ZLIB_URI=$(ZLIB_SITE)/$(ZLIB_SOURCE)

LIBPNG_VERSION=1.4.3
LIBPNG_SITE=http://sourceforge.net/projects/libpng/files/libpng14/older-releases/$(LIBPNG_VERSION)/
LIBPNG_DIR=libpng-$(LIBPNG_VERSION)
LIBPNG_SOURCE=$(LIBPNG_DIR).tar.gz
LIBPNG_URI=$(LIBPNG_SITE)/$(LIBPNG_SOURCE)

LIBJPEG_VERSION=8
LIBJPEG_SITE=www.ijg.org/files/
LIBJPEG_DIR=jpeg-$(LIBJPEG_VERSION)
LIBJPEG_SOURCE=jpegsrc.v$(LIBJPEG_VERSION).tar.gz
LIBJPEG_URI=$(LIBJPEG_SITE)/$(LIBJPEG_SOURCE)

FREETYPE_VERSION=2.4.2
FREETYPE_SITE=http://download.savannah.gnu.org/releases/freetype
FREETYPE_DIR=freetype-$(FREETYPE_VERSION)
FREETYPE_SOURCE=$(FREETYPE_DIR).tar.gz
FREETYPE_URI=$(FREETYPE_SITE)/$(FREETYPE_SOURCE)

DIRECTFB_VERSION=1.4.5
DIRECTFB_SITE=http://www.directfb.org/downloads/Core/DirectFB-1.4
DIRECTFB_DIR=DirectFB-$(DIRECTFB_VERSION)
DIRECTFB_SOURCE=$(DIRECTFB_DIR).tar.gz
DIRECTFB_URI=$(DIRECTFB_SITE)/$(DIRECTFB_SOURCE)

# http://www.directfb.org/downloads/Extras/DirectFB-examples-1.2.0.tar.gz

DIRECTFB_EXA_VERSION=1.2.0
DIRECTFB_EXA_SITE=http://www.directfb.org/downloads/Extras
DIRECTFB_EXA_DIR=DirectFB-examples-$(DIRECTFB_EXA_VERSION)
DIRECTFB_EXA_SOURCE=$(DIRECTFB_EXA_DIR).tar.gz
DIRECTFB_EXA_URI=$(DIRECTFB_EXA_SITE)/$(DIRECTFB_EXA_SOURCE)


all:	zlib libpng lipjpeg freetype directfb directfb-exa

source:	zlib-source libpng-source libjpeg-source freetype-source directfb-source directfb-exa-source

install: zlib-install libpng-install libjpeg-install freetype-install directfb-install directfb-exa-install

# -----------------------------------------------------------------------------
zlib-source:	$(ZLIB_DIR)/.extracted

$(ZLIB_SOURCE):
	@echo	"wget	$(ZLIB_URI)"	>>	$(BUILD_SCRIPT)
	wget	$(ZLIB_URI)

$(ZLIB_DIR)/.extracted:	$(ZLIB_SOURCE)
	@echo	"tar -zxvf $(ZLIB_SOURCE)"	>>	$(BUILD_SCRIPT)
	tar -zxvf $(ZLIB_SOURCE)
	touch	$@

zlib-configure:	$(ZLIB_DIR)/.extracted
	@echo	"(cd $(ZLIB_DIR) ; ./configure --prefix=/usr)"	>>	$(BUILD_SCRIPT)
	(cd $(ZLIB_DIR) ; ./configure --prefix=/usr)

zlib-compile:	zlib-configure
	@echo	"make -C $(ZLIB_DIR)"	>>	$(BUILD_SCRIPT)
	make -C $(ZLIB_DIR)

zlib-staging:	zlib-compile
	@echo	"make -C $(ZLIB_DIR)	DESTDIR=$(TOPDIR)/staging/ install"	>>	$(BUILD_SCRIPT)
	make -C $(ZLIB_DIR)	DESTDIR=$(TOPDIR)/staging/ install
	
zlib-install:	zlib-staging
	@echo	"sudo mkdir -p target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo mkdir -p target/usr/lib
	@echo	"sudo cp	-a staging/usr/lib/libz.so.1*	target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo cp	-a staging/usr/lib/libz.so.1*	target/usr/lib

zlib:	zlib-install
	@echo	"# Building zlib complete"	>>	$(BUILD_SCRIPT)


# -----------------------------------------------------------------------------
libpng-source:	$(LIBPNG_DIR)/.extracted

$(LIBPNG_SOURCE):
	@echo	"wget	$(LIBPNG_URI)"	>>	$(BUILD_SCRIPT)
	wget	$(LIBPNG_URI)

$(LIBPNG_DIR)/.extracted:	$(LIBPNG_SOURCE)
	@echo	"tar -zxvf $(LIBPNG_SOURCE)"	>>	$(BUILD_SCRIPT)
	tar -zxvf $(LIBPNG_SOURCE)
	touch	$@

libpng-configure:	$(LIBPNG_DIR)/.extracted
	@echo	"(cd $(LIBPNG_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		./configure --host=arm-linux --prefix=/usr)"	>>	$(BUILD_SCRIPT)
	(cd $(LIBPNG_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		./configure  --host=arm-linux --prefix=/usr)

libpng-compile:	libpng-configure
	@echo	"make -C $(LIBPNG_DIR)"	>>	$(BUILD_SCRIPT)
	make -C $(LIBPNG_DIR)

libpng-staging:	libpng-compile
	@echo	"make -C $(LIBPNG_DIR)	DESTDIR=$(TOPDIR)/staging/ install"	>>	$(BUILD_SCRIPT)
	make -C $(LIBPNG_DIR)	DESTDIR=$(TOPDIR)/staging/ install

libpng-install:	libpng-staging
	@echo	"sudo cp -a staging/usr/lib/libpng14.so.* target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/libpng14.so.* target/usr/lib

libpng:	libpng-install

# -----------------------------------------------------------------------------
libjpeg-source:	$(LIBJPEG_DIR)/.extracted

$(LIBJPEG_SOURCE):
	@echo	"wget	$(LIBJPEG_URI)"	>>	$(BUILD_SCRIPT)
	wget	$(LIBJPEG_URI)

$(LIBJPEG_DIR)/.extracted:	$(LIBJPEG_SOURCE)
	@echo	"tar -zxvf $(LIBJPEG_SOURCE)"	>>	$(BUILD_SCRIPT)
	tar -zxvf $(LIBJPEG_SOURCE)
	touch	$@

libjpeg-configure:	$(LIBJPEG_DIR)/.extracted
	@echo	"(cd $(LIBJPEG_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		./configure --host=arm-linux --prefix=/usr)"	>>	$(BUILD_SCRIPT)
	(cd $(LIBJPEG_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		./configure  --host=arm-linux --prefix=/usr)

libjpeg-compile:	libjpeg-configure
	@echo	"make -C $(LIBJPEG_DIR)"	>>	$(BUILD_SCRIPT)
	make -C $(LIBJPEG_DIR)


libjpeg-staging:	libjpeg-compile
	@echo	"make -C $(LIBJPEG_DIR)	DESTDIR=$(TOPDIR)/staging/ install"	>>	$(BUILD_SCRIPT)
	make -C $(LIBJPEG_DIR)	DESTDIR=$(TOPDIR)/staging/ install

libjpeg-install:	libjpeg-staging
	@echo	"sudo cp -a staging/usr/lib/libjpeg.so.8* target/usr/lib/"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/libjpeg.so.8* target/usr/lib/

libjpeg:	libjpeg-install

# -----------------------------------------------------------------------------
freetype-source:	$(FREETYPE_DIR)/.extracted

$(FREETYPE_SOURCE):
	@echo	"wget	$(FREETYPE_URI)"	>>	$(BUILD_SCRIPT)
	wget	$(FREETYPE_URI)

$(FREETYPE_DIR)/.extracted:	$(FREETYPE_SOURCE)
	@echo	"tar -zxvf $(FREETYPE_SOURCE)"	>>	$(BUILD_SCRIPT)
	tar -zxvf $(FREETYPE_SOURCE)
	touch	$@

freetype-configure:	$(FREETYPE_DIR)/.extracted
	@echo	"(cd $(FREETYPE_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		./configure --host=arm-linux --prefix=/usr)"	>>	$(BUILD_SCRIPT)
	(cd $(FREETYPE_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		./configure  --host=arm-linux --prefix=/usr)

freetype-compile:	freetype-configure
	@echo	"make -C $(FREETYPE_DIR)"	>>	$(BUILD_SCRIPT)
	make -C $(FREETYPE_DIR)


freetype-staging:	freetype-compile
	@echo	"make -C $(FREETYPE_DIR)	DESTDIR=$(TOPDIR)/staging/ install"	>>	$(BUILD_SCRIPT)
	make -C $(FREETYPE_DIR)	DESTDIR=$(TOPDIR)/staging/ install

freetype-install:	freetype-staging
	@echo	"sudo cp -a staging/usr/lib/libfreetype.so.6* target/usr/lib/"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/libfreetype.so.6* target/usr/lib/

freetype:	freetype-install

# -----------------------------------------------------------------------------
directfb-source:	$(DIRECTFB_DIR)/.extracted

$(DIRECTFB_SOURCE):
	@echo	"wget	$(DIRECTFB_URI)"	>>	$(BUILD_SCRIPT)
	wget	$(DIRECTFB_URI)

$(DIRECTFB_DIR)/.extracted:	$(DIRECTFB_SOURCE)
	@echo	"tar -zxvf $(DIRECTFB_SOURCE)"	>>	$(BUILD_SCRIPT)
	tar -zxvf $(DIRECTFB_SOURCE)
	touch	$@

directfb-configure:	$(DIRECTFB_DIR)/.extracted
	@echo	"(cd $(DIRECTFB_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		export PKG_CONFIG_PATH=$(TOPDIR)/staging/usr/lib/pkgconfig; \
		export PKG_CONFIG_SYSROOT_DIR=$(TOPDIR)/staging ; \
		./configure --host=arm-linux --prefix=/usr --with-gfxdrivers=none --with-inputdrivers=keyboard,linuxinput)"	>>	$(BUILD_SCRIPT)
	(cd $(DIRECTFB_DIR) ; \
		export LDFLAGS=-L$(TOPDIR)/staging/usr/lib ; \
		export CPPFLAGS=-I$(TOPDIR)/staging/usr/include ; \
		export PKG_CONFIG_PATH=$(TOPDIR)/staging/usr/lib/pkgconfig; \
		export PKG_CONFIG_SYSROOT_DIR=$(TOPDIR)/staging ; \
		./configure  --host=arm-linux --prefix=/usr \
		--with-gfxdrivers=none --with-inputdrivers=keyboard,linuxinput)

directfb-compile:	directfb-configure
	@echo	"make -C $(DIRECTFB_DIR)"	>>	$(BUILD_SCRIPT)
	make -C $(DIRECTFB_DIR)


directfb-staging:	directfb-compile
	@echo	"make -C $(DIRECTFB_DIR)	DESTDIR=$(TOPDIR)/staging/ install"	>>	$(BUILD_SCRIPT)
	make -C $(DIRECTFB_DIR)	DESTDIR=$(TOPDIR)/staging/ install

directfb-install:	directfb-staging
	@echo	"sudo cp -a staging/usr/lib/libdirect-1.4.so.5* target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/libdirect-1.4.so.5* target/usr/lib
	@echo	"sudo cp -a staging/usr/lib/libdirectfb-1.4.so.5* target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/libdirectfb-1.4.so.5* target/usr/lib
	@echo	"sudo cp -a staging/usr/lib/libfusion-1.4.so.5* target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/libfusion-1.4.so.5* target/usr/lib
	@echo	"sudo cp -a staging/usr/lib/directfb-1.4-5/ target/usr/lib"	>>	$(BUILD_SCRIPT)
	sudo cp -a staging/usr/lib/directfb-1.4-5/ target/usr/lib

directfb:	directfb-install


# -----------------------------------------------------------------------------
directfb-exa-source:	$(DIRECTFB_EXA_DIR)/.extracted

$(DIRECTFB_EXA_SOURCE):
	@echo	"wget	$(DIRECTFB_EXA_URI)"	>>	$(BUILD_SCRIPT)
	wget	$(DIRECTFB_EXA_URI)

$(DIRECTFB_EXA_DIR)/.extracted:	$(DIRECTFB_EXA_SOURCE)
	@echo	"tar -zxvf $(DIRECTFB_EXA_SOURCE)"	>>	$(BUILD_SCRIPT)
	tar -zxvf $(DIRECTFB_EXA_SOURCE)
	touch	$@

directfb-exa-configure:	$(DIRECTFB_EXA_DIR)/.extracted
	@echo	"(cd $(DIRECTFB_EXA_DIR) ; ./configure --host=arm-linux --prefix=/usr)"	>>	$(BUILD_SCRIPT)
	(cd $(DIRECTFB_EXA_DIR) ; ./configure --host=arm-linux --prefix=/usr)

directfb-exa-install:	directfb-exa-configure
	@echo	"make -C $(DIRECTFB_EXA_DIR)	\
	STRIP=$(CROSS_COMPILE)strip \
	DESTDIR=$(TOPDIR)/target install-strip"	>>	$(BUILD_SCRIPT)
	make -C $(DIRECTFB_EXA_DIR) STRIP=$(CROSS_COMPILE)strip DESTDIR=$(TOPDIR)/target install-strip

directfb-exa:	directfb-exa-install


# -----------------------------------------------------------------------------
TOOLCHAIN_SYSROOT=$(shell arm-poky-linux-gnueabi-gcc --print-sysroot)

missing:
	cp	-a	$(TOOLCHAIN_SYSROOT)/lib/libsysfs*	target/lib
	cp	-a	$(TOOLCHAIN_SYSROOT)/lib/libgcc_s*	target/lib
	sudo	mknod	target/dev/fb0	c 29 0


#	@echo TOOLCHAIN_SYSROOT=$(TOOLCHAIN_SYSROOT)



# -----------------------------------------------------------------------------
zlib-clean:
	rm	-fr	$(ZLIB_DIR)
	rm	-fr	staging/usr/lib/libz.so.1*
	rm	-f	staging/usr/lib/libz.so.1*
	rm	-f	target/usr/lib/libz.so.1*

libpng-clean:
	rm	-fr	$(LIBPNG_DIR)
	rm	-f	staging/usr/lib/libpng14.so.*
	rm	-f	target/usr/lib/libpng14.so.*

libjpeg-clean:
	rm	-fr	$(LIBJPEG_DIR)
	rm	-f	staging/usr/lib/libjpeg.so.8*
	rm	-f	target/usr/lib/libjpeg.so.8*

libfreetype-clean:
	rm	-fr	$(FREETYPE_DIR)
	rm	-f	staging/usr/lib/libfreetype.so.6*
	rm	-f	target/usr/lib/libfreetype.so.6*

directfb-clean:
	rm	-fr	$(DIRECTFB_DIR)
	rm	-f	staging/usr/lib/libdirect-1.4.so.5*
	rm	-f	target/usr/lib/libdirect-1.4.so.5*
	rm	-f	staging/usr/lib/libdirectfb-1.4.so.5*
	rm	-f	target/usr/lib/libdirectfb-1.4.so.5*

libfusion-clean:
	rm	-fr	$(DIRECTFB_EXA_DIR)
	rm	-f	staging/usr/lib/libfusion-1.4.so.5*
	rm	-f	target/usr/lib/libfusion-1.4.so.5*

clean:	zlib-clean libpng-clean libjpeg-clean libfreetype-clean directfb-clean libfusion-clean
	rm	-fr	$(BUILD_SCRIPT)
#	rm -f	staging/usr/lib/directfb-1.4-5/
#	rm -f	target/usr/lib

distclean:	clean
	rm	-fr	$(ZLIB_SOURCE)
	rm	-fr	$(LIBPNG_SOURCE)
	rm	-fr	$(LIBJPEG_SOURCE)
	rm	-fr	$(FREETYPE_SOURCE)
	rm	-fr	$(DIRECTFB_SOURCE)
	rm	-fr	$(DIRECTFB_EXA_SOURCE)

