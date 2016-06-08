#!/bin/bash
# Convenience script to manage qemu inside docker container

if [ "$#" -ne 2 ] && [ "$#" -ne 3 ]; then 
    echo "Usage: $0 IMAGE MOUNT [COMMAND]"
    echo "IMAGE - raspberry pi .img file"
    echo "MOUNT - mount location in the file system"
    echo "COMMAND - optional command to execute, defaults to /bin/bash"
    exit
fi

CWD=`pwd`

set -e

# Create mount dir
mkdir -p $2

# Mount ISO
./mount.sh $1 $2

# Bootstrap QEMU
./qemu-setup.sh $2

# Launch QEMU
chroot $2 bin/bash

# Remove QEMU
./qemu-cleanup.sh $2

# Exit 
./unmount.sh $2

