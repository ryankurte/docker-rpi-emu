#!/bin/bash
#
# Bootsrap qemu into the provided directory

# Check inputs
if [ "$#" -ne 1 ]; then 
    echo "Usage: $0 MOUNT"
    echo "MOUNT - mount location in the file system"
    exit
fi

echo "Bootstrapping Qemu"

# Remove original preload file
mv $1/etc/ld.so.preload $1/etc/ld.so.preload.old
touch $1/etc/ld.so.preload

# Copy binary interpreter
cp /usr/bin/qemu-arm-static $1/usr/bin

# Mount running dirs
mount --bind /proc $1/proc/
mount --bind /dev $1/dev/
mount --bind /sys $1/sys/
mount --bind /dev/pts $1/dev/pts

