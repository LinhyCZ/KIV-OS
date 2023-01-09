#include <stdstring.h>
#include <stdfile.h>
#include <stdmutex.h>
#include <stdmem.h>

#include <read_utils.h>
#include <circular_buffer.h>
#include <rnd_generator.h>

#include "include/utils.h"
#include "include/dictionary.h"
#include "include/evolution/model.h"
#include "include/evolution/generation.h"

#include <drivers/bridges/uart_defs.h>

#define NAN_FLOAT -1

#define PARAMS_COMMAND 		"parameters"
#define STOP_COMMAND		"stop"

#define GENERATIONS_COUNT	200
#define FITNESS_THRESHOLD	0.00000001

float input_value_received_while_counting = NAN_FLOAT;

uint32_t gens_needed;
uint32_t gen_index = 0;

int step_time = 0;
int pred_time = 0;

Generation *gens;

float *values_buffer;
uint32_t values_counter = 0;

/**
 * Logger task
 * 
 * Prijima vsechny udalosti od ostatnich tasku a oznamuje je skrz UART hostiteli
 **/

uint32_t init_uart() {
	uint32_t uart_file = open("DEV:uart/0", NFile_Open_Mode::Read_Write);

	TUART_IOCtl_Params params;
	params.baud_rate = NUART_Baud_Rate::BR_115200;
	params.char_length = NUART_Char_Length::Char_8;
	ioctl(uart_file, NIOCtl_Operation::Set_Params, &params);

	//We don't care about other values like baud rate and char length when enabling interrupt.
	params.interrupt_type = NUART_Interrupt_Type::RX;
	ioctl(uart_file, NIOCtl_Operation::Enable_Event_Detection, &params);

	return uart_file;
};

int read_num_val(char* buffer, uint32_t uart_file, Read_Utils* read_utils, const char* value) {
	int retValue = 0;
	char message_buffer[MESSAGE_BUFFER_SIZE];
	char tmp_buffer[TMP_BUFFER_SIZE];

	while (retValue == 0) {
		fputs(uart_file, WRITE_SYMBOL);
		
		uint32_t read_chars = read_utils->read_line(buffer, uart_file, true);
		bzero(message_buffer, MESSAGE_BUFFER_SIZE);
		bzero(tmp_buffer, TMP_BUFFER_SIZE);

		retValue = atoi(buffer);

		if (retValue > 0) {
			itoa(retValue, tmp_buffer, TMP_BUFFER_SIZE);

			strcat(message_buffer, "OK, ");
			strcat(message_buffer, value);
			strcat(message_buffer, " ");
			strcat(message_buffer, tmp_buffer);
			strcat(message_buffer, " minut");	
		} else {
			strcat(message_buffer, INCORRECT_VALUE);
		}

		println(uart_file, message_buffer);
	}

	return retValue;
}

float read_float_val(char* buffer, uint32_t uart_file) {
	if (isnan(buffer, true)) {
		println(uart_file, INCORRECT_NUMBER_FORMAT);
		return NAN_FLOAT;
	} 

	return atof(buffer);
}

int read_step_time(char* buffer, uint32_t uart_file, Read_Utils* read_utils) {
	return read_num_val(buffer, uart_file, read_utils, "krokovani");
}

int read_prediction_time(char* buffer, uint32_t uart_file, Read_Utils* read_utils) {
	return read_num_val(buffer, uart_file, read_utils, "predpoved");
}

/**
 *	0 = not processed (probably float value or unknown command) 
 *	1 = Generic command received flag (and might have been somehow processed)
 *  2 = Stop command was received.
 */
int process_param(char* buffer, uint32_t file) {
	//Print the parameters. It is not particularly nice writing it this way, but.. :)
	if (strncmp(buffer, PARAMS_COMMAND, strlen(PARAMS_COMMAND)) == 0) {
		char message_buffer[MESSAGE_BUFFER_SIZE];
		char tmp_buffer[TMP_BUFFER_SIZE];

		Model model = gens[2].gen[0].get_model();

		strcat(message_buffer, "A = ");
		ftoa(tmp_buffer, model.A);
		strcat(message_buffer, tmp_buffer);
		bzero(tmp_buffer, TMP_BUFFER_SIZE);

		strcat(message_buffer, ", B = ");
		ftoa(tmp_buffer, model.B);
		strcat(message_buffer, tmp_buffer);
		bzero(tmp_buffer, TMP_BUFFER_SIZE);

		strcat(message_buffer, ", C = ");
		ftoa(tmp_buffer, model.C);
		strcat(message_buffer, tmp_buffer);
		bzero(tmp_buffer, TMP_BUFFER_SIZE);

		strcat(message_buffer, ", D = ");
		ftoa(tmp_buffer, model.D);
		strcat(message_buffer, tmp_buffer);
		bzero(tmp_buffer, TMP_BUFFER_SIZE);

		strcat(message_buffer, ", E = ");
		ftoa(tmp_buffer, model.E);
		strcat(message_buffer, tmp_buffer);

		println(file, message_buffer);
		return 1;
	} 
	
	//Stop the counting!
	if (strncmp(buffer, STOP_COMMAND, strlen(STOP_COMMAND)) == 0) {
		return 2;
	}

	
	return 0;
}

