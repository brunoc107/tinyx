#ifndef _KERNEL_TTY_H_
#define _KERNEL_TTY_H_

#include <stdint.h>
#include <stddef.h>

void tty_initialize(void);
void tty_setcolor(uint8_t color);
void tty_putentryat(unsigned char c, uint8_t color, size_t x, size_t y);
void tty_putchar(char c);
void tty_write(const char* data, size_t size);
void tty_writestring(const char* data);
void tty_nextline(void);
void tty_scroll(void);
void tty_enable_cursor(uint8_t cursor_start, uint8_t cursor_end);
void tty_setcursor(size_t x, size_t y);

#endif
