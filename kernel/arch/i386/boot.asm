[bits 32]
[GLOBAL start]                  ; Kernel entry point.
[EXTERN kmain]                  ; This is the entry point of our C code

MULTIBOOT_INFO_STRUCTURE dd 0
MULTIBOOT_INFO_MEMORY_HIGH dd 0
MULTIBOOT_INFO_MEMORY_LOW dd 0

; Here is the definition of our BSS section. Right now, we'll use
; it just to store the stack. Remember that a stack actually grows
; downwards, so we declare the size of the data before declaring
; the identifier '_sys_stack'
SECTION .bss
    resb 0xffff               ; This reserves 8KBytes of memory here
_sys_stack:

SECTION .text

; ####################################### GDT begin #######################################
GDT_entries_start:
db 0, 0, 0, 0, 0, 0, 0, 0             ; Offset: 0x00  0 - NULL selector
db 255, 255, 0, 0, 0, 0x9a, 0xcf, 0   ; Offset: 0x08  8 - Kernel code selector
db 255, 255, 0, 0, 0, 0x92, 0xcf, 0   ; Offset: 0x10 16 - Kernel data selector
db 255, 255, 0, 0, 0, 0xfa, 0xcf, 0   ; Offset: 0x18 24 - User code selector
db 255, 255, 0, 0, 0, 0xf2, 0xcf, 0   ; Offset: 0x20 32 - User data selector
GDT_entries_end:

GDT_SIZE equ (GDT_entries_end - GDT_entries_start) -1  ; Calculating the GDT size

GDT_pointer db GDT_SIZE, 0, 0, 0, 0, 0

; This function is responsible to load the GDT into the processor
; gdtr register
GDT_flush:
  ; BEGIN GDT flush
  mov dword [GDT_pointer + 2], GDT_entries_start
  mov dword eax, GDT_pointer
  lgdt [eax]
  ; set data segments
  mov dword eax, 0x10
  mov word ds, eax
  mov word es, eax
  mov word fs, eax
  mov word gs, eax
  mov word ss, eax
  ; force reload CS
  jmp 0x8:continue
continue:
  ret
; ######################################## GDT end ########################################

start:
  cli

  ; BEGIN multiboot info
  mov dword ecx, 0x2badb002
  cmp ecx, eax
  jne mb_fail
  mov dword [MULTIBOOT_INFO_STRUCTURE], ebx
  add dword ebx, 0x4
  mov dword eax, [ebx]
  mov dword [MULTIBOOT_INFO_MEMORY_LOW], eax
  add dword ebx, 0x4
  mov dword eax, [ebx]
  mov dword [MULTIBOOT_INFO_MEMORY_LOW], eax
  ; END multiboot info

  push ebx                   ; Load multiboot header location

  mov dword esp, _sys_stack

  call GDT_flush

  ; Execute the kernel:
  call kmain                  ; call our main() function.
  jmp $                       ; Enter an infinite loop, to stop the processor
                              ; executing whatever rubbish is in the memory
                              ; after our kernel!

mb_fail:
  ; BEGIN Red screen of death?
  mov dword eax, 0x4f20  ; bg: 4 = red, fg: f = white
  mov dword ebx, 0xb8000 ; display buffer address
  mov dword ecx, 2000    ; 80 x 25
  .colour_output:
    mov byte [ebx], al
    add ebx, 1
    mov byte [ebx], ah
    add ebx, 1
  loop .colour_output
  ; END red screen of death
halt:
  jmp halt
