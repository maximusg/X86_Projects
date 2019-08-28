//main.c
int l_strlen(const char *);
//int l_strcmp(const char *str1, const char *str2);
//int l_gets(int fd, char *buf, int len);
//void l_puts(const char *buf);
//int l_write(int fd, const char *buf, int len, int *err);
//int l_open(const char *name, int flags, int mode, int *err);
//int l_close(int fd, int *err);
//unsigned int l_atoi(char *value);
//char *l_itoa(unsigned int value, char *buffer);
//unsigned int l_rand(unsigned int n);
//int l_exit(int rc);
//
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

int main(int argc, char **argv, char **envp) {

l_strlen("hello");

//   int i;
//   char newline = '\n';
//   int len1, len2;
//   char str1[80];
//   char str2[80];
//   int fd;
//   int err;
//
//   for (i = 0; i < argc; i++) {
//      l_puts(argv[i]);
//      l_write(1, &newline, 1, &err);
//   }
//   l_write(1, &newline, 1, &err);
//
//   if (argc > 1) {
//      l_puts(msg1);
//      l_puts(argv[1]);
//      l_write(1, &newline, 1, &err);
//      fd = l_open(argv[1], O_RDONLY, 0, &err);
//      if (fd == -1) {
//         l_puts(msg2);
//      }
//      else {
//         int len;
//         while ((len = l_gets(fd, str1, 79)) > 0) {
//            l_write(1, str1, len, &err);
//         }
//         l_close(fd, &err);
//      }
//   }
//
//   l_write(1, &newline, 1, &err);
//
//   while (1) {
//      l_write(1, prompt, l_strlen(prompt), &err);
//      len1 = l_gets(0, str1, 79);
//      str1[len1] = 0;
//
//      if (l_strcmp(str1, "quit\n") == 0) {
//         break;
//      }
//
//      l_puts(prompt);
//      len2 = l_gets(0, str2, 79);
//      str2[len2] = 0;
//
//      if (l_strcmp(str1, str2) == 0) {
//         l_puts(equal);
//      }
//      else {
//         l_puts(diff);
//      }
//
//      l_puts(value);
//      l_puts(l_itoa(l_atoi(str2), str1));
//      l_write(1, &newline, 1, &err);
//
//      l_puts(rnd);
//      l_puts(l_itoa(l_rand(4000), str1));
//      l_write(1, &newline, 1, &err);
//
//   }
//   l_exit(0);
   return 0;
}
