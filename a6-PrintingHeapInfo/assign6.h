
#ifndef __ASSIGN6_3140_H
#define __ASSIGN6_3140_H

#include <stdint.h>

typedef struct _heap_stats {
   //the total number of blocks containing free space, including the tail chunk
   uint32_t num_free_blocks;       //offset 0
   //the total number of blocks marked as IN_USE in the heap
   uint32_t num_allocated_blocks;  //offset 4
   //the size (excluding the 16 byte header) of the largest allocated block in the heap
   size_t   largest_allocated;     //offset 8
   //the size (excluding the 16 byte header) of the largest free block in the heap
   size_t   largest_free;          //offset 16
   //the first (as in lowest address) allocated block in the heap (fisrt byte of chunk header)
   void     *first_allocated;      //offset 24
   //the last (as in highest address) allocated block in the heap (fisrt byte of chunk header)
   void     *last_allocated;       //offset 32
   //the address of the tail chunk (first byte of tail chunk header)
   void     *tail_chunk;           //offset 40
} heap_stats;

/*****
This function walks the libc heap that begins at heap_base
and prints out information about each block (allocated or
unallocated) that exists in the heap to include start address,
size, allocation status, and next and prev free-list pointers
if the block is unallocated.

In addition to generating the output described above, the
function also populates the heap_stats structure pointed to
by stats with various summary data about the heap.

Please refer to the description of heap_stats above.

*****/
void heap_walk(void *heap_base, heap_stats *stats);

#endif

