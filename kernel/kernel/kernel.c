#define DEBUG_LOGS

#include <kernel/tty.h>
#include <kernel/serial.h>
#include <kernel/logging.h>

#include <stdio.h>
#include <string.h>

void kmain(void) {
  tty_initialize();
  printf("tinyx\n");

  if(serial_initialize(COM1)) {
    printf("Serial initialization failed\n");
    return;
  }

  log(INFO, "Received: %s", "DISGRACE");

  char serial_data[1024];
  while (1) {
    if (serial_readstring(COM1, serial_data, 1024)) {
      printf("COM1: %s\n", serial_data);
      log(CRITICAL, "Received: %s", serial_data);
    }
  }

  return;
}
