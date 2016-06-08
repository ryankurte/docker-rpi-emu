#!/bin/bash
# Bootsrap qemu into the provided directory

echo "Bootstrapping Qemu"

# Remove original preload file
mv $1/etc/ld.so.preload $1/etc/ld.so.preload.old
touch $1/etc/ld.so.preload

# Copy binary interpreter
#cp /usr/bin/qemu-arm-static $1/usr/bin

