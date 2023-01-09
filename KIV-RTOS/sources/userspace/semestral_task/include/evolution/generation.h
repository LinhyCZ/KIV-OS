#pragma once

#include <hal/intdef.h>

#include "chromosome.h"
#include "model.h"

#define GEN_SIZE 100

class Generation
{
    private:
        void crossbreed(Generation *g, int index);

    public:
        Chromosome gen[GEN_SIZE];

        void evaluate_gen(float measured_value, uint32_t file, float yt, int tdelta);
        void next_gen(Generation *g);
        void init_random();
        
        float predict(float currentYt, int tdelta);
};