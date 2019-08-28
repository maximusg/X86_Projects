; Max Geiszler
; 12MAY19
; CS3140/Assignment 6
; Heap walk, print stats from heap.
; Command line to link object file to executable:
; nasm -f elf64 -F dwarf -g assign6.asm
; nasm -f elf64 -F dwarf -g _brk.asm
; nasm -f elf64 -F dwarf -g start.asm
; nasm -f elf64 -F dwarf -g formats6.asm
; gcc -g -no-pie -o assign6 -m64 tester.c assign6.o _brk.o start.o formats6.o  /
; -fno-builtin -nostartfiles
; command line arguments:
; ./assign6
; Implementation to comply with pdf document. 
; Must have a assign6.asm, start.asm, _brk.asm, formats6.asm and a tester.c file


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

struc _heap_stats                              ; structure to keep heap stats
  .num_free_blocks:         resd  1            ; 4bytes
  .num_allocated_blocks:    resd  1            ; 4bytes
  .largest_allocated:       resq  1            ; 8bytes
  .largest_free:            resq  1            ; 8bytes
  .first_allocated:         resq  1            ; 8bytes
  .last_allocated:          resq  1            ; 8bytes
  .tail_chunk:              resq  1            ; 8bytes
endstruc                                           

%include "formats6.asm"                               
global heap_walk                                      ; called by c file
extern get_brk                                        ; to find end of heap
extern printf                                         ; use exteranl printf func

section .text                                         ; main code section

