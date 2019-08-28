all: assign6

assign6: assign6.asm
	nasm -f elf64 -F dwarf -g assign6.asm
	nasm -f elf64 -F dwarf -g _brk.asm
	nasm -f elf64 -F dwarf -g start.asm
	nasm -f elf64 -F dwarf -g formats6.asm
	gcc -g -no-pie -o assign6 -m64 tester.c assign6.o _brk.o start.o formats6.o  -fno-builtin -nostartfiles

clean:
	rm -f assign6.o  assign6 _brk.o _brk start.o start formats6.0 formats6
