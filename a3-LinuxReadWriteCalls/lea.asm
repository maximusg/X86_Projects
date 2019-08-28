;
; Excerpt from assign1.asm
;

bits 64

section .text

global _start

hello:
    mov     r8, rdi                 ; save parameters
    mov     r9, rsi

    mov     rsi, msg
    mov     edi, 1
    mov     rdx, msg_len
    mov     eax, 1                  ; write()
    syscall

    mov     rdx, r9                 ; number of bytes to read
    mov     rsi, r8                 ; read buffer
    mov     edi, 0                  ; use stdin
    mov     eax, 0                  ; read()
    syscall
    ret

_start:
    mov     rbp, rsp
    sub     rsp, 128                ; allocate read buffer on stack
    mov     rsi, 16                 ; max input length
    mov     rdi, rsp                ; rdi points to read buffer
    call    hello                   ; rsi points to read buffer

after:
    mov     rbx, rax		        ; save read count returned from hello()
    lea     rdx, [rsp - 1]          ; get address of the byte preceding read buffer
;    mov     rdx, [rsp - 1]          ; what's the difference?

L1:
    inc     rdx
    mov     al, [rdx]
Q1:
    cmp     al, 10                  ; check for LF (0x0a)
    jnz     L1 

print:
    mov     rdx, rbx                ; message length
                                    ; RSI already points to read buffer
    mov     rdi, 1                  ; output to stdout
    mov     rax, 1                  ; write()
    syscall

done:
    mov 	rax, 60
    syscall

section .data

msg:        db      `Please enter your NPS user name: `
msg_len     equ     $-msg
