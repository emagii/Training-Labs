#!/bin/sh
export ARCH=arm
export SDK=/opt/poky/1.6/sysroots/x86_64-pokysdk-linux
export GNUTOOLS=${SDK}/usr/bin/arm-poky-linux-gnueabi
export PATH=${GNUTOOLS}:${PATH}
export CROSS_COMPILE=arm-poky-linux-gnueabi-

