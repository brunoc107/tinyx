#!/bin/sh

grub_file () {
    if command -v "grub-file" &>/dev/null; then
        grub-file $1 $2
    elif command -v "grub2-file" &>/dev/null; then
        grub2-file $1 $2
    fi
}

grub_mkrescue () {
    if command -v "grub-file" &>/dev/null; then
        grub-mkrescue $@
    elif command -v "grub2-file" &>/dev/null; then
        grub2-mkrescue $@
    fi
}