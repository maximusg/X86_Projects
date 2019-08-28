; Max Geiszler
; 31MAY19
; CS3140/Assignment 5
; Network Cat
; Command line to link object file to executable:
; nasm -f elf64 -F dwarf -g assign5.asm
; nasm -f elf64 -F dwarf -g assign3.asm
; gcc -g -no-pie -o assign3 assign3.o -nostdlib -nodefaultlibs -fno-builtin
; -nostartfiles
; gcc -g -no-pie -o assign5 assign5.o dns64.o -nostdlib -nodefaultlibs
; -fno-builtin -nostartfiles
; command line arguments:
; ./assign5 <hostName> <portNumber>
; details:
; implementation to comply with pdf document. Must have a assign5.asm
; assign3.asm and dns64.o files

bits 64

; DB allocates 1 byte.
; DW allocates 2 bytes.
; DD allocates 4 bytes.
; DQ allocates 8 bytes.
; So I assume that:
; RESB 1 allocates 1 byte.
; RESW 1 allocates 2 bytes.
; RESD 1 allocates 4 bytes.
; RESQ 1 allocates 8 bytes.

struc _heap_stats                               ; structure to keep heap stats
  .num_free_blocks:         resd  1             ; 4bytes
  .num_allocated_blocks:    resd  1             ; 4bytes
  .largest_allocated:       resq  1             ; 8bytes
  .largest_free:            resq  1             ; 8bytes
  .first_allocated:         resq  1             ; 8bytes
  .last_allocated:          resq  1             ; 8bytes
  .tail_chunk:              resq  1             ; 8bytes
endstruc

%include "formats6.asm"
global heap_walk
extern get_brk                                  ; set _brk to be called
extern printf

section .text                                   ; main code section

