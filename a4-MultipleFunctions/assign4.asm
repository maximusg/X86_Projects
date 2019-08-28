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

global l_strlen
global l_strcmp
global l_gets
global l_puts
global l_write
global l_open
global l_close
global l_itoa
global l_atoi
global l_exit
global l_rand




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

l_strcmp:
  ;rdi, rsi, rcx, rdx, r8, r9, r10, and r11
  push r8                 ;keep r8 from being changed
  push r10                ;keep r10 from being changed
  push r11                ;keep r11 from being changed

                          ;first and second words in regs rdi and rsi
  mov r8, rdi             ;save first word
  call l_strlen           ;get length of first word
                          ;rax now contains length of first word
  mov r10, rax            ;length first word;
  mov rdi, rsi            ;rdi now second word
  call l_strlen           ;get length of second word
                          ;rax now contains length of second word
  cmp r10, rax            ;compare both words length
  jne .notEqual           ;jump if strings not the same

  mov rdi, r8             ;set rdi back to firstword

  xor r11, r11            ;clear r11 to compare with 0 for equal
  cld                     ;clear direction flag
  .compare:
    cmp     byte[rsi], 0  ;check for end of string (NULL byte)
    jz      .done         ;jump done if null byte found

    cmpsb                 ;compare current bytes between rsi/rdi
    jz     .compare       ;jump back to compare if equal

  .notEqual:
    mov r11, 1            ;return 1 when not equal

  .done:
  mov rax, r11            ;put checkErr into rax

  pop r11                 ;restore r11, r10, and r9
  pop r10
  pop r8

	ret

l_gets:

  push r9                 ;keep r9 from being changed
  push r10
  push rbx
                          ;rdi is file descriptor
                          ;rsi is char *buf write-to from file
                          ;rdx is length of write
  mov rbx, rdx            ;loop read-in
  cmp rdx, 0              ;ensure rdx > 0
  jle .done               ;if no bytes return zero
  dec rbx                 ;rbx loops on 0->n-1
  dec rbx                 ;count for last byte must be 0
  xor r9, r9              ;count with r9
  mov r10, rsi            ;us r10 to increment on
  mov byte[rsi], 0

  .scanlf:
    xor rax, rax          ; clear rax set for write
    mov rdx, 1            ;write 1 byte
    syscall               ;all param set up to write into rsi from fd location
    mov al, 10             ;scan for lf in buff[rdi], using al
    cmp byte[rsi], al
    ;dont inc r9
    je .found ;if equal then return
  .scan0:
    mov al, 0            ;scan for null in buff[rdi]
    cmp byte[rsi], al     ;compare for lf

    je .finish
    inc r9                ;count number of bytes until \n
    inc rsi               ;increment pointer
    dec rbx
    cmp rbx, 0
    jg .scanlf
    ;only get here after loop counter over
    ; mov byte[rsi],0


  .found:
    inc r9                ;write the /n in rsi
    inc rsi               ;don't overwrite \n
    mov byte[rsi], 0      ;write 0 into current location \n of buffer
  .finish:
    mov rax, r9           ;byte count into return
    mov rsi, r10
  .done:
    pop rbx                ;restore rbx, r10, r9
    pop r10
    pop r9

	ret

l_puts:

  mov rsi, rdi           ;assume string is already in rdi
  call l_strlen          ;put string length into rax

  mov rdx, rax            ;put length into rdx
  mov rdi, 1              ;set rdi to stdout fd
  mov rax, 1              ;set to write
  syscall                 ;open stdout and write
  ret

l_write:
                          ;rdi is file descriptor
                          ;rsi is char *buf to write from (string)
                          ;rdx is length of write
                          ;rcx is error location
  push rcx
  mov dword[rcx], 0       ;clear error location
  mov r10, rcx            ;move err location into r10
  mov rax, 1              ;set rax for sys_write mode
  syscall                 ;open file and write
  call public.checkErr    ;spits out correct rax, and pushes error
  ; pop r10                 ;restore r10
  pop rcx
	ret

l_open:
                          ;rdi is file name,
                          ;rsi is opened access mode
                          ;rdx is permissions for a file created file, if create access
                          ;rcx is error location
  mov dword[rcx], 0       ;clear error location
  push rcx                ;save rcx from being changed
  mov r10, rcx            ;move err location into r10
  mov rax,2               ;set to sys_open mode
  syscall                 ;attempt to open file, and return fd

  call public.checkErr    ;spits out correct rax, and pushes error
  pop rcx                 ;restore r10
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
    pop rcx               ;restor rcx
	  ret

l_itoa:
  push rcx                ;save rcx
                          ;rdi is a integer
                          ;rsi is buffer to hold int
  mov r8, rsi             ;buffer pointer
  xor rcx, rcx            ;will be size of number string
  mov rax, rdi            ;rax contains the number
  mov r10, 10             ;set dividend to 10

  .loopNumb:              ;loop on the rest
    cqo                   ;clears rdx and flags
    idiv r10              ;divides rax by 10
                          ;rax quotient , rdx remainder
    add rdx, 48           ;number to ascii (not error checking here) assume
                          ;c does its job typing as int
    push rdx              ;char onto stack since we are working from r to l
    inc rcx               ;increment number char count
    cmp rax, 0            ;compare rax(quotiend) to 0
    jne .loopNumb         ;if equal, we'v reached a number < 10

  .popoff:                ;pop off stack from l to r
    pop rdx               ;pop rdx
    mov [r8], dl          ;move byte out of rdx to location in buffer
    inc r8                ;inc buffer pointer
    loop .popoff          ;loop until rcx 0

  xor rdx, rdx            ;clear rdx
  mov [r8], dl            ;move last null byte into buffer
  mov rax, rsi            ;push buffer as return val

  pop rcx                 ;restor rcx
	ret

l_rand:
                          ;rdi contains upper bound of number (n-1)
  push rbx                ;save rbx
  xor rax, rax            ;clear rax
  cmp rdi,0               ;if rdi 0 then return 0
  jle .fdFail             ;jump if rdi <=0

  mov rbx, rdi            ;save upperbound in rbx
  mov rdi, randFile       ;put randFile location in rdi
  mov rsi, 0              ; O_RDONLY
  mov rdx, 0              ; mode free
  mov rcx, err            ; own 64bit err pointer
  call l_open
                          ;rax contains fd to rand file
  mov rdi, rax            ;place fd in rdi
  mov r10, rcx            ;place error file in r10
  call public.checkErr    ;handles error write and rax val
  cmp rdi,0               ;check if file descriptor >=0
  jl .fdFail              ;if fd is neg, then fail

  mov r8, rax             ;keep fd around to close
                          ;call l_gets w/ 4 bits
  mov rsi, buff           ;pass 4 byte buffer pointer
  mov rdx, 4              ;length 4 bytes
  call l_gets             ;gets 4 random bytes
                          ;buff now contains 4 random byte
                          ;close file
  mov rdi, r8             ;set rdi to r8
  mov rsi, err            ;set rsi to point to err location
  call l_close            ;close the randFile fd

  mov rax, [buff]         ;pass content of buff into rax
  cqo                     ;clears rdx
  idiv rbx                ;divides random/upperbound number
                          ;rdx now is now the remainder
  mov rax, rdx            ;move remainder into rax for return
  .fdFail:
    pop rbx               ;restor rbx

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


section .data
randFile: db `/dev/urandom`,0 ;pointer to random number generator file


section .bss
err: resb 4               ;pointer to err location used in l_rand
buff: resb 4              ;pointer to buff location used in l_rand
