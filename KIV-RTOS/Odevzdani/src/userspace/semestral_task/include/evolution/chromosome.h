#pragma once

#include <rnd_generator.h>
#include <model.h>

#define PARAM_COUNT 5

enum Params : int
{
    A = 0,
    B = 1,
    C = 2,
    D = 3,
    E = 4,
};

class Chromosome
{
    private:
        float params[5] = {0}; // parameters: A, B, C, D, E
        float fit = 0;
        float bt(float yt, int tdelta);

    public:
        float fitness(float &measured_value, float yt, int tdelta);
        void mutate();
        Chromosome crossover(Chromosome &other);
        void init_randomly();
        float get_fitness();
        bool operator < (Chromosome const &obj);
        bool operator > (Chromosome const &obj);
        float predict(float yt, int tdelta);
        Model get_model();
};