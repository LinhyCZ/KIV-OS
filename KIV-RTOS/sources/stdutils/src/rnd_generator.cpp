#include <rnd_generator.h>
#include <stdfile.h>

Rnd_Generator rnd;

int Rnd_Generator::generate_int(int32_t low, int32_t high) {
	return generate(low, high + 1); //Add 1 to high since it wouldn't be able to get to this value if we trim the decimal part
}

/**
 * Generates float value between low and high parameters. 
 * 
 * Generator has to be initialized using set_generator function, otherwise always returns 0.
 */
float Rnd_Generator::generate(int32_t low, int32_t high) {
	if (rnd_file == RND_NOT_INITIALIZED) {
		return 0;
	}

	char buf[sizeof(uint32_t)] = {0};
	read(rnd_file, buf, sizeof(uint32_t));
	int32_t diff = high - low;

	uint32_t rnd_value = reinterpret_cast<uint32_t*>(buf)[0];
	float rnd_final = static_cast<float>(rnd_value / (static_cast<float>(UINT32_T_MAX) / diff)) + low;

	return rnd_final;
}

void Rnd_Generator::set_generator(uint32_t file) {
	rnd_file = file;
}