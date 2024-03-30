section .multiboot_header

MBOOT_PAGE_ALIGN    equ 1<<0    ; Load kernel and modules on a page boundary
MBOOT_MEM_INFO      equ 1<<1    ; Provide your kernel with memory info
MBOOT_HEADER_MAGIC  equ 0x1BADB002 ; Multiboot Magic value
; NOTE: We do not use MBOOT_AOUT_KLUDGE. It means that GRUB does not
; pass us a symbol table.
MBOOT_HEADER_FLAGS  equ MBOOT_PAGE_ALIGN | MBOOT_MEM_INFO
MBOOT_CHECKSUM      equ -(MBOOT_HEADER_MAGIC + MBOOT_HEADER_FLAGS)

header_start:
  dd MBOOT_HEADER_MAGIC                   ; multiboot magic number
  dd MBOOT_HEADER_FLAGS
  ; checksum
  dd MBOOT_CHECKSUM

  ; end tag
  dw 0  ; type
  dw 0  ; flags
  dd 8  ; size
header_end:
