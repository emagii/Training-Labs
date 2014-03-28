#!/bin/sh
TOPDIR=`pwd`
LIBDIR=crosstool-ng-armv7a/.build/.build/arm-unknown-linux-uclibcgnueabihf/build/build-libc

if [[ "x$1" == "x" ]]; then
NFS_PATH=${HOME}/rootfs
else
NFS_PATH=$1	
fi

cd	${LIBDIR}
tar	-cvf	${TOPDIR}/uClibc.tar	lib

cd	${TOPDIR}
tar	-xvf	uClibc.tar	-C ${NFS_PATH}

