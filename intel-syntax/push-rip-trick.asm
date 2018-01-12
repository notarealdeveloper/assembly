;-----------------------;
; My calling convention ;
;-----------------------;
; The registers rax, rdi, rsi, rdx are used entirely for syscalls.
; They are never guaranteed to be saved after calling a function.
; However, functions always return registers r8 through r16 unchanged.


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
section .text
global _start
_start:

    ; print msg
    call    L1                  ; Trick to push rip+1
M1: db      "Hello!", 0x0A      ; 0x00 not needed
    .len:   equ         $ - M1  ; message length
L1: pop     rsi                 ; rsi = M1
    mov     rax,        1       ; sys_write
    mov     rdi,        1       ; stdout
    mov     rdx,        M1.len  ; write the whole string
    syscall

    jmp _start

    ; exit
    mov     rax, 60             ; sys_exit
    mov     rdi, 0              ; EXIT_SUCCESS
    syscall
