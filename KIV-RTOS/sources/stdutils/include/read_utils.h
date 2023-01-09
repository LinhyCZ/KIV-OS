#pragma once

#include <hal/intdef.h>
#include <circular_buffer.h>

#define BUFFER_SIZE 128

class Read_Utils
{
    private:
        //Buffer
        Circular_Buffer circular_buffer;

    public:
        // konstruktor
        Read_Utils();

        //Precte celou radku z vstupniho souboru. Mezidata uklada do sveho bufferu.
        uint32_t read_line(char * returnBuffer, uint32_t file, bool blocking = false);
};