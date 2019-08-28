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


struc sockaddr_in                               ; creat structure for connect call
  .sin_family:  resw 1                          ; 2bytes
  .sin_port:    resw 1                          ; 2bytes
  .sin_addr:    resd 1                          ; 4bytes
  .sin_zero:    resb 8                          ; 8byes
endstruc

global _start
extern resolv                                   ; set resolve to be called

section .text                                   ; main code section

l_strlen:
                                                ; String should be in reg rdi
  .begin:
     push r8                                    ; keep r8 from being changed
     xor r8, r8                                 ; zero out r8, used for
                                                ; counting
     mov al, 0                                  ; search rdi for 0.
     cld                                        ; clear direction flag
  .search:
      inc r8                                    ; inc r8 for each letter +
                                                ; null byte
      scasb                                     ; scan rdi head, inc, compare
                                                ; to al
      jne .search                               ; if not found continue scan

  .done:

      dec r8                                    ; not count the null byte
      mov rax, r8                               ; store str length in rax to
                                                ; return
      pop r8                                    ; retore r8

  ret

l_puts:
  mov rsi, rdi                                  ; assume string is already in
                                                ; rdi
  call l_strlen                                 ; put string length into rax

  mov rdx, rax                                  ; put length into rdx
  mov rdi, 1                                    ; set rdi to stdout fd
  mov rax, 1                                    ; set to write
  syscall                                       ; open stdout and write
  ret

l_close:
  ; rdi is file descriptor
  ; rsi is pointer to error
  mov dword[rsi], 0                             ; clear error location
  mov r10, rsi                                  ; put err into r10
  mov rax, 3                                    ; sys_close
  syscall
  call public.checkErr                          ; set err for r10 to call
  ret

l_exit:
  ; rdi already contains return val
  mov rax, 60                                   ; normal sys_exit code
  syscall
  

l_atoi:
  ; rdi is char* value pointer
  push rcx                                      ; save rcx
  push r10                                      ; save r10
  push r9                                       ; save r9
  push r8                                       ; save r8

  mov r9, rdi                                   ; move rdi into r9
  call l_strlen                                 ; eats rdi returns length of
                                                ; char in rax
  cmp rax, 0                                    ; check length >0
  jle .done                                     ; check length >0 else dont
                                                ; even try
  mov rcx, rax                                  ; set loop count to strlen
  dec rcx                                       ; 0th bit counts so decrement
                                                ; 1
  xor rax, rax                                  ; clear rax
  xor r8, r8                                    ; clear and use for final
                                                ; number register
  mov r10, 1                                    ; 10s register to multiply
                                                ; value

  .byteCheck:                                   ; loop for checking each byte
    xor rax, rax                                ; clear rax
    mov al, byte[r9+rcx]                        ; put first letter of buffer
                                                ; into al
    cmp al, "0"                                 ; check lower bound ascii
    jl .zeroNumb                                ; jump if less than lowerbound
                                                ; to reset regs
    cmp al, "9"                                 ; check upper bound ascii
    jg .zeroNumb                                ; jump if greater than
                                                ; upperbound to reset regs
  .number:                                      ; number after this point
    sub rax, 48                                 ; 48 makes "0" = 0 so "1"-48 =
                                                ; 1..etc
    imul rax, r10                               ; multiply rax by 10ths
                                                ; register.
    imul r10, 10                                ; multip 10ths reg to track
                                                ; current placement
    add r8, rax                                 ; add rax to our number reg

    dec rcx                                     ; decrement rcx for loop
    cmp rcx, 0                                  ; check rcx
    jge .byteCheck                              ; jumps if rcx>=0 include 0
                                                ; because it's first byte
    jmp .finish                                 ; all chars have been read, r8
                                                ; should contain val

  .zeroNumb:                                    ; zeros r8 reg when non-char
                                                ; number found
    xor r8, r8                                  ; zero z8 becueaes non char in
                                                ; the way
    mov r10, 1                                  ; set 10's reg back to 1
    dec rcx                                     ; dec rcx for loop
    cmp rcx, 0                                  ; check rcx
    jge .byteCheck                              ; back to byteCheck for next
                                                ; byte else finish if <0

  .finish:
    mov rax, r8                                 ; move final number into Rax
  .done:
    pop r8                                      ; restore 8,9,10,rcx
    pop r9
    pop r10
    pop rcx
    ret

