INSTALL_PATH ?= /tftpboot/busybox.static

all:	hello Hello

hello:	hello.c
	$(CC) 		-o hello hello.c

Hello:	hello.c
	$(CC) --static	-o Hello hello.c


install: hello Hello
	sudo install -d 		$(INSTALL_PATH)/usr/bin
	sudo install	-m 0755 hello	$(INSTALL_PATH)/usr/bin
	sudo install	-m 0755 Hello	$(INSTALL_PATH)/usr/bin

clean:
	rm -fr Hello hello

