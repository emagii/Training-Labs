INSTALL_PATH ?= /tftpboot/busybox.static

all:	hello Hello

hello:	hello.c
	$(CC) 		-o hello hello.c

Hello:	hello.c
	$(CC) --static	-o Hello hello.c


install: hello Hello libs
	sudo install -d 		$(INSTALL_PATH)/usr/bin
	sudo install	-m 0755 hello	$(INSTALL_PATH)/usr/bin
	sudo install	-m 0755 Hello	$(INSTALL_PATH)/usr/bin

libs:
	sudo install	-m 0755 ${SDKTARGETSYSROOT}/lib/ld-2.19.so	$(INSTALL_PATH)/lib/ld-2.19.so
	sudo ln -s	ld-2.19.so					$(INSTALL_PATH)/lib/ld-linux-armhf.so-3
	
clean:
	rm -fr Hello hello

