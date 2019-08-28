
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include "assign6.h"

int main(int argc, char **argv) {
   int i, j;
   heap_stats stats;
   void *p[100];
   unsigned char *heap_base;
   setvbuf(stdin, NULL, _IONBF, 0);
   setvbuf(stdout, NULL, _IONBF, 0);
   setvbuf(stderr, NULL, _IONBF, 0);

//test 1 all malloc
   p[0] = malloc(19);
   p[1] = malloc(25);
   p[2] = malloc(40);
   p[3] = malloc(50);
   p[4] = malloc(70);
   p[5] = malloc(90);
   p[6] = malloc(1000);
   p[7] = malloc(1200);
   p[8] = malloc(2400);
   p[9] = malloc(4000);
   p[10] = malloc(1500);
   p[11] = malloc(1);

   printf("\n-----------------Test 1: All mallocs--------------------\n");
   printf("Your results:\n");
   heap_base = (unsigned char*)(~0xfff & (uint64_t)p[0]);
   heap_walk(heap_base, &stats);

   printf("\nYour sturct:\n");
   printf("Number of free blocks: %d\n",stats.num_free_blocks);
   printf("Number of allocated blocks: %d\n", stats.num_allocated_blocks);
   printf("Largest allocated block: %ld\n", stats.largest_allocated);
   printf("Largest free block: %ld\n", stats.largest_free);
   printf("First allocated block: %p\n", stats.first_allocated);
   printf("Last allocated block: %p\n", stats.last_allocated);
   printf("Tail chunk: %p\n\n", stats.tail_chunk);

   printf("Expected results:\n");
   printf("Total Allocated bytes: 11184\n");
   printf("Total Free bytes: 123984\n");
   printf("Number of free blocks: 0\n");
   printf("Number of allocated blocks: 13\n");
   printf("Largest allocated block: 4000\n");
   printf("Largest free block: 0\n\n");


//test 2 free every other block
   free(p[0]);
   free(p[2]);
   free(p[4]);
   free(p[6]);
   free(p[8]);
   free(p[10]);

   printf("\n-----------------Test 2: Free every other block--------------------\n");
   printf("Your results:\n");
   heap_walk(heap_base, &stats);

   printf("\nYour sturct:\n");
   printf("Number of free blocks: %d\n",stats.num_free_blocks);
   printf("Number of allocated blocks: %d\n", stats.num_allocated_blocks);
   printf("Largest allocated block: %ld\n", stats.largest_allocated);
   printf("Largest free block: %ld\n", stats.largest_free);
   printf("First allocated block: %p\n", stats.first_allocated);
   printf("Last allocated block: %p\n", stats.last_allocated);
   printf("Tail chunk: %p\n\n", stats.tail_chunk);

   printf("Expected results:\n");
   printf("Total Allocated bytes: 7248\n");
   printf("Total Free bytes: 127920\n");
   printf("Number of free blocks: 2\n");
   printf("Number of allocated blocks: 11\n");
   printf("Largest allocated block: 4000\n");
   printf("Largest free block: 2400\n\n");

//test 3 free every block
   free(p[1]);
   free(p[3]);
   free(p[5]);
   free(p[7]);
   free(p[9]);
   free(p[11]);

   printf("\n-----------------Test 3: Free every block--------------------\n");
   printf("Your results:\n");
   heap_walk(heap_base, &stats);

   printf("\nYour sturct:\n");
   printf("Number of free blocks: %d\n",stats.num_free_blocks);
   printf("Number of allocated blocks: %d\n", stats.num_allocated_blocks);
   printf("Largest allocated block: %ld\n", stats.largest_allocated);
   printf("Largest free block: %ld\n", stats.largest_free);
   printf("First allocated block: %p\n", stats.first_allocated);
   printf("Last allocated block: %p\n", stats.last_allocated);
   printf("Tail chunk: %p\n\n", stats.tail_chunk);

   printf("Expected results:\n");
   printf("Total Allocated bytes: 2016\n");
   printf("Total Free bytes: 133152\n");
   printf("Number of free blocks: 1\n");
   printf("Number of allocated blocks: 9\n");
   printf("Largest allocated block: 992\n");
   printf("Largest free block: 9152\n\n");

//test 4 malloc again
   p[12] = malloc(1200);
   p[13] = malloc(1600);
   p[14] = malloc(1700);
   p[15] = malloc(2200);
   p[16] = malloc(5000);

   printf("\n-----------------Test 4: Malloc again--------------------\n");
   printf("Your results:\n");
   heap_base = (unsigned char*)(~0xfff & (uint64_t)p[0]);
   heap_walk(heap_base, &stats);

   printf("\nYour sturct:\n");
   printf("Number of free blocks: %d\n",stats.num_free_blocks);
   printf("Number of allocated blocks: %d\n", stats.num_allocated_blocks);
   printf("Largest allocated block: %ld\n", stats.largest_allocated);
   printf("Largest free block: %ld\n", stats.largest_free);
   printf("First allocated block: %p\n", stats.first_allocated);
   printf("Last allocated block: %p\n", stats.last_allocated);
   printf("Tail chunk: %p\n\n", stats.tail_chunk);

   printf("Expected results:\n");
   printf("Total Allocated bytes: 13776\n");
   printf("Total Free bytes: 121392\n");
   printf("Number of free blocks: 1\n");
   printf("Number of allocated blocks: 14\n");
   printf("Largest allocated block: 4992\n");
   printf("Largest free block: 2400\n\n");

//test 5 free again
   free(p[12]);
   free(p[13]);
   free(p[14]);
   free(p[15]);
   free(p[16]);

   printf("\n-----------------Test 5: Free again--------------------\n");
   printf("Your results:\n");
   heap_walk(heap_base, &stats);

   printf("\nYour sturct:\n");
   printf("Number of free blocks: %d\n",stats.num_free_blocks);
   printf("Number of allocated blocks: %d\n", stats.num_allocated_blocks);
   printf("Largest allocated block: %ld\n", stats.largest_allocated);
   printf("Largest free block: %ld\n", stats.largest_free);
   printf("First allocated block: %p\n", stats.first_allocated);
   printf("Last allocated block: %p\n", stats.last_allocated);
   printf("Tail chunk: %p\n\n", stats.tail_chunk);

   printf("Expected results:\n");
   printf("Total Allocated bytes: 2016\n");
   printf("Total Free bytes: 133152\n");
   printf("Number of free blocks: 1\n");
   printf("Number of allocated blocks: 9\n");
   printf("Largest allocated block: 992\n");
   printf("Largest free block: 9152\n\n");

//test 6 tcache check
   p[17] = malloc(1);
   p[18] = malloc(1);
   p[19] = malloc(1);
   p[20] = malloc(1);
   p[21] = malloc(1);
   p[22] = malloc(1);
   free(p[17]);
   free(p[18]);
   free(p[19]);
   free(p[20]);
   free(p[21]);
   free(p[22]);

   printf("\n-----------------Test 6: tcache check---------------------");
   printf("\n-------This will write over free blocks first-------------\n");
   printf("Your results:\n");
   heap_base = (unsigned char*)(~0xfff & (uint64_t)p[0]);
   heap_walk(heap_base, &stats);

   printf("\nYour sturct:\n");
   printf("Number of free blocks: %d\n",stats.num_free_blocks);
   printf("Number of allocated blocks: %d\n", stats.num_allocated_blocks);
   printf("Largest allocated block: %ld\n", stats.largest_allocated);
   printf("Largest free block: %ld\n", stats.largest_free);
   printf("First allocated block: %p\n", stats.first_allocated);
   printf("Last allocated block: %p\n", stats.last_allocated);
   printf("Tail chunk: %p\n\n", stats.tail_chunk);

   printf("Expected results:\n");
   printf("Total Allocated bytes: 2144\n");
   printf("Total Free bytes: 133024\n");
   printf("Number of free blocks: 1\n");
   printf("Number of allocated blocks: 13\n");
   printf("Largest allocated block: 992\n");
   printf("Largest free block: 9024\n\n");

}

