#!/bin/sh
set -e
. ./build.sh

mkdir -p build/isofiles/boot/grub
cp grub.cfg build/isofiles/boot/grub
cp sysroot/boot/myos.kernel build/isofiles/boot/
grub-mkrescue -o build/os.iso build/isofiles

