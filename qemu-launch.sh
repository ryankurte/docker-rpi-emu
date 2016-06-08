#!/bin/bash
#
#

if [ "$#" -ne 1 ]; then 
    echo "Usage: $0 [PATH]"
    echo "PATH - location of rpi mount"
    exit
fi

chroot $1 bin/bash
