#ifndef _KERNEL_SERIAL_H_
#define _KERNEL_SERIAL_H_

#include <stddef.h>
#include <stdint.h>

#define COM1 0x3f8
#define COM2 0x2f8
#define COM3 0x3e8
#define COM4 0x2e8
#define COM5 0x5f8
#define COM6 0x4f8
#define COM7 0x5e8
#define COM8 0x4e8

int serial_initialize(uint16_t port);

char serial_readb(uint16_t port);
int serial_readstring(uint16_t port, char * buffer, size_t buffer_size);

void serial_writeb(uint16_t port, char c);
int serial_writestring(uint16_t port, const char * buffer, size_t buffer_size);

#endif