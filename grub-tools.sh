#!/bin/sh

get_grub_file_command() {
    if command -v "grub-file" &>/dev/null; then
        echo "grub-file"
    elif command -v "grub2-file" &>/dev/null; then
        echo "grub2-file"
    fi
}

get_grub_mkrescue_command() {
    if command -v "grub-file" &>/dev/null; then
        echo "grub-mkrescue"
    elif command -v "grub2-file" &>/dev/null; then
        echo "grub2-mkrescue"
    fi
}