heap_walk:                                            ; 
    push rbp                                          ; save stack frame
    add rdi, 8                                        ; 
    mov [cur_loc], rdi                                ; points to first size
    mov [print_struct], rsi                           ; pointer to struct
    call get_brk                                      ; 
    mov [top_chunk], rax                              ; pointer to heap top_chunk

    .first_iter:                                      ; from heap_base
        mov r10, [cur_loc]                            ; point r10 to heap loc
                                                      ; if current location 
        mov rax, [top_chunk]                          ; >=top_chunk then
        cmp r10, rax                                  ; 
        jge .done                                     ; jump to done 
        mov rdi, [r10]                                ; derefernces current_loc
        and rdi, 0xfffffff0                           ; removes 1 off size
        mov [last_chunk_addr], r10                    ; save addr for stats
        mov [last_chunk_size], rdi                    ; save size for stats
        add r10, rdi                                  ; point to next chunk size
        mov [cur_loc], r10                            ; save current location

    .heap_loop:                                       ; loops through heap
        mov r10, [cur_loc]                            ; point to current_loc
                                                      ; if current location 
        mov rax, [top_chunk]                          ; >=top_chunk then
        cmp r10, rax                                  ; 
        jge .done                                     ; jump to done
        mov rdi, [r10]                                ; derefernces current_loc
        mov rbp, [r10+8]                              ; save next and prev
        mov [this_chunk_next], rbp                    ; 
        mov rbp, [r10+16]                             ; 
        mov [this_chunk_prev], rbp                    ; 
        mov rbp, rdi                                  ; check last address free
        and rbp, 01                                   ; check if p bit 0 or 1
        and rdi, 0xfffffff0                           ; strip 1 bit from rdi
        mov [this_chunk_addr], r10                    ; save address
        mov [this_chunk_size], rdi                    ; save size
        xor rax,rax                                   ; 
        cmp rax,rbp                                   ; compare p bit to 0
        je .unalloc                                   ; jump if free to unalloc
                                                      ; allocated if no jmp
        .stats_tot_allocated:                         ; count allocated bytes
        mov rbx, [last_chunk_size]                    ; total the number
        mov rdi, [total_alloc_mem]                    ; of bytes
        add rdi, rbx                                  ; 
        mov [total_alloc_mem], rdi                    ; save in address space

        .stats_numb_allocated:                        ;count blocks code 
        mov  edi, [internal_heap + _heap_stats.num_allocated_blocks] 
        inc rdi                                       ;increment blocks number 
        mov dword [internal_heap + _heap_stats.num_allocated_blocks], edi
                                                                         
        .stats_largest_allocated:                     ; check largest
        mov  rdi, [internal_heap + _heap_stats.largest_allocated] 
        cmp rdi, rbx                                  ; rbx contains last size                   
        jg .stats_first_allocated                     ; if larger then save 
        add rbx, -16                                  ; remove head info size
        mov qword [internal_heap + _heap_stats.largest_allocated], rbx   
                                                                         
        .stats_first_allocated:                       ; check first allocated
        mov  rdi, [internal_heap + _heap_stats.first_allocated]
        mov rbx, [last_chunk_addr]                    ; save if needed 
        xor rax,rax                                                     
        cmp rdi, rax                                  ; compare w/ empty val
        jne .stats_last_allocated                     ; if not empty jump over 
        add rbx, -8                                   ; reposition from size
        mov qword [internal_heap + _heap_stats.first_allocated], rbx 
        add rbx, 8                                    ; add back to size
                                                                       
        .stats_last_allocated:                        ; save stats each iter
        add rbx, -8                                   ; reposistion from size
        mov qword [internal_heap + _heap_stats.last_allocated], rbx
                                                      ; rbx still address
                                                      ; print allocated message
        mov rdi, allocated                            ; load string format 
        mov rsi, [last_chunk_addr]                    ; first param 
        add rsi, -8                                   ; reposistion from size
        mov rdx, [last_chunk_size]                    ; second param 
        xor rax,rax                                   ; clear dont use xmm reg
        call printf                                   ; print 
        jmp .endloop                                  ; continue chunk loop 
        .unalloc:                                     ; free memory section
                                                      ; stats section
            .stats_tot_free:                          ; count free bytes 
            mov rbx, [last_chunk_size]                ; total the number 
            mov rdi, [total_free_mem]                 ; of bytes 
            add rdi, rbx                              ; 
            mov [total_free_mem], rdi                 ; 
            .stats_numb_free:                         ; count blocks code 
            mov  edi, [internal_heap + _heap_stats.num_free_blocks]
            inc rdi                                   ; increment blocks number
            mov dword [internal_heap + _heap_stats.num_free_blocks], edi
            .stats_largest_free:                      ; check largest
            mov  edi, [internal_heap + _heap_stats.largest_free] 
            cmp rdi, rbx                              ; rbx contains last size
            jg .print                                 ; if larger then save
            add rbx, -16                              ; remove head info size
            mov qword [internal_heap + _heap_stats.largest_free], rbx
           
                                                      ; 
            .print:                                   ; print free memory
            mov rdi, unallocated                      ; load string format
            mov rsi, [last_chunk_addr]                ; first param
            add rsi, -8                               ; reposistion from size
            mov rdx, [last_chunk_size]                ; second param
            mov rcx, qword [last_chunk_next]          ; thrid param
            mov r8, qword [last_chunk_prev]           ; 4th param
            xor rax,rax                               ; clear dont use xmm reg
            call printf                               ; print

        .endloop:                                     ; after print code
            mov r10, [this_chunk_addr]                ; move current to r10
            mov rdi, [this_chunk_size]                ; move size to rdie
            add r10, rdi                              ; get next chunk location
            mov [cur_loc], r10                        ; update current location
            call swap_this_to_last                    ; swap this chunk info
            jmp .heap_loop                            ; continue to loop chunks
                                                      
    .done:                                            ; after chunk loop code
                                                      ; count tail as free blk+1
        mov  edi, [internal_heap + _heap_stats.num_free_blocks]
        inc rdi
        mov dword [internal_heap + _heap_stats.num_free_blocks], edi
                                                        ;add tail memory on to 
        mov rbx, [last_chunk_size]                      ;total free
        mov rdi, [total_free_mem]                       
        add rdi, rbx                                    
        mov [total_free_mem], rdi                       
        
        mov rdi, tail                                   ; print tail location 
        mov rsi, [last_chunk_addr]                      ; first param
        add rsi, -8                                     ; reposistion from size
        mov [tail_chunk], rsi                           ; save for stat print
        mov rdx, [last_chunk_size]                      ; second param
        xor rax,rax                                     ; clear dont us xmm reg
        call printf                                     ; print
                                                        ; print totals alloc
        mov rdi, total_alloc                            ; load string format
        mov rsi, [total_alloc_mem]                      ; first param
        xor rax, rax                                    ; clear dont use xmm reg
        call printf                                     ; print
                                                        ; print total free
        mov rdi, total_free                             ; load string format
        mov rsi, [total_free_mem]                       ; first param
        xor rax, rax                                    ; clear done use xmm reg
        call printf                                     ; print
                                                        ; 
    .updateStats:                                       ; internal struc update
                                                        ; c program's stat struc
        mov rbx, [print_struct]                                        
        mov  edi, [internal_heap + _heap_stats.num_free_blocks]        
        mov  dword [rbx + _heap_stats.num_free_blocks], edi            
        mov  edi, [internal_heap + _heap_stats.num_allocated_blocks]   
        mov  dword [rbx + _heap_stats.num_allocated_blocks], edi       
        mov  rdi, [internal_heap + _heap_stats.largest_allocated]      
        mov  qword [rbx + _heap_stats.largest_allocated], rdi          
        mov  rdi, [internal_heap + _heap_stats.largest_free]           
        mov  qword [rbx + _heap_stats.largest_free], rdi               
        mov  rdi, [internal_heap + _heap_stats.first_allocated]        
        mov  qword [rbx + _heap_stats.first_allocated], rdi            
        mov  rdi, [internal_heap + _heap_stats.last_allocated]         
        mov  qword [rbx + _heap_stats.last_allocated], rdi             
        mov rdi, [tail_chunk]                                           
        mov  qword [rbx + _heap_stats.tail_chunk], rdi                 
                                                                 
    call clear_mem                                     ; clears all internal mem
    pop rbp                                            ; reposistion rbp
    mov rdi, 0                                         ; return 0
    mov rax, 0                                         ; return 0
    ret                                                ; ret to c code
 
    swap_this_to_last:                                 ; swaps current chunk
        mov rdi, [this_chunk_addr]                     ; information to the
        mov [last_chunk_addr], rdi                     ; last chunks information
        mov rdi, [this_chunk_size]                     ; in order to prior chunk
        mov [last_chunk_size], rdi                     ; info for printing and 
        mov rdi, [this_chunk_next]                     ; stats comparisions
        mov [last_chunk_next], rdi                     
        mov rdi, [this_chunk_prev]                     
        mov [last_chunk_prev], rdi                     
        ret 
    clear_mem:                                          ;clears internal mem 
        xor rax, rax
        mov dword[internal_heap + _heap_stats.num_free_blocks], eax 
        mov dword[internal_heap + _heap_stats.num_allocated_blocks], eax 
        mov qword[internal_heap + _heap_stats.largest_allocated], rax 
        mov qword[internal_heap + _heap_stats.largest_free], rax
        mov qword[internal_heap + _heap_stats.first_allocated], rax
        mov qword[internal_heap + _heap_stats.last_allocated], rax
        mov qword[internal_heap + _heap_stats.tail_chunk], rax
        mov [top_chunk], rax
        mov [tail_chunk],rax
        mov [print_struct],rax
        mov [cur_loc],rax
        mov [this_chunk_addr], rax
        mov [this_chunk_next], rax
        mov [this_chunk_prev], rax
        mov [this_chunk_next], rax
        mov [last_chunk_addr], rax
        mov [last_chunk_next], rax
        mov [last_chunk_prev], rax
        mov [last_chunk_next], rax 
        mov [total_free_mem], rax
        mov [total_alloc_mem], rax                                 

section .bss                                           
    internal_heap: resb _heap_stats_size               ; create internal struct
    top_chunk: resq 1                                  ; save the top chunk
    tail_chunk: resq 1                                 ; save the tail chunk
    print_struct: resq 1                               ; save c struct pointer
    cur_loc: resq 1                                    ; pointer to cur location

    last_chunk_addr: resq 1                            ; this and last
    this_chunk_addr: resq 1                            ; chunk info
    last_chunk_size: resq 1                            ; used during loop
    this_chunk_size: resq 1                            ; iterations
    this_chunk_next: resq 1                            ; 
    last_chunk_next: resq 1                            ; 
    this_chunk_prev: resq 1                            ; 
    last_chunk_prev: resq 1                            ; 

    total_free_mem: resq 1                             ; free number of bytes
    total_alloc_mem: resq 1                            ; alloc number of bytes
