#define DEBUG_LOGS

#include <stdio.h>
#include <kernel/tty.h>
#include <kernel/serial.h>
#include <kernel/logging.h>
#include <kernel/system.h>

void configure(void) {
  tty_initialize();

  if(serial_initialize(COM1)) {
    printf("Serial initialization failed\n");
    return;
  }
}