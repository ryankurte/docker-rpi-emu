#!/bin/bash
#
# Bootsrap qemu into the provided directory

# Check inputs
if [ "$#" -ne 1 ]; then 
    echo "Usage: $0 MOUNT"
    echo "MOUNT - mount location in the file system"
    exit
fi

echo "Cleaning up Qemu"

PRELOAD_FILE=$1/etc/ld.so.preload

# Revert to original preload file (if backup exists)
if [ ! -f $PRELOAD_FILE ]; then
	rm $PRELOAD_FILE
	mv $PRELOAD_FILE.old $PRELOAD_FILE
fi

QEMU_BIN=$1/usr/bin/qemu-arm-static

# Remove binary interpreter
if [ ! -f $QEMU_BIN ]; then
	rm $QEMU_BIN
fi

# Unmount dirs
umount $1/dev/pts
umount $1/sys/
umount $1/dev/
umount $1/proc/

