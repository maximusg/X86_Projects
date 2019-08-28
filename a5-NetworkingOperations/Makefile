all: assign5

assign5: assign5.asm
	nasm -f elf64 -F dwarf -g assign5.asm
	nasm -f elf64 -F dwarf -g assign3.asm
	gcc -g -no-pie -o assign3 assign3.o -nostdlib -nodefaultlibs -fno-builtin -nostartfiles
	gcc -g -no-pie -o assign5 assign5.o dns64.o -nostdlib -nodefaultlibs -fno-builtin -nostartfiles

clean:
	rm -f assign5.o assign5