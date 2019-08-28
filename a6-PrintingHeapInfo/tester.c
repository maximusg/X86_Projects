
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <time.h>
#include "assign6.h"

void heap_walk(void *heap_base, heap_stats *stats);
//use this to test code.
//fix 3 blocks to allocate w/
//since it useds the data structure
//can check and see what goes in
int main(int argc, char **argv) {
   int i, j;
   heap_stats stats;
   void *p[100];
   unsigned char *heap_base;
   setvbuf(stdin, NULL, _IONBF, 0);
   setvbuf(stdout, NULL, _IONBF, 0);
   setvbuf(stderr, NULL, _IONBF, 0);
   srand(0);
//    for (i=0; i <10; i++){
//        p[i] = malloc(16);
//    }
//    heap_base = (unsigned char*)(~0xfff & (uint64_t)p[0]);//0s out the last 3 bits of the address

//    for (i=0; i <10; i++){
//        printf("locate %i 0x%.8X",i,p[i]);
//        int n = rand() % 100;   
//        if (n <50){
//             printf(" free \n");
//             free(p[i]);
//             p[i]=NULL;
            
//         }
//         else{
//             printf("\n");
//         }
//    }
// p[0]= malloc(1033);
// p[1]= malloc(1033);
// p[2]= malloc(1033);
// p[3]= malloc(1256);
// p[4]= malloc(1256);
// p[5]= malloc(1256);
// p[6]= malloc(1256);
// p[7]= malloc(1256);
// p[8]= malloc(1256);
// p[9]= malloc(1033);
// p[10]= malloc(1033);
// heap_base = (unsigned char*)(~0xfff & (uint64_t)p[0]);//0s out the last 3 bits of the address

// for (i=0; i <11; i++){
//         int a= (int)p[i]-16;
//        printf("locate %i 0x%.8X \n",i,a);
// }

// free(p[10]);
// p[10] = NULL;
// free(p[7]);
// p[7]=NULL;
// free(p[0]);
// p[0]=NULL;
// free(p[0]);
// p[0]=NULL;

// free(p[4]);
// p[4]=NULL;
// free(p[2]);
// p[2]=NULL;
// free(p[2]);
// p[2]=NULL;
// locate 0 0x00602260 
// locate 1 0x00602280 
// locate 2 0x006022A0 
// locate 3 0x006022C0 
// locate 4 0x006022F0 
// locate 5 0x00602340 
// locate 6 0x00602390 
// locate 7 0x006023C0 
// locate 8 0x006023E0 
// locate 9 0x00602430 
// locate 10 0x00602460 


 
   
   for (i = 0; i < 100; i++) {
      p[i] = malloc(1033 + rand() % 1500); //malloc random sizes between 10 and 1500
   }
   heap_base = (unsigned char*)(~0xfff & (uint64_t)p[0]);//0s out the last 3 bits of the address

   j = 15 + rand() % 50;  //j is some random 15-49
   for (i = 0; i < j; i++) {
      int n = rand() % 100; 
      printf("p free %p \n",p[n]);
      if (p[n]) { //if
         free(p[n]);
         p[n] = NULL;
      }
   }
    printf("\nHeap stuff\n");
   heap_walk(heap_base, &stats);
   printf("\ntotal free blocks %i", stats.num_free_blocks);
   printf("\ntotal allocated blocks %i", stats.num_allocated_blocks);
   printf("\nlargest allocated blocks %i", stats.largest_allocated);
   printf("\nlargest free blocks %i", stats.largest_free);
   printf("\nfirst allocated block 0x%p", stats.first_allocated);
   printf("\nlast allocated block 0x%p", stats.last_allocated);
   printf("\ntop chunk location %p\n", stats.tail_chunk);

}

//turn off ASLR
//no stack detector