#pragma once

#include <hal/intdef.h>

#include <stdfile.h>
#include <stdstring.h>

#include "dictionary.h"

#define NAN_FLOAT -1

void fputs(uint32_t file, const char* string);
void println(uint32_t file, const char* string);
void print_str_and_float(uint32_t, const char* string, float val);