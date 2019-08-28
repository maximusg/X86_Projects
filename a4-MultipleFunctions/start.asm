;start.asm

bits 64

extern main
global _start

section .text

_start:
   lea   rsi, [rsp + 8]
   mov   rdi, [rsp]
   lea   rdx, [rsi + rdi * 8 + 8]
   call  main
   mov   rdi, rax
   mov   eax, 60
   syscall
