#include <stddef.h>
#include <stdarg.h>
#include <stdio.h>
#include <kernel/tty.h>

static char buf[1024];

int printf(const char* restrict format, ...) {
  size_t i;
  va_list args;
  va_start(args, format);
  
  i = vsprintf(buf, format, args);
  tty_writestring(buf);

  return i;

  va_end(args);
}