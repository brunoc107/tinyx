#ifndef _STDIO_H
#define _STDIO_H

#include <sys/cdefs.h>

#include <stddef.h>
#include <stdint.h>

#ifdef __cplusplus
extern "C" {
#endif

int vsprintf(char*, const char* __restrict, ...);
int printf(const char* __restrict, ...);

#ifdef __cplusplus
}
#endif

#endif
