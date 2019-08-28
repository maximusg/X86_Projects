CC=nasm
CFLAGS=-f elf64 -F dwarf -g -l
SRCS = $(wildcard *.asm)

PROGS = $(patsubst %.asm,%,$(SRCS))
#LD=ld
#LDFLAGS=-o -m elf_x86_64
all: $(PROGS)

%: %.asm

# $(CC) refers to the CC variable set on line 1, so essentially it is just nasm
# I think people typically use the CC variable to refer to the compiler that 
# they are using, so GCC or CLANG, but in our case we are using the NASM assembler
#
# $(CFLAGS) refers to the compiler flags, I set these on line 2.
#  We are using -f elf64 to get a 64 bit ELF file,
#   -F dwarf and -g for debugging symbols (line numbers and symbol table)
#   This will allow us to use gdb's TUI mode by pressing CTRL-X and then CTRL-A
#
#   SRCS is a variable that goes through the current directory and matches all 
#   .asm files in the directory.
#
#   PROGS, im not really sure... 
#
# $@ refers to the file being generated (so the .o file in this case)
# $< refers to the source file, so the .asm files
# after all the variable subsitution takes place, the line below should look
# something like this: nasm -f elf64 -F dwarf -g -l imul.lst imul.asm
# where imul is substituted for all the different .asm files you want to compile

	$(CC) $(CFLAGS) $@.lst $<

# next we want to link so we can get the executable
# our linker variable is set to ld
#

#	$(LD) $(LDFLAGS) $(PROGS) $@
#
# now we have to link, so we are just going to run the command below
# for all files in the directory, represented by $@
	ld -o $@ -m elf_x86_64 $@.o

clean:
	#in order to clean up, we will forcefully remove (rm -f) all files
	#ending in .lst and all files ending in .o
	rm -f *.lst *.o

	#we will also clean up the binaries by using the command below
	#which will delete everything in the directory without a file extension.
	#find . -type f -not -iname "*.*" -exec rm '{}' \; #this doesn't work, it gets rid of the Makefile
	#find . -type f -executable -delete #this doesn't work, it gets rid of the asm files...
	
	rm -f $(PROGS) #this works!! gets rid of all executables.
