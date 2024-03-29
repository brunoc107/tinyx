#include <stddef.h>
#include <string.h>

void* memcopy(void* restrict dstptr, const void* restrict srcptr, size_t size) {
  unsigned char* dst = (unsigned char*) dstptr;
  const unsigned char* src = (unsigned char*) srcptr;
  size_t i = 0;
  while (i < size) {
    dst[i] = src[i];
    i++;
  }
  return dstptr;
}