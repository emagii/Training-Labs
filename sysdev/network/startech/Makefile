
URI_SITE=http://www.asix.com.tw/FrootAttach/driver

SRC_DIR=AX88179_178A_LINUX_DRIVER_v1.9.0_SOURCE

SRC=$(SRC_DIR).tar.bz2

all:	$(SRC_DIR)/.extracted

$(SRC):
	wget	$(URI_SITE)/$(SRC)


$(SRC_DIR)/.extracted:	$(SRC)
	tar	-jxvf	$(SRC)
	touch	$@

$(SRC_DIR)/.gitignore:	$(SRC_DIR)/.extracted
	echo	"*.ko"		> $@
	echo	"*.o"		>> $@
	echo	"*.ko.cmd"	>> $@
	echo	"*.o.cmd"	>> $@
	echo	"*.mod.c"	>> $@
	echo	".patched"	>> $@
	echo	".extracted"	>> $@
	echo	".tmp*"		>> $@
	echo	"Module*"	>> $@
	echo	"modules*"	>> $@
	(cd $(SRC_DIR) ; git init ; git add . ; git commit -m "Initial Commit" -s)

$(SRC_DIR)/.patched:	$(SRC_DIR)/.gitignore
	(cd $(SRC_DIR) ; git am ../patches/*)
	touch	$@

compile:	$(SRC_DIR)/ax88179_178a.ko

$(SRC_DIR)/ax88179_178a.ko:	$(SRC_DIR)/.patched
	make -C $(SRC_DIR)

install:	$(SRC_DIR)/ax88179_178a.ko
	make -C $(SRC_DIR)	install

clean:	$(SRC_DIR)/.extracted
	sudo make -C $(SRC_DIR)	clean
	rm	-fr	$(SRC_DIR)

prepare:
	sudo apt-get	install	kernel-source
