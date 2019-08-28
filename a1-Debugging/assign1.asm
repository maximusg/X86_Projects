bits 64

global _start

section .text   

w0:
   mov eax, 1
   syscall
   ret

rrf0:
        mov     eax, 48
        ret


rrf1:
        mov     eax, 49
        ret


rrf2:
        mov     eax, 50
        ret


rrf3:
        mov     eax, 51
        ret


rrf4:
        mov     eax, 52
        ret


rrf5:
        mov     eax, 53
        ret


rrf6:
        mov     eax, 54
        ret


rrf7:
        mov     eax, 55
        ret


rrf8:
        mov     eax, 56
        ret


rrf9:
        mov     eax, 57
        ret


rrfcl:
        mov     eax, 58
        ret


rrfscl:
        mov     eax, 59
        ret


rrflt:
        mov     eax, 60
        ret


rrfeq:
        mov     eax, 61
        ret


rrfgt:
        mov     eax, 62
        ret


rrfqm:
        mov     eax, 63
        ret


rrfat:
        mov     eax, 64
        ret


rrfA:
        mov     eax, 65
        ret


rrfB:
        mov     eax, 66
        ret


rrfC:
        mov     eax, 67
        ret


rrfD:
        mov     eax, 68
        ret


rrfE:
        mov     eax, 69
        ret


rrfF:
        mov     eax, 70
        ret


rrfG:
        mov     eax, 71
        ret


rr0xf:
        mov     eax, 72
        ret


rrfI:
        mov     eax, 73
        ret


rrfJ:
        mov     eax, 74
        ret


rrfK:
        mov     eax, 75
        ret


rrfL:
        mov     eax, 76
        ret


rrfM:
        mov     eax, 77
        ret


rrfN:
        mov     eax, 78
        ret


rrfO:
        mov     eax, 79
        ret


rrfP:
        mov     eax, 80
        ret


rrfQ:
        mov     eax, 81
        ret


rrfR:
        mov     eax, 82
        ret


rrfS:
        mov     eax, 83
        ret


rrfT:
        mov     eax, 84
        ret


rrfU:
        mov     eax, 85
        ret


rrfV:
        mov     eax, 86
        ret


rrfW:
        mov     eax, 87
        ret


rrfX:
        mov     eax, 88
        ret


rrfY:
        mov     eax, 89
        ret


rrfZ:
        mov     eax, 90
        ret


rrflb:
        mov     eax, 91
        ret


rrfbs:
        mov     eax, 92
        ret


rrfrb:
        mov     eax, 93
        ret


rrfct:
        mov     eax, 94
        ret


rrfus:
        mov     eax, 95
        ret


rrftl:
        mov     eax, 96
        ret


rrfa:
        mov     eax, 97
        ret


rrfb:
        mov     eax, 98
        ret


rrfc:
        mov     eax, 99
        ret


rrfd:
        mov     eax, 100
        ret


rrfe:
        mov     eax, 101
        ret


rrff:
        mov     eax, 102
        ret


rrfg:
        mov     eax, 103
        ret


rrfh:
        mov     eax, 104
        ret


rrfi:
        mov     eax, 105
        ret


rrfj:
        mov     eax, 106
        ret


rrfk:
        mov     eax, 107
        ret


rrfl:
        mov     eax, 108
        ret


rrfm:
        mov     eax, 109
        ret


rrfn:
        mov     eax, 110
        ret


rrfo:
        mov     eax, 111
        ret


rrfp:
        mov     eax, 112
        ret


rrfq:
        mov     eax, 113
        ret


rrfr:
        mov     eax, 114
        ret


rrfs:
        mov     eax, 115
        ret


rrft:
        mov     eax, 116
        ret


rrfu:
        mov     eax, 117
        ret


rrfv:
        mov     eax, 118
        ret


rrfw:
        mov     eax, 119
        ret


rrfx:
        mov     eax, 120
        ret


rrfy:
        mov     eax, 121
        ret


rrfz:
        mov     eax, 122
        ret


rrflcb:
        mov     eax, 123
        ret


