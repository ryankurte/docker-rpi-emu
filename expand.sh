#!/bin/bash
# Expand partition 2 of an ISO image the specified amount

if [ "$#" -ne 2 ]; then 
    echo "Usage: $0 IMAGE SIZE"
    echo "IMAGE - raspberry pi .img file"
    echo "SIZE - size in mb to expand image"
    exit
fi

# Attach loopback device
LOOP_BASE=`losetup -f --show $1`

echo "Attached base loopback at: $LOOP_BASE"

BLOCK_SIZE=512

# Fetch and parse partition info
P1_INFO=($`fdisk -l $LOOP_BASE | grep ${LOOP_BASE}p1`)
P2_INFO=($`fdisk -l $LOOP_BASE | grep ${LOOP_BASE}p2`)

# Locate partition 2 start address

P2_START=${P2_INFO[1]}

echo "Located ${LOOP_BASE}p2 at $P2_START"

# Attach second loopback device
LOOP_P2=`losetup -f --show -o $(($P2_START*BLOCK_SIZE)) $1`

echo "Attached p2 at $LOOP_P2"

# TODO: Repartition
parted --script /dev/loop0 \
    print \
    q

# Check and resize file system
e2fsck -f $LOOP_P2
resize2fs $LOOP_P2

# Cleanup loopbacks
losetup -d $LOOP_BASE $LOOP_P2


