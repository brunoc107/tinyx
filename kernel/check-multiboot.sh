#!/bin/sh
set -e
. ../grub-tools.sh

grub_file "--is-x86-multiboot2" $1