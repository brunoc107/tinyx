#include <stddef.h>
#include <stdarg.h>
#include <stdio.h>
#include <string.h>
#include <kernel/serial.h>

int serial_printf(const char* restrict format, ...) {
  size_t i;
  char buf[1024];
  va_list args;
  va_start(args, format);
  
  i = vsprintf(buf, format, args);
  serial_writestring(COM1, buf, strlen(buf));

  return i;

  va_end(args);
}
