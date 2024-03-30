#define DEBUG_LOGS

#include <kernel/tty.h>
#include <kernel/serial.h>
#include <kernel/logging.h>
#include <kernel/system.h>

#include <stdio.h>
#include <string.h>

void kmain(void) {
  configure();

  // tmp test routine
  char serial_data[1024];
  while (1) {
    if (serial_readstring(COM1, serial_data, 1024)) {
      printf("COM1: %s\n", serial_data);
      log(INFO, "Received: %s", serial_data);
    }
  }

  return;
}
