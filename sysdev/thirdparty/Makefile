ZLIB_SITE=http://zlib.net/
ZLIB_VERSION=1.2.8
ZLIB_DIR=zlib-$(ZLIB_VERSION)
ZLIB_SOURCE=$(ZLIB_DIR).tar.gz
ZLIB_URI=$(ZLIB_SITE)/$(ZLIB_SOURCE)

all:	$(ZLIB_DIR)/.extracted

$(ZLIB_DIR)/.extracted:	$(ZLIB_SOURCE)
	tar -zxvf $(ZLIB_SOURCE)

$(ZLIB_SOURCE):
	wget	$(ZLIB_URI)