rrfst:
        mov     eax, 124
        ret


rrfrcb:
        mov     eax, 125
        ret


rrf00:
        mov     eax, 0
        ret


add:
        movsx   ecx, byte [rsp+0x4]
        sub     ecx, 48
        add     ecx, dword [rsp+0x8]
        mov     edx, 3524075731
        mov     eax, ecx
        imul    edx
        add     edx, ecx
        sar     edx, 6
        mov     eax, ecx
        sar     eax, 31
        sub     edx, eax
        imul    edx, edx, 78
        sub     ecx, edx
        lea     eax, [ecx+0x30]
        ret


sub:
        movsx   ecx, dil
        sub     ecx, 48
        sub     ecx, esi
        mov     edx, 3524075731
        mov     eax, ecx
        imul    edx
        add     edx, ecx
        sar     edx, 6
        mov     eax, ecx
        sar     eax, 31
        sub     edx, eax
        imul    edx, edx, 78
        sub     ecx, edx
        mov     edx, ecx
        lea     ecx, [ecx+0x7E]
        lea     eax, [edx+0x30]
        test    edx, edx
        cmovs   eax, ecx
        ret


xor:
        movsx   ecx, byte dil
        sub     ecx, 48
        mov     eax, esi
        and     eax, 0x07
        xor     ecx, eax
        mov     edx, 3524075731
        mov     eax, ecx
        imul    edx
        add     edx, ecx
        sar     edx, 6
        mov     eax, ecx
        sar     eax, 31
        sub     edx, eax
        imul    edx, edx, 78
        sub     ecx, edx
        lea     eax, [ecx+0x30]
        ret

rci:
   xor rax, rax
.L1:
   mov [rdi + rax], al
   inc al
   jnz .L1
   mov word [rdi + 0x100], 0
   
   mov r10, rdx
   xor r9, r9
   xor r8, r8
.L2:
   add r8b, [rdi + r9]
   mov rax, r9
   cqo
   div r10
   add r8b, [rsi + rdx]
   mov al, [rdi + r8]
   mov cl, [rdi + r9]
   mov [rdi + r8], cl
   mov [rdi + r9], al
   inc r9b
   jnz .L2
   ret

xeh:
   push rbp
   mov rbp, rsp
   test rsi, rsi
   jz .L0
   mov r10, rsi
   shl rsi, 3
   sub rsp, rsi
   mov rsi, rdi
   mov rdi, rsp
.L1:
   lodsb
   mov cl, al
   shr cl, 4
   add cl, 0x61
   and al, 0xf
   add al, 0x41
   stosb
   mov al, cl
   stosb
   dec r10
   jnz .L1
   sub rdi, rsp
   mov rdx, rdi
   mov rsi, rsp
   mov edi, 1
   mov eax, 1
   syscall      
.L0:
   mov rsp, rbp
   pop rbp
   ret
   

rcs:
   movzx rcx, word [rdi + 0x100]
   inc cl
   movzx rax, cl
   add ch, [rdi + rax]
   mov [rdi + 0x100], cx
   shr rcx, 8
   mov dl, [rdi + rax]
   mov dh, [rdi + rcx]
   mov [rdi + rax], dh
   mov [rdi + rcx], dl
   add dl, dh
   movzx rdx, dl
   movzx rax, byte [rdi + rdx]
   ret

rcc:
   test rcx, rcx
   jz .done
   mov r10, rdx
   mov r8, rcx
.L1:
   call rcs
   xor al, [rsi]
   mov [r10], al
   inc rsi
   inc r10
   dec r8
   jnz .L1
.done:
   ret

hello:
   mov r8, rdi
   mov r9, rsi
   mov rsi, msg
   mov edi, 1
   mov rdx, msg_len
   mov eax, 1
   syscall
   mov rdx, r9
   mov rsi, r8
   mov edi, 0
   mov eax, 0
   syscall
   ret

_start:
        mov     rbp, rsp
        sub     rsp, 128
        mov     rsi, 16
        mov     rdi, rsp
        call    hello
        lea rdx, [rsp - 1]
