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

# Loopback mount is used to determine block offset for partition mounting

# Attach loopback device
LOOP_BASE=`losetup -f --show $1`

echo "Attached base loopback at: $LOOP_BASE"

# TODO: could grab this from fdisk instead of hard coding
BLOCK_SIZE=512

# Fetch and parse partition info
P1_INFO=($`fdisk -l $LOOP_BASE | grep ${LOOP_BASE}p1`)
P2_INFO=($`fdisk -l $LOOP_BASE | grep ${LOOP_BASE}p2`)

# Locate partition start sectors
P1_START=${P1_INFO[1]}
P2_START=${P2_INFO[1]}

echo "Located partitions: p1 (/boot) at $P1_START and p2 (/) at $P2_START"

# Cleanup loopbacks
losetup -d $LOOP_BASE
echo "Closed loopback $LOOP_BASE"

# Mount image with the offsets determined above
mkdir -p $2
mount $1 -o loop,offset=$(($P2_START*$BLOCK_SIZE)),rw $2
mount $1 -o loop,offset=$(($P1_START*$BLOCK_SIZE)),sizelimit=$((($P2_START-$P1_START)*$BLOCK_SIZE)),rw $2/boot

echo "Mounted to $2 and $2/boot"



