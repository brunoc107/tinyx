#include <stdint.h>
#include <stddef.h>
#include <string.h>

void* memset(void* bufptr, uint8_t value, size_t size) {
  unsigned char* buf = (unsigned char*) bufptr;
  for (size_t i=0; i<size; i++)
    buf[i] = value;
  return bufptr;
}