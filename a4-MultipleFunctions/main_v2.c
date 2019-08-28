//main.c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int l_strlen(const char *);
int l_strcmp(const char *str1, const char *str2);
int l_gets(int fd, char *buf, int len);
void l_puts(const char *buf);
int l_write(int fd, const char *buf, int len, int *err);
int l_open(const char *name, int flags, int mode, int *err);
int l_close(int fd, int *err);
unsigned int l_atoi(char *value);
char *l_itoa(unsigned int value, char *buffer);
unsigned int l_rand(unsigned int n);
int l_exit(int rc);

#define O_RDONLY 0
#define O_WRONLY 1
#define O_RDWR   2

char prompt[] = "Enter a string: ";
char msg1[] = "Echoing file: ";
char msg2[] = "Failed to open input file\n";
char equal[] = "The strings are the same\n";
char diff[] = "The strings are different\n";
char value[] = "The second string contains the integer: ";
char rnd[] = "Here is a random number between 0 and 4000 for you: ";

char test1[] = ".";
char test2[] = "123456789";
char test3[] = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa130\n";
char test4[] = "\x30\x31\x32\x33\x34\x35\x36\x37\x38\x39";
char test5[] = "";
char test6[] = "\n";
char test7[] = "\t";

char test8[] = "same";
char test9[] = "same";
char test10[] = "short";
char test11[] = "looooooooooooong";
char test12[] = "\n";
char test13[] = "0123456789";
char test14[] = "";

char test15[] = "123test123";
char test16[] = "test123";
char test17[] = "1111111111";
char test18[] = "11111111111";



