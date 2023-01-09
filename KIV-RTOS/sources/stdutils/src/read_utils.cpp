#include <read_utils.h>
#include <stdfile.h>
#include <stdstring.h>

Read_Utils::Read_Utils() {
    // Prazdny konstruktor
};

uint32_t Read_Utils::read_line(char * returnBuffer, uint32_t file, bool blocking) {
    char readBuffer[128];
	bzero(readBuffer, 128);
	uint32_t readChars = 0;

    //Read from UART if data are available.
	do {
		if (blocking == true) {	//If we want to block the process, we just wait until we receive something from  UART
			wait(file, 0x1000, Indefinite);
		}

		uint32_t len = read(file, readBuffer, 128);
		if (len != 0) {

			//Write into it's own circular buffer holding previous values.
			//This is used for example if user pastes two lines, we don't want to scrap the result.
			//Other scenario might be that user might enter for example only two characters without pressing \n - We still 
			//Want to save the results and return them on next read_line call.
			
			circular_buffer.write(readBuffer, len);
			readChars = circular_buffer.read_until('\n', returnBuffer);

			//Workaround for QEMU since it only sends \r, not \n - we replace the last read char with \n - in production we still should get \r\n
			//but in QEMU, we replace the last \r with \n, thus going on new line, not only returning to the beggining of the line. If we get \n (Linux style)
			//We still should end up with only \n in the end. Possible values are then \r\n and \n.
			//
			//We also send the new line character to the UART, so we end up on correct line. In rare occassions this might cause sending two newlines.
			if (readChars == 0) {
				readChars = circular_buffer.read_until('\r', returnBuffer);

				if (readChars != 0) {
					write(file, "\n", 1);
					returnBuffer[readChars - 1] = '\n';
				}
			}

			//Remove newLine and carriage return characters from the end of the string.
			for (int i = readChars - 1; i >= 0; i--) {
				if (returnBuffer[i] == '\r' || returnBuffer[i] == '\n') {
					returnBuffer[i] = '\0';
					continue; //Replace and continue to another character 
				}

				break; //There was no newline, we suspect that there is alphanumeric characters and no new line char will be present, so we can stop the search.
			}
		}
	} while (readChars == 0 && blocking == true);
	
    return readChars;
}

