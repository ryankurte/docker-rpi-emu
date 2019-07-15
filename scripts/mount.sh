#!/bin/bash
#
# Script to determine offsets and mount a provided raspbian image to a provided location
# This requires fdisk and permission to run the `mount` command, which is provided when
# run from the docker container.

# Check inputs
if [ "$#" -ne 2 ]; then 
    echo "Usage: $0 IMAGE MOUNT"
    echo "IMAGE - raspberry pi .img file"
    echo "MOUNT - mount location in the file system"
    exit
fi

if [ ! -f $1 ]; then
	echo "Image file $1 does not exist"
	exit 1
fi

if [ ! -d $2 ]; then
	echo "Mount point $2 does not exist"
	exit 2
fi

echo "Attempting to mount $1 to $2"

set -e

LOOP=$(losetup --show -fP "${1}")
mount "${LOOP}p2" "${2}"
mount "${LOOP}p1" "${2}/boot/"

echo "Mounted to $2 and $2/boot"



