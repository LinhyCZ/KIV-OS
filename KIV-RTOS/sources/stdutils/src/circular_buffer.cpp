#include <circular_buffer.h>
#include <stdstring.h>

Circular_Buffer::Circular_Buffer() {
    bzero(buffer, BUFFER_SIZE);
};

/* TODO: Vyresit tady nejak try_spinlock_lock. Mozna predat spinlock z UARTu, ktery muze UART driver zavrit externe nez spusti read. */

//Precte vsechna dostupna data, vrati pocet prectenych znaku.
uint32_t Circular_Buffer::read(char * returnBuffer) {
    return read(returnBuffer, writeIndex - readIndex); //Precti rozdil mezi indexem pro cteni a zapis -> vsechno
}

//Precte zadany pocet znaku, vrati realny pocet prectenych znaku.
uint32_t Circular_Buffer::read(char * returnBuffer, uint32_t len) {
    int readChars = 0;

    //Drop the values that are inaccessible - They have already been written over by something else
    //Increment value of BUFFER_SIZE to readIndex since we have usigned value and we cannot subtract in the start of program.
    if(readIndex + BUFFER_SIZE < writeIndex) {
        readIndex = writeIndex - BUFFER_SIZE + 1;
    }

    uint32_t maxLen = writeIndex - readIndex;

    if (maxLen < len) {
        len = maxLen;
    }

    for (int i = 0; i < len; i++) {
        returnBuffer[readChars] = buffer[readIndex % BUFFER_SIZE];
        buffer[readIndex % BUFFER_SIZE] = '\0'; //Remove the value from the buffer

        readChars++; //Increment counter to return
        readIndex++; //Increment readIndex
    }

    return readChars;
}

//Precte data dokud nenalezene znak v parametru. Pokud v bufferu tento znak neni, vlozi retezec zpet do bufferu a vrati hodnotu 0.
uint32_t Circular_Buffer::read_until(char stop, char* returnBuffer) {
    int readTempIndex;

    for (readTempIndex = readIndex; readTempIndex < writeIndex; readTempIndex++) {
        if (buffer[readTempIndex % BUFFER_SIZE] == stop) {
            break;
        }

        //Pokud jsem doted nenasel ten znak, tak vratim nulu a neresim buffer
        if (readTempIndex == writeIndex - 1) {
            return 0;
        }
    }

    //V promenne readTempIndex mam hodnotu, kde se zrovna nachazi
    return read(returnBuffer, readTempIndex - readIndex + 1); //Read one more char - if we have asd\n, then \n is readTempIndex 3 - readIndex 0 = 3 - but we want 4 letters
}

// Vlozi vice znaku do bufferu
void Circular_Buffer::write(char* input, uint32_t len) {
    for (int i = 0; i < len; i++) {
        write(input[i]);
    }
}

// Vlozi jeden znak do bufferu
void Circular_Buffer::write(char input) {
    buffer[writeIndex % BUFFER_SIZE] = input;
    writeIndex++;
}