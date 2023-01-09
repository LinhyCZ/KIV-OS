#pragma once

#include <hal/intdef.h>

#define BUFFER_SIZE 128

class Circular_Buffer
{
    private:
        //Buffer
        char buffer[BUFFER_SIZE];
        
        //Adresy pro zacatecn index pro cteni a zapis
        uint32_t readIndex = 0;
        uint32_t writeIndex = 0;

    public:
        // konstruktor - Vytvori novy kruhovy zasobnik
        Circular_Buffer();

        //Precte vsechna dostupna data, vrati pocet prectenych znaku.
        uint32_t read(char * returnBuffer);
        
        //Precte zadany pocet znaku, vrati realny pocet prectenych znaku.
        uint32_t read(char * returnBuffer, uint32_t len);

        //Precte data dokud nenalezene znak v parametru. Pokud v bufferu tento znak neni, vlozi retezec zpet do bufferu a vrati hodnotu 0.
        uint32_t read_until(char stop, char* returnBuffer);

        // Vlozi vice znaku do bufferu
        void write(char* input, uint32_t len);

        // Vlozi jeden znak do bufferu
        void write(char input);
};