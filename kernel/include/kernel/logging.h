#ifndef _KERNEL_LOGGING_H
#define _KERNEL_LOGGING_H

#include <stddef.h>
#include <stdarg.h>

typedef enum {
  INFO = 0,
  NOTICE,
  WARNING,
  ERROR,
  CRITICAL
} log_level_t;

#ifndef MODULE_NAME
#define MODULE_NAME __FILE__
#endif

void _log(char * module,  size_t line_no, log_level_t level, char * format, ...);

#ifdef DEBUG_LOGS
#define log(level, ...) _log(MODULE_NAME, __LINE__, level, __VA_ARGS__)
#else
#define log(level, ...)
#endif

#endif