public:                                             ; used for public helper
                                                ; functions
  .checkErr:                                    ; for checks after syscalls
                                                ; for fd functions
                                                ; assumes rax contains value
                                                ; for file descriptor
                                                ; assumes r10 contains pointer
                                                ; to int err buffer
    cmp rax, 0                                  ; checks rax is still positive
    jge .done                                   ; jump if rax is positive fd
                                                ; to return
                                                ; else set error code to abs
                                                ; value of rax
    neg rax                                     ; abs value is the negative
                                                ; of a negative number
    mov dword [r10], eax                        ; move error into r10

    mov rax, -1                                 ; set rax -1 and returns
    .done:
    ret

_start: 
                                                    ; r10 as pointer in stack
  xor r10, r10                                      ; 0:argc, 1:argv[0],
                                                    ; 2:argv[1], 3:argv[2]
  mov r9, qword[r10*8+rsp]                          ; points to first item in rsp 
                                                    ; should be argc
  cmp r9, 3                                         ; if argc not 3 then not enough 
                                                    ; args
  jne .not3Args                                     ; ensures only 3 args given

  .resolve_host_name:
    xor rax, rax                                   ; clear rax
    mov r10, 2                                     ; point to argv[1]
    mov rdi, [r10*8+rsp]                           ; input the hostname into rdi
    call resolv                                    ; clears r8, r10, changes r11
    mov r14, 0xffffffff                            ; output if resolve fails
    cmp rax, r14                                   ; checks output of resolve
                                                   ; if -1 then fails
    je .resolveIssue                               ; check if reslove fails

    mov dword[server + sockaddr_in.sin_addr], eax  ; save the ip address

  .get_port_number:
    xor rax, rax                                   ; clear rax
    mov r10, 3                                     ; r10 to argv[2] port number
    mov rdi, [r10*8+rsp]                           ; points rdi to argv[2]
    call l_atoi                                    ; convert number to int
    
    xchg  ah,al                                    ; convert port number to
                                                   ; network byte order htons
    mov word[server + sockaddr_in.sin_port], ax    ; store port number int value 
                                                   ; in struct
  .open_socket:
    mov rdi, 2                                     ; AF_INET (Family)
    mov rsi, 1                                     ; SOCK_STREAM TCP (type)
    mov rdx, 0                                     ; (protocol)
    mov rax, 41                                    ; sys_socket mode to open
    syscall                                        
                                                   ; fd in RAX check if negative
    cmp rax, 0                                     
    jl .connectFail                                ; check if connect fail <0
    mov [socket], rax                              ; store socket for later uses

    mov word[server + sockaddr_in.sin_family], 2   ; set for AF_INET family

  .connect:
                                                   ; connect to the socket
    mov rax, 42                                    ; sys_connect
    mov rdi, [socket]                              ; socket
    mov rsi, server                                ; move serever sockeraddr_in
                                                   ; struct pointer into rsi
    mov rdx, sockaddr_in_size                      ; size of server
    syscall   
    cmp rax, 0                                     ; check if connection
                                                   ; attempt fails
    jl .connectFail   
                                                   ; successfully connected rax ==0   
    mov rax, 57                                    ; Fork child A
    syscall   
                                                   ; if for succes EAX>=0   
    cmp eax,0                                      ; check if fork failed
    jl .forkFail                                   ; jump if fork failed
    jne .parentCode                                ; check if in parent or
                                                   ; child code
   
  .childAcode:   
    mov rdi, [socket]                              ; move scket number to rdi
    mov rsi, 0                                     ; use std_in fd
    mov rax, 33                                    ; sys_dup socket number
                                                   ; with stdin fd 0
    syscall   
    mov rdi, [socket]                              ; close the duplicate socket
    mov rsi, err                                   ; set err print for l_close
    call l_close                                   ; call internal close method
   
                                                   ; run execve on assign 3
    mov rdi,assign3                                ; place assign3 in file name
    mov rsi, argv                                  ; place assing3 file path
                                                   ; envp is at rsp+5*8, argc, 
                                                   ;arv0, argv1, argv2, null, envp
    mov r9, 5   
    imul r9, 8   
    add r9, rsp                                    ; envp pointed to  by r9
    mov rdx, r9                                    ; place envp pointer into rdx
    mov rax, 59                                    ; sys_execve call
    syscall                                        ; should run exeve assign3 -> 
                                                   ;cat behavior (loop)
    cmp rax,0                                      ;check for error
    jl .execIssue                                  ; jump if err with exec            
    xor rdi,rdi                                    ;clear rdi
    jmp .exit                                      ;jump to exit
   
  .parentCode:   
                                                   ; EAX should contain childA PID
    mov dword[childA_pid], eax                     ; parent save childA PID
                                                   ; fork child B
    mov rax, 57                                    ; sys_fork
    syscall   
    cmp eax,0                                      ; check if fork fails
    jl .forkFail   
    je .childBcode                                 ; not parent jump to childB code
                                                   ; EAX should contain B PID
    mov dword[childB_pid], eax                     ; parent saves childB PID
    mov rdi, [socket]                              ; parent close socket
    mov rsi, err                                   ; set err print for l_close
    call l_close                                   ; call internal close method
                                                   ; wait for A to complete
    mov rax, 61                                    ; sys_wait4
    mov edi, dword[childA_pid]                     ; pass childA's pid
    mov rsi, wstatus                               ; pointer to wstatus, not used
    mov rdx, 0                                     ; null val for options
    mov r10, 0                                     ; null val for reusage pointer
    syscall                                        ; parent waits on childA
                                                   ; childA is complete
                                                   ; send SIGTERM signal kill to 
                                                   ; child B (15)
    mov edi, dword[childB_pid]                     ; place childB pid
    mov rsi, 15                                    ; set SIGTERM val in rsi
    mov rax, 62                                    ; call sys_kill
    syscall                                        ; signal sent
                                                   ; wait for childB to complete
    mov rax, 61                                    ; sys_wait4
    mov edi, dword[childB_pid]                     ; pass childA's pid
    mov rsi, wstatus                               ; pointer to wstatus (not used)
    mov rdx, 0                                     ; null val for options
    mov r10, 0                                     ; null val for reusage pointer
    syscall                                        ; waits on childB
    xor rdi,rdi                                    ;clear rdi
    jmp .exit                                      ; jump to exit
   
  .childBcode:                                     ; same code as childA except 
                                                   ; rsi==1 for std_out
    mov rdi, [socket]                              ; move scket number to rdi
    mov rsi, 1                                     ; use std_out fd
    mov rax, 33                                    ; sys_dup2 w/ sock and fd 1 #s
    syscall   
    mov rdi, [socket]                              ; close the duplicate socket
    mov rsi, err                                   ; set err location for l_close
    call l_close                                   ; call internal close method
                                                   ; run execve on assign 3
    mov rdi,assign3                                ; place assign3 in file name
    mov rsi, argv                                  ; place assing3 file path
                                                   ; envp is at rsp+5*8, argc, 
    mov r9, 5                                      ; arv0, argv1, argv2, null, envp
    imul r9, 8   
    add r9, rsp                                    ; envp pointed to  by r9
    mov rdx, r9                                    ; place envp pointer into rdx
    mov rax, 59                                    ; sys_execve call
    syscall                                        ; should run exeve assign3(loop)
    cmp rax,0                                      ;check for error
    jl .execIssue                                  ;jump if error w/ exec
    xor rdi,rdi                                    ;clear rdi
    jmp .exit                                      ; jump to exit
   
                                                   ; All failure code with messages
  .execIssue:
    mov rdi, 69                                    ;fail w/ EX_UNAVAILABLE
    jmp .exit
  
  .forkFail:                                       ; fork failure
    mov rdi, forkFailure                           ; place fork Failure string
    call l_puts                                    ; print fork failure 
    mov rdi, 3                                     ; return with exit code 3
    jmp .exit                                      ; jump to exit
   
  .connectFail:                                    ; sys_connect failure
    mov rdi, connectFailure                        ; point to connect error
    call l_puts                                    ; print connect error
    mov rdi, 3                                     ; return with exit code 3
    jmp .exit                                      ; jump to exit
   
   
  .resolveIssue:                                   ; jmps here if resolve fails
    mov rdi, resolveError                          ; point to resolve error
    call l_puts                                    ; print resolve error
    mov rdi, 2                                     ; return with exit code of 2
    jmp .exit                                      ; jump to exit
   
  .not3Args:                                       ;jumps here if argc!=3
    mov rdi, 1                                     ; set exit code to 1


  .exit:                                           ;exit call assum rdi set
    call l_exit                                    ;prior to this jump label



section .data
  forkFailure: db 'child unable to fork', 10, 0
  connectFailure: db 'connection attempt failed',10,0
  resolveError: db 'unable to resolve host',10,0
  assign3: db './assign3',0
  argv: dq assign3, 0 ;initialized with size of 64bits like normal registers for stack allignment

  server: istruc sockaddr_in                    ;initialize memory for structure
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
err: resb 4                                     
