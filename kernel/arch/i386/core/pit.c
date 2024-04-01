#include <stdint.h>
#include <kernel/isr.h>
#include <stdio.h>
#include <kernel/io.h>

uint32_t tick = 0;

static void timer_callback(uint8_t code)
{
  tick++;
  printf("[%d] Timer callback: %d\n", code, tick);
  if (tick == 1000) {
    tick = 0;
  }
}

void init_timer(uint32_t frequency) {
  register_interrupt_handler(IRQ0, timer_callback);

  uint32_t divisor = 1193180 / frequency;

  outb(0x43, 0x36);

  outb(0x40, (uint8_t) (divisor & 0xff));
  outb(0x40, (uint8_t) (divisor >>8) & 0xff);
}