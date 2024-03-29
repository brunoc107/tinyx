#ifndef _KERNEL_IO_H_
#define _KERNEL_IO_H_

#include <stdint.h>

void outb(uint16_t, uint8_t);
uint8_t inb(uint16_t);

#endif