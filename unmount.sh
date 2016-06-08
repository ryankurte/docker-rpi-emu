#!/bin/bash

umount $1/boot
umount $1

echo "Unmounted $1 and $1/boot"
