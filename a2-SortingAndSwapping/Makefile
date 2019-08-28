all: assign2

assign2: assign2.asm
	nasm -f elf64 -F dwarf -g assign2.asm
	ld -o assign2 -m elf_x86_64 assign2.o
clean:
	rm -f assign2.o assign2