int main(int argc, char **argv, char **envp) {
   int i;
   char newline = '\n';
   int len1, len2;
   char str1[80];
   char str2[80];
   int fd;
   int fd2;
   int err = 0;
   int result = 0;
   setvbuf(stdout, NULL, _IONBF, 0);


   printf("String len\n");
   result=l_strlen(test1);
   printf("String of one: Result: %d Expected: 1\n", result);
   result=l_strlen(test2);
   printf("Numbers: Result: %d Expected: 9\n", result);
   result=l_strlen(test3);
   printf("Long string: Result: %d Expected: 130\n", result);
   result=l_strlen(test4);
   printf("Hex code: Result: %d Expected: 10\n", result);
   result=l_strlen(test5);
   printf("Empty string: Result: %d Expected: 0\n", result);
   result=l_strlen(test6);
   printf("New line: Result: %d Expected: 1\n", result);
   result=l_strlen(test7);
   printf("Tab: Result: %d Expected: 1\n", result);

   printf("\nString compare\n");
   result=l_strcmp(test8, test9);
   printf("Same string: Result: %d Expected: 0\n", result);
   result=l_strcmp(test9, test8);
   printf("Same string reverse order: Result: %d Expected: 0\n", result);
   result=l_strcmp(test10, test11);
   printf("Short Long: Result: %d Expected: 1\n", result);
   result=l_strcmp(test11, test10);
   printf("Long Short: Result: %d Expected: 1\n", result);
   result=l_strcmp(test6, test12);
   printf("new line: Result: %d Expected: 0\n", result);
   result=l_strcmp(test4, test13);
   printf("Number and hex: Result: %d Expected: 0\n", result);
   result=l_strcmp(test5, test14);
   printf("Empty string: Result: %d Expected: 0\n", result);

   printf("\nPuts\n");
   printf("Period: ");
   l_puts(test1);
   printf("\n");
   printf("1-9: ");
   l_puts(test2);
   printf("\n");
   printf("Lots of a's and number: ");
   l_puts(test3);
   printf("\n");
   printf("Hex 0-9: ");
   l_puts(test4);
   printf("\n");
   printf("Nothing: ");
   l_puts(test5);
   printf("\n");
   printf("New Line: ");
   l_puts(test6);
   printf("\n");
   printf("Tab: ");
   l_puts(test7);
   printf("\n");

   printf("\nWrite\n");
   printf("String of one: ");
   result=l_write(1,test1,1,&err);
   printf("\nResult: %d Expected: 1\n", result);
   printf("Numbers: ");
   result=l_write(1,test2,9,&err);
   printf("\nResult: %d Expected: 9\n", result);
   printf("Long string with newline: ");
   result=l_write(1,test3,130,&err);
   printf("\nResult: %d Expected: 130\n", result);
   printf("Hex code: ");
   result=l_write(1,test4,10,&err);
   printf("\nResult: %d Expected: 10\n", result);
   printf("Empty string: ");
   result=l_write(1,test5,0,&err);
   printf("\nResult: %d Expected: 0\n", result);
   printf("New line: ");
   result=l_write(1,test6,1,&err);
   printf("\nResult: %d Expected: 1\n", result);
   printf("Tab: ");
   result=l_write(1,test7,1,&err);
   printf("\nResult: %d Expected: 1\n", result);

   printf("\nWrite with bad length\n");
   printf("String of one, but with len 0: ");
   result=l_write(1,test1,0,&err);
   printf("\nResult: %d Expected: 0\n", result);
   printf("Numbers but with one less than string: ");
   result=l_write(1,test2,8,&err);
   printf("\nResult: %d Expected: 8\n", result);
   printf("Long string but only write 30 bytes: ");
   result=l_write(1,test3,30,&err);
   printf("\nResult: %d Expected: 30\n", result);
   printf("Long string but try to write more(overflow): ");
   result=l_write(1,test3,200,&err);
   printf("\nResult: %d Expected: 200\n", result);
   printf("Empty string but told len is 1(overflow): ");
   result=l_write(1,test5,1,&err);
   printf("\nResult: %d Expected: 1\n", result);

   printf("\nWrite with errors\n");
   result=l_write(3,test1,1,&err);
   printf("Bad file descriptor: Result: %d Error code: %d expected: -1 and 9\n", result, err);

   printf("\natoi\n");
   result=l_atoi(test2);
   printf("1-9: Result: %d\n", result);
   result=l_atoi(test4);
   printf("0-9 hex: Result: %d\n", result);
   result=l_atoi(test15);
   printf("Number text Number: Result: %d\n", result);
   result=l_atoi(test16);
   printf("Text Number: Result: %d\n", result); 
   result=l_atoi(test17);
   printf("Large number no overflow: Result: %d\n", result);  
   result=l_atoi(test18);
   printf("Large number overflow: Result: %d\n", result); 

   printf("\nitoa\n"); 
   l_itoa(35, str1);
   printf("35: Result: %s\n",str1);
   l_itoa(0, str1);
   printf("0: Result: %s\n",str1);
   l_itoa(123456789, str1);
   printf("123456789: Result: %s\n",str1);
   l_itoa(22345678910, str1);
   printf("Rollover: Result: %s\n",str1);
   l_itoa(4444, str1);
   printf("4444: Result: %s\n",str1);
   l_itoa(0000, str1);
   printf("0000: Result: %s\n",str1);

   printf("\nRandom\n"); 
   result=l_rand(4000);
   printf("0-3999: Result: %d\n",result);	
   result=l_rand(1);
   printf("0: Result: %d\n",result);
   result=l_rand(2);
   printf("0-1: Result: %d\n",result);
   result=l_rand(1000000000);
   printf("0-999999999: Result: %d\n",result);
   result=l_rand(10000000000);
   printf("n=10000000000 overflow: Result: %d\n",result);
   result=l_rand(0);
   printf("0: Result: %d\n",result);

   printf("\nOpen File, gets, close\n");
   fd = l_open("test.txt", O_RDONLY, 0, &err);
   printf("Safe test case open test.txt: Result: %d Error code: %d\n",fd,err);
   result=l_gets(fd, str1, 79);
   printf("%s\n", str1);
   printf("Read content: Amount read: %d Expected: 15\n", result);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n\n",result,err);
   fd = l_open("test2", O_RDONLY, 0, &err);
   printf("Open test2 content to large for gets: Result: %d Error code: %d\n",fd,err);
   result=l_gets(fd, str1, 79);
   printf("%s\n", str1);
   printf("Read content: Amount read: %d Expected: 78\n", result);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n\n",result,err);
   fd = l_open("test3", O_RDONLY, 0, &err);
   printf("File does not exists: Result: %d Error code: %d\n",fd,err);
   result=l_gets(fd, str1, 79);
   printf("Read content: Amount read: %d Expected: 0\n", result);
   result=l_close(fd, &err);
   printf("Close Result (expect error): %d Error code: %d\n\n",result,err);
   fd = l_open("test4", O_WRONLY, 0, &err);
   printf("Different permissions: Result: %d Error code: %d\n",fd,err);
   result=l_gets(fd, str1, 79);
   printf("Read content: Amount read: %d Expected: 0\n", result);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n\n",result,err);
   fd = l_open("test.txt", O_RDONLY, 0, &err);
   printf("Two files open close out of order: Result: %d Error code: %d\n",fd,err);
   result=l_gets(fd, str1, 79);
   printf("Read content: Amount read: %d Expected: 15\n", result);
   fd2 = l_open("test2", O_RDONLY, 0, &err);
   printf("Open test2 content to large for gets: Result: %d Error code: %d\n",fd2,err);
   result=l_gets(fd2, str1, 79);
   printf("Read content: Amount read: %d Expected: 78\n", result);
   result=l_close(fd2, &err);
   printf("Close Result: %d Error code: %d\n",result,err);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n",result,err);

   printf("\nOpen File, write, close\n");
   fd = l_open("test5", O_WRONLY, 0, &err);
   printf("Safe test case open test5: Result: %d Error code: %d\n",fd,err);
   result=l_write(fd,test3,130,&err);
   printf("Long string: Result: %d Error Code: %d Expected: 130 and 0\n", result,err);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n\n",result,err);
   fd = l_open("test5", O_RDONLY, 0, &err);
   printf("Bad permissions: Result: %d Error code: %d\n",fd,err);
   result=l_write(fd,test3,130,&err);
   printf("Long string: Result: %d Error Code: %d Expected: -1 and 9\n", result,err);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n\n",result,err);
   fd = l_open("test5", O_RDONLY, 0, &err);
   printf("File Descriptor does not exist: Result: %d Error code: %d\n",fd,err);
   result=l_write(5,test3,130,&err);
   printf("Nowhere to write: Result: %d Error Code: %d Expected: -1 and 9\n", result,err);
   result=l_close(fd, &err);
   printf("Close Result: %d Error code: %d\n\n",result,err);

   printf("\nYou survived the test :)\n");
   l_exit(0);
   return 0;
}
