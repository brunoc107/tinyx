#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <stdio.h>
#include <kernel/serial.h>
#include <kernel/io.h>

int serial_initialize(uint16_t port) {
  outb(port + 1, 0x00); // Disable all interrupts
  outb(port + 3, 0x80); // Enable DLAB (Divisor Latch Access Bit) to set divisor
  outb(port + 0, 0x03); // Set divisor to 3 (lo byte) 38400 baud
  outb(port + 1, 0x00); //                  (hi byte)
  outb(port + 3, 0x03); // 8 bits, no parity, one stop bit
  outb(port + 2, 0xc7); // Enable FIFO, clear them, 14 byte threshold
  outb(port + 4, 0x0b); // IRQs enabled, RTS/DSR set
  outb(port + 4, 0x1e); // Set loopback mode to test serial chip
  outb(port + 0, 0xae); // Send a byte to check if it will return the same

  // check if serial is falty (returned byte is not the same as sent)
  if (inb(port + 0) != 0xae)
    return 1;
  
  // Set normal mode operation (disable loopback)
  outb(port + 4, 0x0f);
  return 0;
}

int serial_received(uint16_t port) {
  return inb(port + 5) & 1;
}

char serial_readb(uint16_t port) {
  while (!serial_received(port));
  return inb(port);
}

int serial_readstring(uint16_t port, char * buffer, size_t buffer_size) {
  char c;
  size_t i = 0;
  while ((c = serial_readb(port))) {
    if (i == buffer_size || c == 13) {
      buffer[i] = '\0';
      break;
    } else
      buffer[i] = c;
    i++;
  }
  return i;
}

int serial_transmit_empty(uint16_t port) {
  return inb(port + 5) & 0x20;
}

void serial_writeb(uint16_t port, char c) {
  while(!serial_transmit_empty(port));
  outb(port, c);
}

int serial_writestring(uint16_t port, const char * buffer, size_t buffer_size) {
  size_t i = 0;
  while (i < buffer_size) {
    serial_writeb(port, buffer[i]);
    i++;
  }
  return i;
}
