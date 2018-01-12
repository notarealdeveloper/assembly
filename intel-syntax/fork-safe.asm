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

childmsg:       db      "This is the child process",  0x0A, 0x00
.len            equ     $ - childmsg
parentmsg:      db      "This is the parent process", 0x0A, 0x00
.len            equ     $ - parentmsg

section .text
global _start
_start:
 
    mov     r8,  stdout     ; stdout fd
    mov     rax, sys_fork   ; fork into two processes
    syscall

    cmp     rax, 0          ; if rax == 0 we are in the child process
    jz      child           ; jump if eax is zero to child label
    jmp     parent          ; not necessary, but makes things clean


parent:
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    mov     rdi, stdout         ; File descriptor
    mov     rsi, parentmsg      ; Where to start writing
    mov     rdx, parentmsg.len  ; Write the whole string
    syscall
    call    exit
 
child:
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    mov     rdi, stdout         ; File descriptor
    mov     rsi, childmsg       ; Where to start writing
    mov     rdx, childmsg.len   ; Write the whole string
    syscall
    call    exit

exit:
    mov     rax, sys_exit
    mov     rdi, EXIT_SUCCESS
    syscall
