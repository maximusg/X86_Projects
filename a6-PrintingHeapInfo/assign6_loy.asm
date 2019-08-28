;----------------------------------------------------------------------------
; Name: Loy Yao Wen
; Due Date: 14 June 2019
; Course: CS3140 Assignment 6
;
; To assemble into 64-bits Linux object file & compile into an excutable file:
;	nasm -f elf64 start.asm
;   nasm -f elf64 assign6.asm
;	gcc -o assign4 -m64 main.c assign4.o start.o -nostdlib \
;        -nodefaultlibs -fno-builtin -nostartfiles
;
; To run the programe:
;       ./assign6  <may add a file name or other arguement when necessary>
;
; Description - This 64 bits assembly code with some commonly used functions.
;----------------------------------------------------------------------------


bits 64

    global heap_walk
    extern get_brk
    extern printf

section .text


;----------------------------------------------------------------------------

;rdi *heap_base
;heap_stats *stats);
    
heap_walk:
    
.prelogue:

	push rbp
	mov	 rbp, rsp
	push rbx
	push rsi
	push rdi

; initialise with function input
    mov [heap_base], rdi
    mov [current_block], rdi
    mov [_heap], rsi

    call get_brk
    ;sub rax, 8 
    mov [_heap + _heap_stats.tail_chunk], rax ; update address in struc






.loopstart:
	mov	r8, [current_block+8]
	test r8, 1
	jz	.count_free_block

.count_used_block:
	mov	r8, [current_block+8]
    inc dword[_heap_stats.num_allocated_blocks]
    dec r8
    imul r8, 16

    cmp qword[_heap_stats.first_allocated], 0
    je .update_first

   mov r9, [current_block] ;offset 32
   mov [_heap_stats.last_allocated], r9

    ; print
    mov rdi, allocated
    mov rsi, r8
    xor rax, rax
    call printf




    cmp [_heap_stats.largest_allocated], r8
    jg .advance_list
    mov [_heap_stats.largest_allocated], r8
    jmp .advance_list




.count_free_block:
	mov	r8, [current_block+8]
    inc dword[_heap_stats.num_free_blocks]

    imul r8, 16

    mov rdi, allocated
    mov rsi, r8
    xor rax, rax
    call printf


    cmp [_heap_stats.largest_free], r8
    jg .advance_list
    mov [_heap_stats.largest_free], r8
    jmp .advance_list



.advance_list:

	add	[current_block], r8

    mov r10, [current_block]
	cmp	r10, [_heap + _heap_stats.tail_chunk]
	jge	.epilogue
	jmp .loopstart
	
.epilogue:
	pop	rdi
	pop	rsi
	pop	rbx
	pop	rbp
	ret



.update_first:
    mov r10, [current_block]
    mov [_heap_stats.first_allocated], r10
    ret


;----------------------------------------------------------------------------



    
 
    

    
   ; need to know how to terminate the loop
    
; inc_block

;     mov rax, 0x0000000000000001
;     mov rbx, [current_block]
    
; break3:
;     add rbx, 8
;     mov rcx, [rbx]
;     and rax, rcx
;     ; pass in heap base, from the data structure

; break4:
;     cmp rax, 0


;     mov rdi, address
;     mov rsi, rdx
;     xor rax, rax
;     call printf

; print:
;     mov rax, 1              ; write
;     mov rdi, 1              ; stdout
;     mov rsi, rf_msg         ; resolv fail msg
;     mov rdx, rf_msg_len     ; msg len
;     syscall           


  ;  if u use .bss, need -no -pie


; reserve the necessary space
SECTION .bss  

; struct for _heap_stats
    struc _heap_stats
        .num_free_blocks: resd 1 ;offset 0
        .num_allocated_blocks: resd 1 ;offset 4
        .largest_allocated: resq 1 ;offset 8
        .largest_free: resq 1 ;offset 16
        .first_allocated: resq 1 ;offset 24
        .last_allocated: resq 1 ;offset 32
        .tail_chunk: resq 1 ;offset 40
    endstruc




    rand_num resb 5         ; declare 5 bytes space of rand_num

; contain initialised data
SECTION .data     



    ; b extern allocated
    ;system call numbers
    SYS_EXIT equ 60
    SYS_READ equ 0
    SYS_WRITE equ 1
    SYS_OPEN equ 2
    SYS_CLOSE equ 3
    O_RDONLY equ 0


    _heap: istruc _heap_stats
    ; randomly defined struct for program use
    ; will be updated by the program
        at _heap_stats.num_free_blocks, dw 0 ;offset 0
        at _heap_stats.num_allocated_blocks, dw 0 ;offset 4
        at _heap_stats.largest_allocated, dd 0 ;offset 8
        at _heap_stats.largest_free, dd 0 ;offset 16
        at _heap_stats.first_allocated, dq 0x0000000000000000 ;offset 24
        at _heap_stats.last_allocated, dq 0x0000000000000000 ;offset 32
        at _heap_stats.tail_chunk, dq 0x0000000000000000 ;offset 40
    iend   

    ;bucket_array	times 4 dd	0 
    heap_lower_limit    dd  0
    heap_upper_limit    dd  0
    heap_base           dq 0x0000000000000000
    current_block       dq 0x0000000000000000
; declare variable


section .rodata

allocated: db `%p: Allocated (%lld bytes)\n`,0
unallocated: db `%p: Unallocated (%lld bytes). next: %p, prev: %p\n`,0
tail: db `%p: Tail (%lld bytes)\n`,0

total_alloc: db `A total of %lld bytes are allocated\n`,0
total_free: db `A total of %lld bytes are free\n`,0