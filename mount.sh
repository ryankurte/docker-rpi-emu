#!/bin/bash

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

# Attach loopback device
LOOP_BASE=`losetup -f --show $1`

echo "Attached base loopback at: $LOOP_BASE"

BLOCK_SIZE=512

# Fetch and parse partition info
P1_INFO=($`fdisk -l $LOOP_BASE | grep ${LOOP_BASE}p1`)
P2_INFO=($`fdisk -l $LOOP_BASE | grep ${LOOP_BASE}p2`)

# Locate partition 2 start address
P1_START=${P2_INFO[1]}
P2_START=${P2_INFO[1]}

echo "Located partitions: p1 at $P1_START p2 at $P2_START"

# Cleanup loopbacks
losetup -d $LOOP_BASE
echo "Closed loopback $LOOP_BASE"

mkdir -p $2
mount $1 -o loop,offset=$(($P1_START*$BLOCK_SIZE)),rw $2
mount $1 -o loop,offset=$(($P2_START*$BLOCK_SIZE)),rw $2/boot

echo "Mounted to $2 and $2/boot"



