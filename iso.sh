#!/bin/sh
set -e
. ./build.sh
. ./grub-tools.sh

DEFAULT_HOST=$(sh ./default-host.sh)
ARCH=$(sh ./target-triplet-to-arch.sh $DEFAULT_HOST)

if [ $ARCH="i386" ]
then
  MULTIBOOT="multiboot"
elif [ $ARCH="x86_64" ]
then
  MULTIBOOT="multiboot2"
else
  echo "Invalid architecture: '$ARCH'"
  exit 1
fi

mkdir -p build/isofiles/boot/grub
cat > grub.cfg << EOF
menuentry "tinyx" {
  $MULTIBOOT /boot/kernel.bin
  boot
}
EOF
mv grub.cfg build/isofiles/boot/grub
cp sysroot/boot/kernel.bin build/isofiles/boot/
grub_mkrescue -o build/tinyx.iso build/isofiles

