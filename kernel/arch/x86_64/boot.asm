global start

extern kmain

section .rodata
gdt64:
  dq 0
.code: equ $ - gdt64
  dq (1 << 44) | (1 << 47) | (1 << 41) | (1 << 43) | ( 1<< 53)
.data: equ $ - gdt64
  dq (1 << 44) | (1 << 47) | (1 << 41)
.pointer:
  dw .pointer - gdt64 - 1
  dq gdt64

section .bss
align 4096
p4_table:
  resb 4096
p3_table:
  resb 4096
p2_table:
  resb 4096

section .text
bits 32
start:
  ;Point the first entry of p4 to the first entry in p3
  mov eax, p3_table
  or eax, 0b11
  mov dword [p4_table + 0], eax
  
  ; Point the first entry of P3 to the first entry in p2
  mov eax, p2_table
  or eax, 0b11
  mov dword [p3_table + 0], eax

  ; Point each page table level two entry to a page
  mov ecx, 0
.map_p2_table:
  mov eax, 0x200000 ; 2MiB
  mul ecx
  or eax, 0b10000011
  mov [p2_table + ecx * 8], eax
  inc ecx
  cmp ecx, 512
  jne .map_p2_table

  ; Move page table address to cr3
  mov eax, p4_table
  mov cr3, eax

  ; Enable PAE (physical address extension)
  mov eax, cr4
  or eax, 1 << 5
  mov cr4, eax

  ; Set long mode bit
  mov ecx, 0xC0000080
  rdmsr
  or eax, 1 << 8
  wrmsr

  ; Enable paging
  mov eax, cr0
  or eax, 1 << 31
  or eax, 1 << 16
  mov cr0, eax

  ; Setting GDT
  lgdt [gdt64.pointer]

  ; Update selectors
  mov ax, gdt64.data
  mov ss, ax
  mov ds, ax
  mov es, ax

  ; Jump to long mode
  jmp gdt64.code:long_mode_start  

section .text
bits 64
long_mode_start:
  call kmain
  hlt