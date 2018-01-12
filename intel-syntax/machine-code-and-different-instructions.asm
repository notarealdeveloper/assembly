; syscall macros
%define sys_write       1
%define sys_open        2
%define sys_close       3
%define sys_fork        57
%define sys_exit        60
%define sys_mkdir       83
%define sys_rmdir       84
%define sys_creat       85
%define sys_unlink      87


; variable macros
%define stdin           0
%define stdout          1
%define stderr          2
%define EXIT_SUCCESS    0

section .data

msg1:       db          "Hey there babycakes." , 0x0A, 0x00
.len:       equ         $ - msg1

msg2:       db          "And hello to you too!" , 0x0A
.len:       equ         $ - msg2

section .text
global _start
_start:

    ; rcx gets clobbered by the syscall, but we can save it either
    ; in a non-clobbered register, as in the following loop...
    ; First way:
    mov     rcx, 5
L1: mov     r9, rcx
    mov     rax, sys_write
    mov     rdi, stdout
    mov     rsi, msg1
    mov     rdx, msg1.len
    syscall
    mov     rcx, r9
    loop    L1              ; if --rcx != 0, do it again.

testyfun1:
    ; If we see the responses printed, then we got past this point.
    xor     rax, rax        ; sets rax to 0x0000000000000000 ==  0
    not     rax             ; sets rax to 0xffffffffffffffff == -1
    test    rax, rax        ; since (rax & rax) is nonzero, ZF == 0
    jz      exit            ; if rax was zero, goto exit

    cmp     rax, -1         ; is rax == -1 ?
    jne     exit            ; if not, goto exit
    cmp     rax, -1         ; compute rax - (-1), and set ZF & friends
    jnz     exit            ; if ZF is not set (i.e., rax == -1), exit

    ; ... or we can just push it when we start and pop it 
    ; when we're done, as in the following loop.
    ; Second way:
    ; First we'll set rcx to 5 in a completely absurd way
waffling_rcx_to_5:
    db      0xb9, 0x03, 0x00, 0x00, 0x00    ; machine code: mov ecx, 3
    db      0x48, 0xff, 0xc1                ; machine code: inc ecx
    db      0x80, 0xc1, 0x01                ; machine code: add cl, 1
    db      0x48, 0x83, 0xe9, 0x02          ; sub rcx, 2 (rcx=3)
    dw      0xff48, 0x80c1, 0x01c1          ; redo what we undid (rcx=5)
    dq      0x909001c180c1ff48              ; rcx += 2 (rcx=7) (w/ nops)
    dd      0x01e98348                      ; sub rcx, 1 (rcx=6)
    dq      0x909002e983489090              ; sub rcx, 2 (rcx=4)
    dq      0x01c1809090909090              ; rcx += 1 (rcx=5) (w/ nops)
    db      0x87, 0xc0                      ; xchg eax, eax  == nop

L2: push    rcx
    mov     rax, sys_write
    mov     rdi, stdout
    mov     rsi, msg2
    mov     rdx, msg2.len
    syscall
    pop     rcx
    loop    L2              ; if --rcx != 0, do it again.

testyfun2:
    ; If we exited instead of going into an infinite loop,
    ; then the test returned "non zero"
    mov     rax, 0b10101010
    test    rax, 0b01010111 ; One bit of overlap, so test returns nonzero
    jnz     exit            ; If we removed the one bit of overlap above,
    jmp     _start          ; The program would loop indefinitely.

exit:
    ; And exit cleanly
    mov     rax, sys_exit
    mov     rdi, EXIT_SUCCESS
    syscall
