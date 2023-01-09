#include <chromosome.h>

#define RND_LOW_STOP	-5
#define RND_HIGH_STOP	5

/**
 *  Operators that are necessary for comparing two chromosomes together. Used in quicksort.
 */
bool Chromosome::operator < (Chromosome const &obj)
{
    return fit < obj.fit;
}

bool Chromosome::operator > (Chromosome const &obj)
{
    return fit > obj.fit;
}

/**
 * Calculate bt value. Equation is from the assignment. 
 * 
 * b(t) = D/E * dy(t)/dt + 1/E * y(t)
 */
float Chromosome::bt(float yt, int tdelta)
{
    float derivation = tdelta / 1.0 / (24.0 * 60.0); // Tady by asi mela byt delta t
    return (params[Params::D] / params[Params::E]) * derivation + (1 / params[Params::E]) * yt;
}

/**
 * Predict new value. Equation is from the assignment.
 * 
 * y(t + t_pred) = A * b(t) + B * b(t) * (b(t) - y(t)) + C
 */
float Chromosome::predict(float yt, int tdelta)
{
    float btVal = bt(yt, tdelta);
    return params[Params::A] * btVal + params[Params::B] * btVal * (btVal - yt) + params[Params::C];
}

/**
 * Calculate fitness value of the current chromosome
 */
float Chromosome::fitness(float &measured_value, float yt, int tdelta)
{
    float yt_pred = predict(yt, tdelta);
    fit = (yt_pred - measured_value) * (yt_pred - measured_value);
    return fit;
}

/**
 * Generate random value to random index of the current chromosome
 */
void Chromosome::mutate()
{
    int index = rnd.generate_int(0, PARAM_COUNT);
    params[index] = rnd.generate(RND_LOW_STOP, RND_HIGH_STOP); 
}

/**
 * Create new chromosome by randomly breeding two parent chromosomes together.
 * With rare probability, the new chromosome may mutate during breeding.
 */
Chromosome Chromosome::crossover(Chromosome &other)
{
    Chromosome newChromosome;

    for (int i = 0; i < PARAM_COUNT; i++)
    {
        // random probability 
        float p = rnd.generate(0, 1);
  
        // if prob is less than 0.45, insert gene
        // from parent 1 
        if(p < 0.45) {
            newChromosome.params[i] = params[i];
        }
  
        // if prob is between 0.45 and 0.90, insert
        // gene from parent 2
        else if(p < 0.90) {
            newChromosome.params[i] = other.params[i];
        }
  
        // otherwise insert random gene(mutate), 
        // for maintaining diversity
        else {
            newChromosome.params[i] = rnd.generate(RND_LOW_STOP, RND_HIGH_STOP);
        }
    }

    return newChromosome;
}

/**
 * Init current chromosome with new values.
 */
void Chromosome::init_randomly()
{
    for (int i = 0; i < PARAM_COUNT; i++) {
        params[i] = rnd.generate(RND_LOW_STOP, RND_HIGH_STOP); 
    }
}

/**
 * Returns precalculated fitness of the current Chromosome
 */
float Chromosome::get_fitness()
{
    return fit;
}

/**
 * Returns values of the model.
 */
Model Chromosome::get_model() 
{
    Model model;
    model.A = params[Params::A];
    model.B = params[Params::B];
    model.C = params[Params::C];
    model.D = params[Params::D];
    model.E = params[Params::E];

    return model;
}