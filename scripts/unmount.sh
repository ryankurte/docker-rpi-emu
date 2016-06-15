#!/bin/bash
#
# Convenience script to unmount rpi file system mounted using the included mount.sh
# helper script

if [ "$#" -ne 1 ]; then 
    echo "Usage: $0 MOUNT"
    echo "MOUNT - mount location in the file system"
    exit
fi

umount $1/boot
umount $1

echo "Unmounted $1 and $1/boot"
