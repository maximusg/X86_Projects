all: assign4

assign4: assign4.asm
	nasm -f elf64 -F dwarf -g assign4.asm
	nasm -f elf64 -F dwarf -g start.asm
	# gcc -g -static -o assign4 main2.c assign4.o start.o -nostdlib \
	# 	-nodefaultlibs -fno-builtin -nostartfiles
	gcc -g -no-pie -o assign4 -m64 main.c assign4.o start.o  -fno-builtin -nostartfiles

clean:
	rm -f assign4.o assign4 start.o start
