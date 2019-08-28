bits 64

section .text                           ;main code section

global _start                           ;sets _start for linker

_start:
    ; mov rbp, rsp ;not sure what this is
    ; sub rsp, 128 ;allocate read buffer on stack
    ; mov rsi, 16  ;max letters 16 *8 =128
    ; mov rdi, rsp ; point rdi to read buffer

    call _printText                 ;prints msg to stdout
    ; mov rbp, rsp ;not sure what this is
    sub rsp, 128 ;allocate read buffer on stack
    ; mov rsi, 16  ;max letters 16 *8 =128 not used
    
    mov rsi, rsp ; point rdi to read buffer
    call _getInputAndConvert        ;gets string input from user, and converts it
   
    call _printOutput             ;prints prints converted input
    call _start                    ;loops to do it again
    
    mov     eax, 60                 ;system call number (system exit)
	syscall                         ;call kernal

_printText:
    ; mov r8, rdi ;saves pointer tor rsp -128
    ; mov r9, rsi ; saves 16 in r9


    mov eax, 1
    mov edi, 1
    mov rsi, msg
    mov rdx, msg_len
    syscall

    ; mov rsi, r8 ; point rsi back to original rsp -128
    ; mov rdx, r9 ;saves 16 into rdx ?? how is this used?
    ret;

_getInputAndConvert:
    
    mov eax, 0      ;use stdin
    mov edi, 0      ; read()
    syscall
    mov rbx, rax ; save readcount  out of rax into rbx
    lea rdx, [rsp -1]   ;get address of the byte preceding read buffer
_charRead:
    inc rdx
    mov al, [rdx]
    cmp al, 'a'
    jl  _upper
    cmp al, 'z'
    jg _checkEnd 
    xor al, 0x20
    mov [rdx], al
    jmp _charRead
_upper:
    cmp al, 'A'
    jl  _checkEnd
    cmp al, 'z'
    jg _checkEnd
    xor al, 0x20
    mov [rdx], al
    jmp _charRead
_checkEnd:
    cmp al, 10 ;check for LF
    jnz _charRead
    syscall
    ret

_printOutput:
                 ;rsi is pointing where it needs
    mov rdx, rbx ;message length into rdix
    mov rdi, 1
    mov rax,1
    syscall
    ret








section .data

rctxs: times 256 db 0
rctxi: db 0
rctxj: db 0

msg: db `Please enter user input:`, 10, ;string to ask user to enter input with return chars LF
msg_len equ $-msg


