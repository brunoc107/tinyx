#include <stddef.h>
#include <stdarg.h>
#include <string.h>
#include <stdio.h>
#include <kernel/serial.h>
#include <kernel/logging.h>

log_level_t log_level = INFO;

static char * level_dict[] = {
	"\033[1;34mINFO",
	"\033[1;35mNOTICE",
	"\033[1;33mWARNING",
	"\033[1;31mERROR",
	"\033[1;37;41mCRITICAL"
};

void _log(char * module, size_t line_no, log_level_t level, char * fmt, ...) {
  if (level >= log_level) {
		va_list args;
		va_start(args, fmt);
		char msg[1024];
		vsprintf(msg, fmt, args);
		va_end(args);
		serial_printf("[%s\033[0m] %s:%d -> %s\n\r", level_dict[level], module, line_no, msg);
	}
}
