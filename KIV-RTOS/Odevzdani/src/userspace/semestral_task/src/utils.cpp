#include <utils.h>

void fputs(uint32_t file, const char* string)
{
	write(file, string, strlen(string));
}

void println(uint32_t file, const char* string)
{
	char messageBuffer[MESSAGE_BUFFER_SIZE];
	bzero(messageBuffer, MESSAGE_BUFFER_SIZE);
	strcat(messageBuffer, string);
	strcat(messageBuffer, NEWLINE);
	fputs(file, messageBuffer);
}

void print_str_and_float(uint32_t file, const char* string, float val) {
	char messageBuffer[MESSAGE_BUFFER_SIZE];
	char tmpBuffer[TMP_BUFFER_SIZE];

	bzero(messageBuffer, MESSAGE_BUFFER_SIZE);			
	strcat(messageBuffer, string);
	ftoa(tmpBuffer, val);
	strcat(messageBuffer, tmpBuffer);
	
	println(file, messageBuffer);
}

