#include <process/process_manager.h>
#include <memory/userspace_heap.h>
#include <memory/pages.h>
#include <memory/mmu.h>


Userspace_Heap_Manager sUserspaceMem;

Userspace_Heap_Manager::Userspace_Heap_Manager()
{
    //
}

void Userspace_Heap_Manager::alloc_and_map_page(TTask_Struct* task) {
    uint32_t page = sPage_Manager.Alloc_Page();
    map_to_process_memory(task, page);

    task->heap_physical_limit = task->heap_physical_limit + mem::PageSize;
}

uint32_t Userspace_Heap_Manager::sbrk(TTask_Struct* task, uint32_t size)
{
    //Alokuj prvni stranku pokud jeste nebyla alokovana - nenastavili jsme hodnotu pro zacatek haldy
    if (task->heap_start == 0) {
        task->heap_start = mem::UserspaceHeapVirtualBase;
        alloc_and_map_page(task);
    }

    //Alokuj stranky dokud nebude dostatek mista
    while (task->heap_physical_limit - task->heap_logical_limit < size) {
        alloc_and_map_page(task);
    }

    uint32_t addressToReturn = task->heap_start + task->heap_logical_limit;
    task->heap_logical_limit = task->heap_logical_limit + size;

    return addressToReturn;
}

void Userspace_Heap_Manager::map_to_process_memory(TTask_Struct* task, uint32_t page_address) {   
    uint32_t physAddr = page_address - mem::MemoryVirtualBase;
    uint32_t userspace_virtual_addr = task->heap_start + task->heap_physical_limit;

    map_memory(task->pt, physAddr, userspace_virtual_addr);
}