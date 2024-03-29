#include <stddef.h>
#include <string.h>

int memcmp(const void* a, const void* b, size_t size) {
  const unsigned char * a_ptr = (const unsigned char*) a;
  const unsigned char * b_ptr = (const unsigned char*) b;
  size_t i = 0;
  while (i < size) {
    if (a_ptr[i] < b_ptr[i])
      return -1;
    else if (a_ptr[i] > b_ptr[i])
      return 1;
    i++;
  }
  return 0;
}