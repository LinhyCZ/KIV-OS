#pragma once

#include <hal/intdef.h>

// jednoduchy alokator userspace haldy pro dany proces. Nepodporuje uvolnovani jiz naalokovane pameti

class Userspace_Heap_Manager
{
    private:
        void map_to_process_memory(TTask_Struct* task, uint32_t physicalAddress);
        void alloc_and_map_page(TTask_Struct* task);

    public:
        Userspace_Heap_Manager();

        uint32_t sbrk(TTask_Struct* task, uint32_t size);
};

extern Userspace_Heap_Manager sUserspaceMem;