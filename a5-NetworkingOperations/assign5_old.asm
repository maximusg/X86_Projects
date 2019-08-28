;Max Geiszler
;20MAY19
;CS3140/Assignment 4
;Library Functions
;nasm -f elf64 assign3.asm
;Command line to link object file to executable:
; nasm -f elf64 -F dwarf -g assign4.asm
; nasm -f elf64 -F dwarf -g start.asm
; gcc -g -no-pie -o assign4 -m64 main.c assign4.o start.o  -fno-builtin \
; -nostartfiles
;command line arguments:
;./assign4 will execute a test harnesss conatined in a file main.c
;details:
; multiple functions implemented by standards oulined in pdf doc

bits 64


struc sockaddr_in
  .sin_family:  resw 1   ;2bytes
  .sin_port:    resw 1   ;2bytes
  .sin_addr:    resd 1   ;4bytes
  .sin_zero:    resb 8   ;8byes
endstruc

global _start
extern resolv

section .text             ;main code section

l_strlen:
                          ;String should be in reg rdi
  .begin:
     push r8              ;keep r8 from being changed
     xor r8, r8      	    ;zero out r8, used for counting
     mov al, 0 		        ;search rdi for 0.
     cld			            ;clear direction flag
  .search:
      inc r8			        ;inc r8 for each letter + null byte
      scasb               ;scan rdi head, inc, compare to al
      jne .search         ;if not found continue scan



  .done:

      dec r8              ; not count the null byte
      mov rax, r8         ; store str length in rax to return
      pop r8              ; retore r8

  ret





l_puts:

  mov rsi, rdi           ;assume string is already in rdi
  call l_strlen          ;put string length into rax

  mov rdx, rax            ;put length into rdx
  mov rdi, 1              ;set rdi to stdout fd
  mov rax, 1              ;set to write
  syscall                 ;open stdout and write
  ret





l_close:
                          ;rdi is file descriptor
                          ;rsi is pointer to error
  mov dword[rsi], 0       ;clear error location
  mov r10, rsi            ; put err into r10
  mov rax, 3              ;
  syscall
  call public.checkErr    ;set err for r10 to call
  ret

l_exit:
                          ;rdi already contains return val
  mov rax, 60             ;normal sys_exit code
  syscall
  ret

l_atoi:
                          ;rdi is char* value pointer
  push rcx                ;save rcx
  push r10                ;save r10
  push r9                 ;save r9
  push r8                 ;save r8


  mov r9, rdi             ;save rdi value
  call l_strlen           ;eats rdi returns length of char in rax
  cmp rax, 0              ;check length >0
  jle .done               ;check length >0 else dont even try
  mov rcx, rax            ;set loop count to strlen
  dec rcx                 ;0th bit counts so decrement 1
  xor rax, rax            ;clear rax
  xor r8, r8              ;clear and use for final number register
  mov r10, 1              ;10s register to multiply value

  .byteCheck:             ;loop for checking each byte
    xor rax, rax          ;clear rax
    mov al, byte[r9+rcx]  ;put first letter of buffer into al
    cmp al, "0"           ;check lower bound ascii
    jl .zeroNumb          ;jump if less than lowerbound to reset regs
    cmp al, "9"           ;check upper bound ascii
    jg .zeroNumb          ;jump if greater than upperbound to reset regs
  .number:                ;number after this point
    sub rax, 48           ;48 makes "0" = 0 so "1"-48 =1..etc
    imul rax, r10         ;multiply rax by 10ths register.
    imul r10, 10          ;multip 10ths reg to track current placement
    add r8, rax           ;add rax to our number reg

    dec rcx               ;decrement rcx for loop
    cmp rcx, 0            ;check rcx
    jge .byteCheck        ;jumps if rcx>=0 include 0 because it's first byte
    jmp .finish           ;all chars have been read, r8 should contain val

  .zeroNumb:              ;zeros r8 reg when non-char number found
    xor r8, r8            ;zero z8 becueaes non char in the way
    mov r10, 1            ;set 10's reg back to 1
    dec rcx               ;dec rcx for loop
    cmp rcx, 0            ;check rcx
    jge .byteCheck        ;back to byteCheck for next byte else finish if <0

  .finish:
    mov rax, r8           ;move final number into Rax
  .done:
    pop r8                ;restore 8,9,10,rcx
    pop r9
    pop r10
    pop rcx
    ret




public:                   ;used for public helper functions
  .checkErr:              ;for checks after syscalls for fd functions
                          ;assumes rax contains value for file descriptor
                          ;assumes r10 contains pointer to int err buffer
    cmp rax, 0            ;checks rax is still positive
    jge .done             ;jump if rax is positive fd to return
                          ;else set error code to abs value of rax
    neg rax               ;abs value is the negative of a negative number
    mov dword [r10], eax  ;move error into r10

    mov rax, -1           ;set rax -1 and returns
    .done:
    ret