L1:
        inc     rdx
        mov     al, [rdx]
Q1:
        cmp     al, 10
        jz      .L0
        test    al, al
        jnz     L1
.L0:
        mov     byte [rdx], 0
        sub     rdx, rsp
        mov     r15, rdx
        mov     rsi, rsp
        mov     rdi, rctxs
        call    rci
        mov     rcx, r15
        mov     rdx, rsp
        mov     rsi, rsp
        mov     rdi, rctxs
        call    rcc
Q2:
        mov     esi, 29
        mov     edi, 120
        call    sub
        movsx   ecx, al
        add     ecx, 8
        mov     ebx, 3524075731
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
Q3:
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        movsx   ecx, cl
        sub     ecx, 5
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x44], cl
        mov     byte [rbp-0x42], 105
        mov     esi, 28
        mov     edi, 57
        call    sub
        mov     esi, 56
        movsx   ecx, al
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        mov     eax, ecx
        add     eax, 48
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     byte [rbp-0x40], al
        mov     esi, 32
        mov     esi, 115
        call    sub
        mov     esi, 50
        movsx   eax, al
        mov     edi, eax
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x3E], cl
        mov     byte [rbp-0x3C], 67
        mov     esi, 26
        mov     edi, 81
        call    sub
        movsx   ecx, al
        sub     ecx, 19
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x3A], cl
        mov     byte [rbp-0x38], 70
        mov     byte [rbp-0x36], 123
        mov     esi, 46
        mov     edi, 95
        call    sub
        mov     byte [rbp-0x34], al
        mov     byte [rbp-0x32], 95
        mov     esi, 45
        mov     edi, 87
        call    sub
        mov     esi, 21
        movsx   eax, al
        sub     eax, 48
        xor     eax, 0x05
        mov     ecx, eax
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        mov     eax, ecx
        add     eax, 48
        movsx   eax, al
        mov    edi, eax
        call    sub
        mov     byte [rbp-0x30], al
        mov     esi, 53
        mov     edi, 125
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        xor     ecx, 0x06
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        movsx   ecx, cl
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x2E], cl
        mov     byte [rbp-0x2C], 112
        mov     byte [rbp-0x2A], 51
        mov     esi, 29
        mov     edi, 124
        call    sub
        mov     byte [rbp-0x28], al
        mov     byte [rbp-0x26], 121
        mov     rcx, r15
        mov     rdx, rsp
        mov     rsi, rsp
        mov     rdi, rctxs
        call    rcc
Q4:
        mov     esi, 39
        mov     edi, 84
        call    sub
        mov     esi, 22
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     esi, 53
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     byte [rbp-0x24], al
        mov     byte [rbp-0x22], 117
        mov     esi, 23
        mov     edi, 94
        call    sub
        mov     esi, 53
        movsx   eax, al
        sub     eax, 48
        xor     eax, 0x01
        mov     ecx, eax
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        mov     eax, ecx
        add     eax, 48
        movsx   eax, al
        mov    edi, eax
        call    sub
        mov     byte [rbp-0x20], al
        mov     esi, 50
        mov     edi, 71
        call    sub
        mov     byte [rbp-0x1E], al
        mov     esi, 54
        mov     edi, 95
        call    sub
        mov     esi, 29
        movsx   eax, al
        mov     edi, eax
        call    sub
        movsx   ecx, al
        sub     ecx, 12
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x1C], cl
        mov     byte [rbp-0x1A], 109
        mov     byte [rbp-0x43], 80
        mov     byte [rbp-0x41], 49
        mov     esi, 25
        mov     edi, 77
        call    sub
        mov     esi, 21
        movsx   eax, al
        mov     edi, eax
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        xor     ecx, 0x01
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x3F], cl
        mov     esi, 50
        mov     edi, 61
        call    sub
        mov     esi, 43
        movsx   eax, al
        sub     eax, 48
        xor     eax, 0x07
        mov     ecx, eax
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        mov     eax, ecx
        add     eax, 48
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     byte [rbp-0x3D], al
        mov     esi, 31
        mov     edi, 107
        call    sub
        mov     esi, 54
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     byte [rbp-0x3B], al
        mov     byte [rbp-0x39], 95
        mov     esi, 36
        mov     edi, 73
        call    sub
        mov     esi, 20
        movsx   eax, al
        mov     edi, eax
        call    sub
        movsx   ecx, al
        sub     ecx, 27
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x37], cl
        mov     byte [rbp-0x35], 72
        mov     byte [rbp-0x33], 49
        mov     esi, 44
        mov     edi, 123
        call    sub
        mov     esi, 44
        movsx   eax, al
        lea     ecx, [eax-0x1E]
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        mov     eax, ecx
        add     eax, 48
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     byte [rbp-0x31], al
        mov     esi, 45
        mov     edi, 114
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        xor     ecx, 0x04
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        movsx   ecx, cl
        sub     ecx, 18
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x2F], cl
        mov     byte [rbp-0x2D], 51
        mov     esi, 24
        mov     edi, 96
        call    sub
        movsx   ecx, al
        add     ecx, 8
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x2B], cl
        mov     esi, 24
        mov     edi, 101
        call    sub
        movsx   ecx, al
        add     ecx, 1
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x29], cl
        mov     rcx, r15
        mov     rdx, rsp
        mov     rsi, rsp
        mov     rdi, rctxs
        call    rcc
