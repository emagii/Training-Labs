
TOPDIR=$(PWD)

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


all:	source

source:	zlib-source libpng-source libjpeg-source freetype-source directfb-source directfb-exa-source

install: zlib-install libpng-install libjpeg-install freetype-install directfb-install directfb-exa-install

# -----------------------------------------------------------------------------
zlib-source:	$(ZLIB_DIR)/.extracted

$(ZLIB_DIR)/.extracted:	$(ZLIB_SOURCE)
	tar -zxvf $(ZLIB_SOURCE)
	touch	$@

$(ZLIB_SOURCE):
	wget	$(ZLIB_URI)

zlib-install:
	sudo mkdir -p target/usr/lib
	sudo cp	-a staging/usr/lib/libz.so.1*	target/usr/lib

# -----------------------------------------------------------------------------
libpng-source:	$(LIBPNG_DIR)/.extracted

$(LIBPNG_DIR)/.extracted:	$(LIBPNG_SOURCE)
	tar -zxvf $(LIBPNG_SOURCE)
	touch	$@

$(LIBPNG_SOURCE):
	wget	$(LIBPNG_URI)

libpng-install:
	sudo cp -a staging/usr/lib/libpng14.so.* target/usr/lib


# -----------------------------------------------------------------------------
libjpeg-source:	$(LIBJPEG_DIR)/.extracted

$(LIBJPEG_DIR)/.extracted:	$(LIBJPEG_SOURCE)
	tar -zxvf $(LIBJPEG_SOURCE)
	touch	$@

$(LIBJPEG_SOURCE):
	wget	$(LIBJPEG_URI)

libjpeg-install:
	sudo cp -a staging/usr/lib/libjpeg.so.8* target/usr/lib/

# -----------------------------------------------------------------------------
freetype-source:	$(FREETYPE_DIR)/.extracted

$(FREETYPE_DIR)/.extracted:	$(FREETYPE_SOURCE)
	tar -zxvf $(FREETYPE_SOURCE)
	touch	$@

$(FREETYPE_SOURCE):
	wget	$(FREETYPE_URI)

freetype-install:
	sudo cp -a staging/usr/lib/libfreetype.so.6* target/usr/lib/

# -----------------------------------------------------------------------------
directfb-source:	$(DIRECTFB_DIR)/.extracted

$(DIRECTFB_DIR)/.extracted:	$(DIRECTFB_SOURCE)
	tar -zxvf $(DIRECTFB_SOURCE)
	touch	$@

$(DIRECTFB_SOURCE):
	wget	$(DIRECTFB_URI)

directfb-install:
	sudo cp -a staging/usr/lib/libdirect-1.4.so.5* target/usr/lib
	sudo cp -a staging/usr/lib/libdirectfb-1.4.so.5* target/usr/lib
	sudo cp -a staging/usr/lib/libfusion-1.4.so.5* target/usr/lib
	sudo cp -a staging/usr/lib/directfb-1.4-5/ target/usr/lib

# -----------------------------------------------------------------------------
directfb-exa-source:	$(DIRECTFB_EXA_DIR)/.extracted

$(DIRECTFB_EXA_DIR)/.extracted:	$(DIRECTFB_EXA_SOURCE)
	tar -zxvf $(DIRECTFB_EXA_SOURCE)
	touch	$@

$(DIRECTFB_EXA_SOURCE):
	wget	$(DIRECTFB_EXA_URI)

directfb-exa-install:

# -----------------------------------------------------------------------------
clean:
	rm	-fr	$(ZLIB_SOURCE)		$(ZLIB_DIR)
	rm	-fr	$(LIBPNG_SOURCE)	$(LIBPNG_DIR)
	rm	-fr	$(LIBJPEG_SOURCE)	$(LIBJPEG_DIR)
	rm	-fr	$(FREETYPE_SOURCE)	$(FREETYPE_DIR)
	rm	-fr	$(DIRECTFB_SOURCE)	$(DIRECTFB_DIR)
	rm	-fr	$(DIRECTFB_EXA_SOURCE)	$(DIRECTFB_EXA_DIR)
