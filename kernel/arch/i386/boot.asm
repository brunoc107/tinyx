[bits 32]
[GLOBAL start]                  ; Kernel entry point.
[EXTERN kmain]                  ; This is the entry point of our C code

KERNEL_VIRTUAL_BASE equ 0xc0000000                  ; Constant that declares the base of a HigherHalf kernel
KERNEL_PAGE_TABLE   equ (KERNEL_VIRTUAL_BASE >> 22) ; Constant declaring page table index in virtual memory

MULTIBOOT_INFO_STRUCTURE dd 0
MULTIBOOT_INFO_MEMORY_HIGH dd 0
MULTIBOOT_INFO_MEMORY_LOW dd 0

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
  mov dword [GDT_pointer - KERNEL_VIRTUAL_BASE + 2], (GDT_entries_start - KERNEL_VIRTUAL_BASE)
  mov dword eax, (GDT_pointer - KERNEL_VIRTUAL_BASE)
  lgdt [eax]
  ; set data segments
  mov dword eax, 0x10
  mov word ds, eax
  mov word es, eax
  mov word fs, eax
  mov word gs, eax
  mov word ss, eax
  ; force reload CS
  jmp 0x8:(continue - KERNEL_VIRTUAL_BASE)
continue:
  ret
; ######################################## GDT end ########################################

start:
  cli

  ; BEGIN multiboot info
  mov dword ecx, 0x2badb002
  cmp ecx, eax
  jne (mb_fail - KERNEL_VIRTUAL_BASE)
  mov dword [MULTIBOOT_INFO_STRUCTURE - KERNEL_VIRTUAL_BASE], ebx
  add dword ebx, 0x4
  mov dword eax, [ebx]
  mov dword [MULTIBOOT_INFO_MEMORY_LOW - KERNEL_VIRTUAL_BASE], eax
  add dword ebx, 0x4
  mov dword eax, [ebx]
  mov dword [MULTIBOOT_INFO_MEMORY_LOW - KERNEL_VIRTUAL_BASE], eax
  ; END multiboot info

  push ebx                   ; Load multiboot header location

  mov dword esp, (_sys_stack - KERNEL_VIRTUAL_BASE)

  call GDT_flush

  ; ##################################### PAGING begin ######################################
  ; Set virtual memory
  ; 1. Map virtual memory for physical address execution
  lea eax, [page_table1 - KERNEL_VIRTUAL_BASE]
  mov ebx, 0b111                                ; Flags: (Present: ON, RW: ON, User/Supervisor: ON)
  mov ecx, (4 * 1024)                           ; * of tables * # of entries per page
  .paging_loop1:
    mov [eax], ebx
    add eax, 4                                  ; Move to next entry in page table
    add ebx, 4096                               ; Update physical address to which to set the next page table antry to (4 KiB down)
    loop .paging_loop1

  lea eax, [page_table1 - KERNEL_VIRTUAL_BASE]
  add eax, (KERNEL_PAGE_TABLE * 1024 * 4)
  mov ebx, 0b111                                ; Flags: (Present: ON, RW: ON, User/Supervisor: ON)
  mov ecx, (4 * 1024)                           ; * of tables * # of entries per page
  .paging_loop2:
    mov [eax], ebx
    add eax, 4                                  ; Move to next entry in page table
    add ebx, 4096                               ; Update physical address to which to set the next page table antry to (4 KiB down)
    loop .paging_loop2

  lea ebx, [page_table1 - KERNEL_VIRTUAL_BASE]
  lea edx, [page_directory - KERNEL_VIRTUAL_BASE]
  or ebx, 0b111                                 ; Flags: (Present: ON, RW: ON, User/Supervisor: ON)
  mov ecx, 1024                                 ; * of tables * # of entries per page
  .paging_loop3
    mov [edx], ebx
    add edx, 4                                  ; Move to next entry in page table
    add ebx, 4096                               ; Update physical address to which to set the next page table antry to (4 KiB down)
    loop .paging_loop3

  ; 2. Set page directory
  ; Load the physical address of the page directory and move it into CR3
  lea ecx, [page_directory - KERNEL_VIRTUAL_BASE]
  mov cr3, ecx

  ; 3. Enable paging
  ; Set cr0
  mov eax, cr0
  or eax, 0x80000001
  mov cr0, eax
  ; ###################################### PAGING end #######################################

  ; Execute the kernel:
  lea eax, [kmain - KERNEL_VIRTUAL_BASE]
  call eax                    ; call our main() function.
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

; Here is the definition of our BSS section. Right now, we'll use
; it just to store the stack. Remember that a stack actually grows
; downwards, so we declare the size of the data before declaring
; the identifier '_sys_stack'
SECTION .bss
    resb 0xffff               ; This reserves 8KBytes of memory here
_sys_stack:

; Reserving paging space
GLOBAL page_table1:data
GLOBAL page_directory:data

ALIGN 4096
page_table1: resb (1024 * 4 * 1024) ; Reserve uninitialized space for page table
                                    ; # of entries/page table * 4 bytes/entry * total # of page tables
                                    ; total size: 4194304 bytes = 4MiB, represents 4GiB in physical memory
                                    ; each 4 byte entry represents 4 KiB in physical memory
page_directory: resb (1024 * 4 *1)  ; Reserve uninitialized space for page directory
