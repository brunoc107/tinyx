#include <stddef.h>
#include <string.h>

char* strrev(char* str) {
  size_t start = 0;
  size_t end = strlen(str) -1;
  while (start < end) {
    char tmp = str[start];
    str[start] = str[end];
    str[end] = tmp;
    start++;
    end--;
  }
  return str;
}
