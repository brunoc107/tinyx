#!/bin/sh
set -e
. ./build.sh
. ./grub-tools.sh

mkdir -p build/isofiles/boot/grub
cp grub.cfg build/isofiles/boot/grub
cp sysroot/boot/kernel.bin build/isofiles/boot/
grub_mkrescue -o build/tinyx.iso build/isofiles

