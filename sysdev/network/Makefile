include	../host.mk

nfs:
	mkdir -p	$(NFS_PATH)
	@echo		"$(NFS_PATH) *(rw,sync,no_root_squash,no_subtree_check)"	> etc_export
	@echo		"Append the contents of etc_exports to /etc/exports"
	@echo		"Then run 'exportfs -av'"

tftp:
	@sudo		mkdir	-p		/etc/xinetd.d
	@(if ! [ -e /etc/xinetd.d/tftp ] ; then 			\
		sudo	cp	tftp	/etc/xinetd.d;		\
	 else								\
		echo "/etc/xinetd.d/tftp exists";			\
	 fi)

startech-usb:
	make	-C startech	install
