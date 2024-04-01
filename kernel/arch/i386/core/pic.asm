[bits 32]
[global PIC_remap]
PIC_remap:
  ; Remap IRQs 0-7  to ISRs 32-39
  ; and   IRQs 8-15 to ISRs 40-47
  cli

  ; interrupt vectors 0x20 for IRQ 0-7
  ; interrupt vectors 0x28 for IRQ 8-15
  mov al, 0x11  ; INIT command (ICW1 + ICW4)
  out 0x20, al  ; Send INIT to PIC1
  out 0xa0, al  ; Send INIT to PIC2

  mov al, 0x20  ; PIC1 interrupts start at 0x20
  out 0x21, al  ; Send the value to PIC1 DATA
  mov al, 0x28  ; PIC2 interrupts start at 0x28
  out 0xa1, al  ; Send the value to PIC2 DATA

  mov al, 0x04  ; MASTER identifier
  out 0x21, al  ; set PIC1 as MASTER
  mov al, 0x02  ; SLAVE identifier
  out 0xa1, al  ; set PIC2 as SLAVE

  mov al, 0x01  ; This is the x86 mode code for both 8259 chips
  out 0x21, al  ; Set PIC1 mode
  out 0xa1, al  ; Set PIC2 mode

  mov ax, 0xffff  ; Set interrupt mask to disable all interrupts
  out 0x21, al    ; Set mask of PIC1_data
  xchg al, ah     ; Switch low and high bytes of the mask so we can send the high byte
                  ;   for now, it has no consequence as both are 0xff
  out 0xa1, al    ; Set mask of PIC2 data

  sti
  nop

  ret

[global PIC_enable_irq]
PIC_enable_irq:
  ; Assumes the number of the IRQ to enable is in ECX register

  ; load existing mask
  in al, 0xa1
  xchg al, ah
  in al, 0x21

  ; clear the relevant bit
  mov ebx, 1
  shl bx, cl
  not bx
  and ax, cx

  ; set the new mask
  out 0x21, al
  xchg al, ah
  in al, 0xa1

  ret