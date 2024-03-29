#include <kernel/tty.h>
#include <stdio.h>

void kmain(void) {
  tty_initialize();
  unsigned int i = 0;
  while (1) {
    printf("Hello, tinyx: %d\n", i);
    i++;
  }
  return;
}