#include <stddef.h>
#include <stdarg.h>
#include <stdio.h>

char * format_string(char* buffer, const char* restrict format, ...) {
  va_list args;
  va_start(args, format);
  vsprintf(buffer, format, args);
  return buffer;
  va_end(args);
}