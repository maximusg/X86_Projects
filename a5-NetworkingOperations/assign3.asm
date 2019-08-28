;Max Geiszler
;08MAY19
;CS3140/Assignment 3
;Command line to assemble program:
;nasm -f elf64 assign3.asm
;Command line to link object file to executable:
;ld -o assign3 -m elf_x86_64 assign3.o
;command line arguments:
;./assign3 //will execute the program.
;details:
;type any string and press enter, will mimic Unix "cat" untility, but swaps
;cases. To exit program use ctrl+c or ctrl+d
bits 64

section .text                  ;main code section

global _start                  ;sets _start for linker

_start:

    call .getInputAndConvert   ;gets string input from user, and converts
    
    
.end:                          ;jumped to when user inputs ctr+D to exit
    xor rdi, rdi               ;set return value to 0
    mov rax, 60                ;system call number (system exit)
    syscall                    ;call kernel exit program

.getInputAndConvert:
    mov rax, 0                 ;use stdin
    mov rdi, 0                 ;set for read()
    mov rsi, buff              ;read in 1 byte to buffer
    mov rdx, 1                 ;read in 1 byte
    syscall                    ;call kernel get user input
    cmp rax, 1                 ;check for error (less than 1), or zero
    jl .end                    ;jump to end program if error or zero
    
.charRead:                     ;check char then write to sys.out
    mov al, [buff]             ;move value at location in rdx into al
    cmp al, 'a'                ;compare al to 'a' ascii value
    jl  .upper                 ;if al value is less jmp to check uppercase
    cmp al, 'z'                ;compare al to 'z' ascii value
    jg .printOutput            ;jmp if al value is greater than not a letter
    xor byte[buff], 0x20        ;convert lowercase ascii to upercase ascii
    jmp .printOutput           ;after replacement occured jump to next letter
.upper:                        ;check if uppercase char
    cmp al, 'A'                ;compare al to 'A" ascii value
    jl  .printOutput           ;if less than, then its not a letter
    cmp al, 'Z'                ;compare al to 'Z' ascii vlaue
    jg .printOutput            ;if greater than then not a letter
    xor byte[buff], 0x20       ;convert uppercase ascii to lowercase ascii

.printOutput:                  ;prints output after .getInputAndConvert
    xor rsi, rsi               ;clear rsi
    mov rsi, buff              ;point rsi to buff
    mov rdx, 1                 ;place the message length (1) into rdx
    mov rdi, 1                 ;set rdi to write
    mov rax,1                  ;use stdout
    syscall                    ;write the output from rsi to stdout

    jmp .getInputAndConvert    ;return to start.

section .data
buff:            db      0     ; 1 byte buffer
