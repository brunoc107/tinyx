#!/bin/sh
set -e
. ../grub-tools.sh

if [ $1="i386" ]
then
  FILE_TYPE="--is-x86-multiboot"
elif [ $1="x86_64" ]
then
  FILE_TYPE="--is-x86-multiboot2"
fi

echo "grub_file $FILE_TYPE $2";

grub_file $FILE_TYPE $2