#include <generation.h>

#include <stdfile.h>
#include <stdstring.h>
#include <quicksort.h>

void Generation::evaluate_gen(float measured_value, uint32_t file, float yt, int tdelta)
{
    for (int i = 0; i < GEN_SIZE; i++)
    {
        gen[i].fitness(measured_value, yt, tdelta);
    }
    
    quicksort(gen, GEN_SIZE);
}

void Generation::init_random()
{
    for (int i = 0; i < GEN_SIZE; i++)
        gen[i].init_randomly();
}


float Generation::predict(float currentYt, int tdelta)
{
    quicksort(gen, GEN_SIZE);
    
    return gen[0].predict(currentYt, tdelta);
}

void Generation::crossbreed(Generation *g, int index) {
    int firstParentIndex = rnd.generate_int(0, GEN_SIZE);
    Chromosome firstParent = gen[firstParentIndex];

    int secondParentIndex = rnd.generate_int(0, GEN_SIZE);
    Chromosome secondParent = gen[secondParentIndex];
    
    g->gen[index] = firstParent.crossover(secondParent);
}

void Generation::next_gen(Generation *g)
{
    int i = 0;
    // --- use top 10% without change
    for (; i < (GEN_SIZE / 100) * 10; i++)
        g->gen[i] = gen[i];

    // Generate 80% of population by crossbreeding
    for (; i < (GEN_SIZE / 100) * 90; i++)
    {
        crossbreed(g, i);
    }

    // --- put copy of top 10% to the back
    int j = 0;
    for (; i < GEN_SIZE; i++) {
        g->gen[i] = gen[j];
        j++;
    }

    // --- mutate 40%? last
    for (int i = (GEN_SIZE / 100) * 60; i < GEN_SIZE; i++)
        g->gen[i].mutate();
}