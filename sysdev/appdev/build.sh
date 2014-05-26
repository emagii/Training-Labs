#!/bin/sh

.  ~/felabs/sysdev/toolchain.sh

export LDFLAGS=-L/home/ulf/felabs/sysdev/thirdparty/staging/usr/lib
export CPPFLAGS=-I/home/ulf/felabs/sysdev/thirdparty/staging/usr/include 
export PKG_CONFIG_PATH=/home/ulf/felabs/sysdev/thirdparty/staging/usr/lib/pkgconfig
export PKG_CONFIG_SYSROOT_DIR=/home/ulf/felabs/sysdev/thirdparty/staging
export TOOLCHAIN_SYSROOT=$(${CROSS_COMPILE}gcc -print-sysroot)


${CC} -o app data/app.c $(pkg-config --libs --cflags directfb) ${LDFLAGS}


