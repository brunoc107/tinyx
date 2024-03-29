#include <stddef.h>
#include <string.h>

#include <kernel/tty.h>
#include <kernel/io.h>

#include "vga.h"


static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;
static const size_t VGA_BUFFER_LENGTH = VGA_WIDTH * VGA_HEIGHT * 2;
static uint16_t* const VGA_MEMORY = (uint16_t*) 0xb8000;

static size_t terminal_row;
static size_t terminal_column;
static uint8_t terminal_color;
static uint16_t* terminal_buffer;

void tty_updatecursor(void);

void tty_initialize(void) {
  terminal_row = 0;
  terminal_column = 0;
  terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREY, VGA_COLOR_BLACK);
  terminal_buffer = VGA_MEMORY;
  size_t i = 0;
  while (i < VGA_BUFFER_LENGTH) {
    terminal_buffer[i] = vga_entry(' ', terminal_color);
    i++;
  }
	tty_enable_cursor(15, 15);
	tty_updatecursor();
}

void tty_setcolor(uint8_t color) {
	terminal_color = color;
}

void tty_putentryat(unsigned char c, uint8_t color, size_t x, size_t y) {
	const size_t index = y * VGA_WIDTH + x;
	terminal_buffer[index] = vga_entry(c, color);
}

void tty_putchar(char c) {
	if (c == '\n') {
		tty_nextline();
	} else {
		unsigned char uc = c;
		tty_putentryat(uc, terminal_color, terminal_column, terminal_row);
		if (++terminal_column == VGA_WIDTH) {
			tty_nextline();
		}
	}
	tty_updatecursor();
}

void tty_write(const char* data, size_t size) {
	for (size_t i = 0; i < size; i++)
		tty_putchar(data[i]);
}

void tty_writestring(const char* data) {
	tty_write(data, strlen(data));
}

void tty_nextline(void) {
	terminal_column = 0;
	if (++terminal_row == VGA_HEIGHT) {
		tty_scroll();
	}
	tty_updatecursor();
}

void tty_scroll(void) {
	for (size_t i = 0; i < VGA_BUFFER_LENGTH; i++) {
		if (i + VGA_WIDTH < VGA_BUFFER_LENGTH)
			terminal_buffer[i] = terminal_buffer[i+VGA_WIDTH];
		else
			terminal_buffer[i] = vga_entry(' ', terminal_color);
	}
	terminal_row = VGA_HEIGHT - 1;
}

void tty_enable_cursor(uint8_t cursor_start, uint8_t cursor_end) {
	outb(0x3D4, 0x0A);
	outb(0x3D5, (inb(0x3D5) & 0xC0) | cursor_start);
	outb(0x3D4, 0x0B);
	outb(0x3D5, (inb(0x3D5) & 0xE0) | cursor_end);
}

void tty_setcursor(size_t x, size_t y) {
	uint16_t pos = y * VGA_WIDTH + x;
	outb(0x3d4, 0x0f);
	outb(0x3d5, (uint8_t) (pos & 0xff));
	outb(0x3d4, 0x0e);
	outb(0x3d5, (uint8_t) ((pos >> 8) & 0xff));
}

void tty_updatecursor(void) {
	tty_setcursor(terminal_column, terminal_row);
}