Q5:
        mov     esi, 18
        mov     edi, 92
        call    sub
        mov     esi, 44
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     esi, 55
        movsx   eax, al
        mov     edi, eax
        call    sub
        mov     byte [rbp-0x27], al
        xor     rdx, rdx
        xor     rsi, rsi
        xor     rdi, rdi
        mov     eax, 59
        syscall
Q6:
        mov     esi, 53
        mov     edi, 112
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        xor     ecx, 0x03
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x25], cl
        mov     esi, 41
        mov     edi, 53
        call    sub
        mov     esi, 35
        movsx   eax, al
        mov     edi, eax
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        xor     ecx, 0x02
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x23], cl
        mov     byte [rbp-0x21], 56
        mov     esi, 35
        mov     edi, 117
        call    sub
        movsx   ecx, al
        sub     ecx, 48
        xor     ecx, 0x02
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        movsx   ecx, cl
        add     ecx, 5
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x1F], cl
        mov     byte [rbp-0x1D], 50
        mov     byte [rbp-0x1B], 57
        mov     esi, 54
        mov     edi, 114
        call    sub
        movsx   ecx, al
        sub     ecx, 10
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        movsx   ecx, cl
        sub     ecx, 21
        mov     eax, ecx
        imul    ebx
        lea     eax, [edx+ecx]
        sar     eax, 6
        mov     edx, ecx
        sar     edx, 31
        sub     eax, edx
        imul    eax, eax, 78
        sub     ecx, eax
        add     ecx, 48
        mov     byte [rbp-0x19], cl
        lea     rbx, [rbp-0x44]
        lea     r12, [rbp-0x18]
L_001:  mov     rdx, 1
        mov     rsi, rbx
        mov     edi, 1
        call    w0
        add     rbx, 2
        cmp     r12, rbx
        jnz     L_001
        lea     rbx, [rbp-0x43]
        lea     r12, [rbp-0x17]
L_002:  mov     rdx, 1
        mov     rsi, rbx
        mov     edi, 1
        call    w0
        add     rbx, 2
        cmp     r12, rbx
        jnz     L_002
        push    byte 10
        mov     rsi, rsp
        mov     rdx, 1
        mov     edi, 1
        mov     eax, 1
        syscall
        add rsp, 8
        mov     rdi, rsp
        mov     rsi, r15
        call    xeh
        push    byte 10
        mov     rsi, rsp
        mov     rdx, 1
        mov     edi, 1
        mov     eax, 1
        syscall
        add rsp, 8
        mov     ebx, 0        
        mov     eax, 60
Q7:
        syscall

section .data

rctxs: times 256 db 0
rctxi: db 0
rctxj: db 0

msg: db `Please enter your NPS user name: `
msg_len equ $-msg