_start:

                          ;use r10 as a pointer in the stack

  xor r10, r10            ;0:argc, 1:argv[0], 2:argv[1], 3:argv[2]
  mov r9, qword[r10*8+rsp]      ;points to first item in rsp should be argc
  cmp r9, 3
  jne .not3Args            ;ensures only 3 args are given

  .resolve_host_name:
  xor rax, rax
  mov r10, 2 ;point to argv[1]
  mov rdi, [r10*8+rsp] ;input the hostname into rdi
  call resolv             ;clears r8, r10, changes r11
  mov r14, 0xffffffff
  cmp rax, r14            ;checks output of resolve if -1 then fails
  je .resolveIssue

  ;convert ip address to network byte order htonl
  ; bswap eax

  ;save host address

  mov dword[server + sockaddr_in.sin_addr], eax ;save the ip address

  .get_port_number:
  xor rax, rax
  mov r10, 3 ;pont to argv[2] port number
  mov rdi, [r10*8+rsp]
  call l_atoi ;convert number to int
  cmp rax, 0  ;if socket number is a 0 then did not have a proper socket number
  je .resolveIssue
  xchg  ah,al ;convert port number to network byte order htons

  mov word[server + sockaddr_in.sin_port], ax ; store port number int value in struct

  .open_socket:
  mov rdi, 2 ;AF_INET (Family)
  mov rsi, 1  ;SOCK_STREAM TCP protocol (type)
  mov rdx, 0  ;(protocol)
  mov rax, 41; sys_socket mode to open the socket
  syscall
  ;fd in RAX check if it is negative
  cmp rax, 0 ;check if open socket attempt fails;;;
  jl .connectFail
  mov [socket], rax ;store socket for later uses

  mov word[server + sockaddr_in.sin_family], 2 ;set for AF_INET family


  .connect:
    ;connect to the socket
    mov rax, 42
    mov rdi, [socket]
    mov rsi, server
    mov rdx, sockaddr_in_size ;size of server
    syscall

    cmp rax, 0  ;check if connection attempt fails
    jl .connectFail

    ;successfully connect rax ==0

    ;fork child A
    mov rax, 57
    syscall
    ;if for succes EAX>=0
    cmp eax,0
    jl .forkFail
    jne .parentCode
  
  .childAcode:
    mov rdi, [socket]
    mov rsi, 0;newfd
    mov rax, 33            ;dup2 socket number with stdin fd 0
    syscall
    mov rdi, [socket]  ;close the duplicate socket
    mov rsi, err
    call l_close

    ;run execve on assign 3
    mov rdi,assign3
    mov rsi, argv
    ;envp is at rsp+r9+2 2 counts or mov r10, 4 ;points to 000.. 5 points to envp
    mov r9, 5 ;argc, arv0, argv1, argv2, null, envp
    imul r9, 8
    add r9, rsp
    mov rdx, r9
    mov rax, 59
    syscall ;should run exeve assign3 -> cat behavior (loop)
    ;if it releases from this just exit
    jmp .exit

  .parentCode:
    ;EAX should contain child A PID
    mov dword[childA_pid], eax
    ;fork child B
    mov rax, 57
    syscall
    cmp eax,0
    jl .forkFail
    je .childBcode
                              ;EAX should contain B PID
    mov dword[childB_pid], eax;
    mov rdi, [socket]
    mov rsi, err
    call l_close

    ;wait for A to complete
    mov rax, 61
    mov edi, dword[childA_pid]
    mov rsi, wstatus
    mov rdx, 0
    mov r10, 0
    syscall         ;waits on child A
    ;when you get here A child is complete
    ;send SIGTERM signal kill to child B (15)
    mov edi, dword[childB_pid]
    mov rsi, 15 ;SIGTERM
    mov rax, 62
    syscall ;signal sent
    ;wait for childB to complete
    mov rax, 61
    mov edi, dword[childB_pid]
    mov rsi, wstatus
    mov rdx, 0
    mov r10, 0
    syscall   ;waits on childB

    jmp .exit

  .childBcode:
      mov rdi, [socket]
      mov rsi, 1;newfd
      mov rax, 33             ;dup2 socket into stdout (fd 1),
      syscall

      mov rdi, [socket]       ;close the duplicate socket
      mov rsi, err
      call l_close

                              ;run execve on assign3
      mov rdi, assign3
      mov rsi, argv
      mov r9, 5               ;argc, arv0, argv1, argv2, null, envp
      imul r9, 8
      add r9, rsp
      mov rdx, r9
      mov rax, 59
      syscall                 ;should run exeve assign3 -> cat behavior (loop)
                              ;if it releases from this just exit
      jmp .exit


  jmp .exit


  .forkFail:
    mov rdi, forkFailure
    call l_puts
    mov rdi, 3
    jmp .exit

  .connectFail:
    mov rdi, connectFailure
    call l_puts
    mov rdi, 3
    jmp .exit


  .resolveIssue:
    mov rdi, resolveError   ;point to resolve error
    call l_puts             ;print resolve error
    mov rdi, 2              ;return with exit code of 2
    jmp .exit               ;jump to exit

  .not3Args:
  mov rdi, 1                ;set exit code to 1


  .exit:
    call l_exit







section .data
  forkFailure: db 'child unable to fork', 10, 0
  connectFailure: db 'connection attempt failed',10,0
  resolveError: db 'unable to resolve host',10,0
  assign3: db './assign3',0
  argv: dq assign3, 0 ;

  server: istruc sockaddr_in
      at sockaddr_in.sin_family, dw 0
      at sockaddr_in.sin_port, dw 0
      at sockaddr_in.sin_addr, dd 0
      at sockaddr_in.sin_zero, dq 0
  iend




section .bss
socket: resb 8
wstatus: resb 4
childA_pid: resb 4
childB_pid: resb 4
err: resb 4               ;pointer to err location used in l_rand

