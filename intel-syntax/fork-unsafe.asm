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

childmsg:        db      "This is the child process",  0x0A, 0x00
parentmsg:       db      "This is the parent process", 0x0A, 0x00


section .text
global _start
_start:
 
    mov     r8,  stdout         ; stdout fd
    mov     rax, sys_fork       ; invoke SYS_FORK (kernel opcode 2)
    syscall

    cmp     rax, 0              ; if eax is zero we are in the child process
    jz      child               ; jump if eax is zero to child label
    jmp     parent              ; not necessary, but makes things clean


parent:
    mov     r9,  parentmsg
    call    fputs
    call    exit
 
child:
    mov     r9,  childmsg
    call    fputs
    call    exit

fputs:
    push    r9

    .nextchar:
    cmp     byte [r9],   0      ; is *(rax) equal to 0?
    jz      .finished           ; if so, we're done
    call    fputc               ; else: print the character,
    inc     r9                  ; go to the next character,
    jmp     .nextchar           ; and loop again

    .finished:
    pop     r9
    ret

; void fputc(int fd, char *msg)
fputc:
    mov     rdx, 1              ; Write one byte
    mov     rsi, r9             ; Where to start writing
    mov     rdi, r8             ; File descriptor
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall
    ret

exit:
    mov     rax, sys_exit
    mov     rdi, EXIT_SUCCESS
    syscall
