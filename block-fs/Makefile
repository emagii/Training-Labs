include	../host.mk

all:	rootfs.sqfs


rootfs.sqfs:	$(NFS_PATH)
	mksquashfs $(NFS_PATH) $@

