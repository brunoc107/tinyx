#!/bin/sh
set -e
. ../grub-tools.sh

check_multiboot() {
    $(get_grub_file_command) --is-x86-multiboot2 $1
}

check_multiboot $1