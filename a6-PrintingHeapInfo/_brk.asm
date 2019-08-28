bits 64

global get_brk
global set_brk

%define SYS_BRK 12

; C prototypes: void *set_brk(void *new_brk);
; C prototypes: void *get_brk();

get_brk:
   xor rdi, rdi        ; set a brk increment of 0 to induce failure and learn current break
   ; just drop into set_break to finish the brk call

set_brk:
   ; The argument to brk is the address of the new brk
   ; this should be in rdi on entry
   mov eax, SYS_BRK    ; brk syscall returns new break on success or curent break on failure
   syscall
   ret
