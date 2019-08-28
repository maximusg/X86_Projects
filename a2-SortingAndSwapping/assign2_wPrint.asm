;Max Geiszler
;24APR19
;CS3140/Assignment 2
;Command line to assemble program:
;nasm -f elf64 assign2.asm
;Command line to link object file to executable:
;ld -o assign2 -m elf_x86_64 assign2.o
;command line arguments:
;./assign2 //will execute the program. The "output" array will print in termnial
;echo $? //will print the global variable "swaps" which gets saved to edi reg prior to exit
bits 64

section .text                           ;main code section

global _start                           ;sets _start for linker

; do not rename or delete any of the labels in this program
_start:
        call _program                   ;runs the program
        call _printOutput               ;prints "output"
        mov     edi, [passes]		;set edi reg to "passes" value to be referenced from terminal
        mov     eax, 60                 ;system call number (system exit)
	syscall                         ;call kernal


_program:
        mov     edx, ARRAY_LEN - 1 	;load edx for outerloop counter
outerloop:
        mov     ecx, 0			;load ecx for innerloop counter. Loads to zero on each loop
	mov	bx, 1			;set bx to 1. Using bx as a flag for swaps
innerloop:
        mov     ax, [array + ecx]	;move the first two chars starting at ecx, into ax register
        cmp     al, ah			;compare al and ah register values (high and low bytes in ax)
        jge     next			;jump to "next" if al is greater than ah
	mov	bx, 0			;set bx to zero because a swap has occured
        xchg    al, ah			;if al is  greater than ah then swap al with ah
	add	dword [swaps], 1	;increment swaps by 1
        mov     [array + ecx], ax	;ax values now being swapped are then placed into memory "array" in proper location
next:
        inc     ecx			;increments innerloop value	
        cmp     ecx, edx		;compares innerloop with outerloop
        jl      innerloop		;jumps if innerloop ecx is less than outerloop edx value
endinner:
	add	dword [passes], 1       ;increment (outerloop) passes by 1.
	cmp	bx, 0                   ;compare if swap flag is zero
	jnz	done                    ;if swap flag not zero finish loop early
        dec     edx			;when not jumping to innerloop, then we decrement outerloop edx
        jnz     outerloop		;if edx value is not yet zero, then repeat the innerloop
done:
	cld				;set df to zero, so it copies in the correct direction
	mov rcx, ARRAY_LEN		;set count in rcx, to size of the array
	mov rdi, output			;set desination addr
	mov rsi, array			;set source addr
	rep movsb			;move the string
	
	syscall                         ;call kernal
        ret                             ;return to start

;used https://stackoverflow.com/questions/41983970/linux-system-call-for-x86-64-echo-program
_printOutput:
        mov rax, 1                      ;set rax first syscall
        mov rdi, 1                      ;set rdi to pass first argument
        mov rsi, output                 ;set rsi to point to output
        mov rdx, ARRAY_LEN              ;set size of array in rsi
        syscall                         ;syscall prints to the terminal
        ret                             ;returns to _start

        

section .data                           ;start of the data section for var names
passes: dd 0                            ;create "passes" var to double word size set to 0      
swaps: dd 0                             ;creat "swaps" var to double word size set to 0



; ------ DO NOT CHANGE ANYTHING BETWEEN HERE ----------
; This variable must remain named exactly 'array'
array: db 'Will you please sort this string for me?' ;array double bye size with input sring
ARRAY_LEN equ $-array                   ;create "ARRAY_LEN" var to refer to size of array. set to size of array
pad: times (256 - ARRAY_LEN) db 0       ;create "pad" var to badd array
; ------------------ AND HERE -------------------------


section .bss
output: resb ARRAY_LEN                        ;create "output" var array at size of array
