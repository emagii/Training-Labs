#!/bin/sh


make	CFG=httpd	configure
cd	busybox-1.22.1
make
make	install
cd	..
make	misc
make	libc
