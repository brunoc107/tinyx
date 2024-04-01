#include <stdint.h>
#include <stdio.h>
#include <kernel/io.h>
#include <kernel/isr.h>

#define PIC1 0x20
#define PIC2 0xa0
#define EOI 0x20

isr_t interrupt_handlers[256];

void common_interrupt_handler(uint32_t code)
{
  if (code < 32) {
    printf("ISR: %d\n", code);
  } else {
    if (interrupt_handlers[code] != 0)
    {
        isr_t handler = interrupt_handlers[code];
        handler(code);
    }

    if (code >= 40)
      outb(PIC2, EOI);
    outb(PIC1, EOI);
  }
}

void register_interrupt_handler(uint8_t n, isr_t handler)
{
  interrupt_handlers[n] = handler;
}