heap_walk:
    push rbp
    mov [heap_base], rdi ;pointer to heap_base
    add rdi, 8
    mov [cur_loc], rdi ; points to first size in
    mov [print_struct], rsi ;pointer to struct
    call get_brk
    mov [top_chunk], rax ;pointer to heap top_chunk

    .first_iter: ; from heap_base
        mov r10, [cur_loc] ;point rdi to current_loc
        ;if current location >=top_chunk then finish
        mov rax, [top_chunk]
        cmp r10, rax
        jge .done ;jump to done if cur_loc >= top_chunk

        mov rdi, [r10] ;derefernces current_loc number
        and rdi, 0xfffffff0 ;rdi should now be 1 less than before
        mov [last_chunk_addr], r10 ;save for addr comparison later
        mov [last_chunk_size], rdi ;save size for comparison later
        
        add r10, rdi 
        ; call swap_this_to_last ;makes the first chunk the last chunk looked at
        
        mov [cur_loc], r10

    .heap_loop: ;loops through stack by size
    ;rdi, %rsi, %rdx, %rcx, %r8 and %r9
        mov r10, [cur_loc] ;point to current_loc
        ;if current location >=top_chunk then finish
        mov rax, [top_chunk]
        cmp r10, rax
        jge .done ;jump to done if cur_loc >= top_chunk
        mov rdi, [r10] ;derefernces current_loc number
        mov ebp, [r10+8] ;save next and prev
        mov [this_chunk_next], rbp
        mov ebp, [r10+16] 
        mov [this_chunk_prev], rbp
        mov rbp, rdi ;check if last address unallocated
        and rbp, 01 ; check if p bit 0 or 1
        and rdi, 0xfffffff0 ;strip 1 bit from rdi
        mov [this_chunk_addr], r10
        mov [this_chunk_size], rdi
        xor rax,rax
        cmp rax,rbp
        je .unalloc ;check if last chunk allocated
        
        
        ;stats update 
        .stats_tot_allocated:
        mov rbx, [last_chunk_size]
        mov rdi, [total_alloc_mem]
        add rdi, rbx
        mov [total_alloc_mem], rdi

        .stats_numb_allocated:
        mov  edi, [internal_heap + _heap_stats.num_allocated_blocks] ;eax points to struct
        ; mov dword edi, [rax] 
        ; mov rbx, [last_chunk_size]
        ; add rdi, rbx
        inc rdi
        mov dword [internal_heap + _heap_stats.num_allocated_blocks], edi

        .stats_largest_allocated:
        mov  rdi, [internal_heap + _heap_stats.largest_allocated] ;rax points to struct
        ; mov rdi, [rax] ;contents in rdi should be 64bits
        cmp rdi, rbx ;compare with chunk size
        jg .stats_first_allocated ;if rdi bigger jump
        mov qword [internal_heap + _heap_stats.largest_allocated], rbx ;update

        .stats_first_allocated:
        mov  rdi, [internal_heap + _heap_stats.first_allocated] ;rax points to struct
        mov rbx, [last_chunk_addr]
        xor rax,rax
        cmp rdi, rax ;compare with chunk size
        jne .stats_last_allocated ; if not zero then update for the first time.
        add rbx, -8
        mov qword [internal_heap + _heap_stats.first_allocated], rbx ;update


        .stats_last_allocated:
        add rbx, -8
        mov qword [internal_heap + _heap_stats.last_allocated], rbx ;always update


        ;print allocated message
        mov rdi, allocated
        mov rsi, [last_chunk_addr]
        add rsi, -8
        mov rdx, [last_chunk_size]
        xor rax,rax
        ;rax is 0 still
        call printf
        jmp .endloop
        .unalloc: ;print unallocated message
            ;keep stats
            ;stats update 
            .stats_tot_free:
            mov rbx, [last_chunk_size]
            mov rdi, [total_free_mem]
            add rdi, rbx
            mov [total_free_mem], rdi
            .stats_numb_free:
            mov  edi, [internal_heap + _heap_stats.num_free_blocks] ;eax points to struct
            ; mov dword edi, [rax] 
            ; mov rbx, [last_chunk_size]
            ; add rdi, rbx
            inc rdi
            mov dword [internal_heap + _heap_stats.num_free_blocks], edi
            .stats_largest_free:
            mov  edi, [internal_heap + _heap_stats.largest_free] ;rax points to struct
            ; mov rdi, [rax] ;contents in rdi should be 64bits
            cmp rdi, rbx ;compare with chunk size
            jg .print ;if rdi bigger jump
            mov qword [internal_heap + _heap_stats.largest_free], rbx ;update
            
            .print:
            ;print unallocated message
            mov rdi, unallocated
            mov rsi, [last_chunk_addr]
            add rsi, -8 ;subtract 8 
            mov rdx, [last_chunk_size]
            mov rcx, [last_chunk_next]
            mov r8, [last_chunk_prev]
            xor rax,rax
            ;rax is 0 still
            call printf
            ;print unalloc
            ;swap
        
        .endloop:
            mov r10, [this_chunk_addr]
            mov rdi, [this_chunk_size]
            add r10, rdi

            mov [cur_loc], r10 ;save cur_loc
            call swap_this_to_last ; swap this to last
            jmp .heap_loop
        
    ; mov ebp, esp
    mov rdi, test_string ;format
    xor rsi, rsi ;clear rsi first param
    xor rdx, rdx ; clear rdx second param
    xor rax, rax ; no xmm registers (on stack?)

    call printf


    ;printf stack sstuff

    .done:
        ; ;count tail as free_block +1
        ; mov  edi, [internal_heap + _heap_stats.num_free_blocks] ;eax points to struct
        ; inc rdi
        ; mov dword [internal_heap + _heap_stats.num_free_blocks], edi
    ;print tail
        mov rdi, tail
        mov rsi, [last_chunk_addr]
        add rsi, -8 ;subtract 8 
        mov rdx, [last_chunk_size]
        xor rax,rax
        ;rax is 0 still
        call printf
    ;print total_alloc
        mov rdi, total_alloc
        mov rsi, [total_alloc_mem]
        xor rax, rax
        call printf
    ;print total_free
        mov rdi, total_free
        mov rsi, [total_free_mem]
        xor rax, rax
        call printf

    .updateStats:
        ;stats update 
        mov rbx, [print_struct]
        mov  edi, [internal_heap + _heap_stats.num_free_blocks]
        mov  dword [rbx + _heap_stats.num_free_blocks], edi ;eax points to struct
        mov  edi, [internal_heap + _heap_stats.num_allocated_blocks]
        mov  dword [rbx + _heap_stats.num_allocated_blocks], edi ;eax points to struct
        mov  rdi, [internal_heap + _heap_stats.largest_allocated]
        mov  qword [rbx + _heap_stats.largest_allocated], rdi ;eax points to struct
        mov  rdi, [internal_heap + _heap_stats.largest_free]
        mov  qword [rbx + _heap_stats.largest_free], rdi ;eax points to struct
        mov  rdi, [internal_heap + _heap_stats.first_allocated]
        mov  qword [rbx + _heap_stats.first_allocated], rdi ;eax points to struct
        mov  rdi, [internal_heap + _heap_stats.last_allocated]
        mov  qword [rbx + _heap_stats.last_allocated], rdi ;eax points to struct
        mov rdi, [top_chunk]
        mov  qword [rbx + _heap_stats.tail_chunk], rdi
        ; mov dword [rax], 0
        ; mov dword edi, [rax] 
        ; mov ebx, [last_chunk_size]
        ; add edi, ebx
        ; mov dword [print_struct + _heap_stats.num_free_blocks], edi
    pop rbp
    mov rax, 0
    ret

    swap_this_to_last:
        mov rdi, [this_chunk_addr]
        mov [last_chunk_addr], rdi
        mov rdi, [this_chunk_size]
        mov [last_chunk_size], rdi
        mov rdi, [this_chunk_next]
        mov [last_chunk_next], rdi
        mov rdi, [this_chunk_prev]
        mov [last_chunk_prev], rdi
        ret


section .bss
    internal_heap: resb _heap_stats_size
    heap_base: resb 1 ;8bytes pointer
    top_chunk: resq 1 ;8bytes pointer
    print_struct: resq 1;8bytes pointer
    cur_loc: resq 1;8byte pointer
    last_chunk_addr: resq 1;
    this_chunk_addr: resq 1;
    last_chunk_size: resq 1;
    this_chunk_size: resq 1;
    this_chunk_next: resq 1;
    last_chunk_next: resq 1;
    this_chunk_prev: resq 1;
    last_chunk_prev: resq 1;
    total_free_mem: resq 1;
    total_alloc_mem: resq 1;
