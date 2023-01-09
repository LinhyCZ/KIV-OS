#pragma once

#include <hal/intdef.h>

#define RND_NOT_INITIALIZED -1

class Rnd_Generator
{
private:
    uint32_t rnd_file;
public:
    int generate_int(int32_t low, int32_t high);
    float generate(int32_t low, int32_t high);
    void set_generator(uint32_t file);
};

extern Rnd_Generator rnd;