//Process input number and count the values
void count_values(char* buffer, uint32_t file, float input, Read_Utils* read_utils) {
	bool stopped_counting = false;
	bool found_optimal = false;
	
	if (values_counter < gens_needed) {
		println(file, NAN);
	} else {
		println(file, COUNTING);

		//Prepare the previous input
		float yt = values_buffer[(values_counter - gens_needed) % gens_needed];

		//Restore the generation from backup
		gens[0] = gens[2];

		for (int i = 0; i < GENERATIONS_COUNT; i++) {
			//It would be best to stop the finding of the generations if we find the optimal value, but it might be too fast.
			//We just skip creating new generation but still add wait using the for cycle below this if statement.
			if (!found_optimal) {
				gens[0].evaluate_gen(input, file, yt, step_time); //Evaluate the previous generation with current data

				//Validate if we have the best solution already. It will be the first chromosome, evaluate sorts them.
				float bestFitness = gens[0].gen[0].get_fitness();
				if (bestFitness > -FITNESS_THRESHOLD && bestFitness < FITNESS_THRESHOLD) {
					println(file, FOUND_OPTIMAL);
					found_optimal = true;
				} else {
					gens[0].next_gen(&gens[1]); //Create new generation
					gens[0] = gens[1]; //Replace old with the new. :)
				}
			}
			
			for (volatile int j = 0; j < 1000000; j++) {
				//Added fake work :)
			}

			//Process commands that might come during counting - UART should be at least a bit responsive.
			uint32_t read_chars = read_utils->read_line(buffer, file, false);
			if (read_chars != 0) {
				int processFlag = process_param(buffer, file);
				if (processFlag == 0) {
					input_value_received_while_counting = read_float_val(buffer, file);
				}
				
				//Processing stop flag
				if (processFlag == 2) {
					//Restore the generation from backup
					println(file, CANCELED);
					gens[0] = gens[2];
					stopped_counting = true;
					break;
				}
			}
		}

		//Prepare the new generation only if we didn't stop counting using the command - the generation is already prepared in the correct index.
		if (!stopped_counting) {
			//Store the computed new generation to the backup slot
			gens[2] = gens[0];
			
			//Evaluate the stored generation so we can use it
			gens[2].evaluate_gen(input, file, yt, step_time); 
		}

		// Get the new prediction from the latest model.
		float prediction = gens[2].predict(input, step_time);
			
		//Print the prediction value to the user
		print_str_and_float(file, PREDICTION, prediction);
	}

	//Store the value into the circular buffer and increment counter
	values_buffer[values_counter % gens_needed] = input;
	values_counter++;
}

int main(int argc, char** argv)
{
	Read_Utils read_utils;

	char buffer[MESSAGE_BUFFER_SIZE];
	bzero(buffer, MESSAGE_BUFFER_SIZE);

	uint32_t uart_file = init_uart();
	rnd.set_generator(open("DEV:trng", NFile_Open_Mode::Read_Write)); //Init random generator singleton

	//Print intro message
	println(uart_file, INTRO_LINE1);
	println(uart_file, INTRO_LINE2);
	println(uart_file, INTRO_LINE3);
	println(uart_file, INTRO_LINE4);

	//Read step and prediction time from user
	step_time = read_step_time(buffer, uart_file, &read_utils);
	pred_time = read_prediction_time(buffer, uart_file, &read_utils);

	//Prepare generation values
	gens_needed = (pred_time / step_time) + ((pred_time % step_time) != 0);
	gens = reinterpret_cast<Generation*>(malloc(3 * sizeof(Generation))); //Store old and new generation and backup of the previous generation
	values_buffer = reinterpret_cast<float*>(malloc(gens_needed * sizeof(float)));

	// init first generation randomly - Save it to the backup index
	gens[2].init_random();

	//Generation loop
	while (true)
	{
		//If we received value during previous counting, we want to count it immediately before reading another value from the user.
		if (input_value_received_while_counting != NAN_FLOAT) {
			count_values(buffer, uart_file, input_value_received_while_counting, &read_utils);
			input_value_received_while_counting = NAN_FLOAT;
			continue;
		}

		//Read value from the user - if read_line is blocking, then it waits for the file to notify the process.
		fputs(uart_file, WRITE_SYMBOL);
		bzero(buffer, MESSAGE_BUFFER_SIZE);
		uint32_t read_chars = read_utils.read_line(buffer, uart_file, true);

		//Process the input 
		if (process_param(buffer, uart_file) == 0) {
			float input_value = read_float_val(buffer, uart_file);

			if (input_value == NAN_FLOAT) {
				println(uart_file, INCORRECT_VALUE);
			} else {
				count_values(buffer, uart_file, input_value, &read_utils);
			}
		}		
	}

    return 0;
}
