#!/bin/sh
set -e
. ./build.sh
. ./grub-tools.sh

mkdir -p build/isofiles/boot/grub
cp grub.cfg build/isofiles/boot/grub
cp sysroot/boot/myos.kernel build/isofiles/boot/
$(get_grub_mkrescue_command) -o build/os.iso build/isofiles

