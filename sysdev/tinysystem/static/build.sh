#!/bin/sh
. ../../toolchain.sh
make clean
make configure
cd busybox-1.22.1
make -j 2
make install
cd ..
make misc

