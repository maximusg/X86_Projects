; CS3140 Assignment 3
; To assemble: nasm -f elf64 assign3.asm
; To link: ld -o assign3 -m elf_x86_64 assign3.o
; Description: Mimic the standard implementation of "cat" with a twist.
; Command argument: None 

bits 64

section .text

; global _start

_start:
read:	
    mov     rdi, 0                  ; fd=stdin
    mov     rsi, buf                ; *buf
    mov     rdx, 1                  ; count=1 (read 1 byte)
    mov     rax, 0                  ; read() system call 
    syscall

    cmp     rax, 1                  ; Stop reading if returned value is not 1
    jne     done

compare:
    mov     bl, [buf]               ; Get the input byte

    and     bl, 0xdf                ; Mask off the 6th bit
                                    ; If input byte is a letter, this will
                                    ; switch it to uppercase
    
    cmp     bl, 'A'                 ; If masked byte < 0x41 (uppercase A)
    jl      write                   ; Skip it

    cmp     bl, 'Z'                 ; If masked byte > 0x5A (uppercase Z)
    jg      write                   ; Skip it too

switch:                             ; 
    xor     byte [buf], 0x20        ; Convert original byte

write:
    mov     rdi, 1                  ; fd=stdout
    mov     rsi, buf                ; *buf
    mov     rdx, rax                ; count=number of bytes read
    mov     rax, 1                  ; write() system call 
    syscall

    jmp     read                    ; Continue to read

done:
    xor     rdi, rdi                ; Set return value to zero
    mov     rax, 60
    syscall


section .data
buf:            db      0           ; Working buffer
