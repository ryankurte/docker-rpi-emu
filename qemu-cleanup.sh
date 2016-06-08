#!/bin/bash
# Bootsrap qemu into the provided directory

echo "Cleaning up Qemu"

# Remove preload file
mv $1/etc/ld.so.preload $1/etc/ld.so.preload.old
touch $1/etc/ld.so.preload

# Remove binary interpreter
#rm $1/usr/bin/qemu-arm-static

