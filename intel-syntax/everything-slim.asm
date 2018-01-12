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
%define byte_at(reg) byte [reg]

section .data

msg:        db          "Hey there babycakes." , 0x0A, 0x00
dirname:    db          "boop",     0x00
filename:   db          "testfile", 0x00


section .text
global _start
_start:

    ; fputs msg
    mov     r8, stdout
    mov     r9, msg
    call    fputs

    ; mkdir
    mov     r8, dirname
    call    mkdir

    ; fwrite
    mov     r8, filename
    mov     r9, msg
    call    fwrite

    ; rmdir
    mov     r8, dirname
    call    rmdir

    ; unlink
    mov     r8, filename
    call    unlink

    ; exit
    call exit


; void rmdir(char *dirname)
rmdir:
    mov     rdi, r8             ; directory name
    mov     rax, sys_rmdir      ; sys_rmdir on x86_64
    syscall
    ret


; void unlink(char *r8)
unlink:
    mov     rdi, r8             ; file name
    mov     rax, sys_unlink
    syscall
    ret


; void mkdir(char *dirname)
mkdir:
    mov     rsi, 0o777          ; mode: this is 0o777
    mov     rdi, r8             ; directory name
    mov     rax, sys_mkdir      ; sys_mkdir on x86_64
    syscall
    ret


; void fputs(char *filename, char *msg)
fwrite:
    push    r8

    ; open
    mov     rax,    sys_open
    mov     rdi,    r8          ; r8 = filename
    mov     rsi,    0o3101      ; open in write mode
    mov     rdx,    0o666       ; with rw- permissions for all
    syscall

    ; write
    mov     r8,     rax
    call    fputs

    pop     r8
    ret


; void fputs(int fd, char *msg)
fputs:
    push    r9

    .nextchar:
    cmp     byte_at(r9),   0    ; is *(rax) equal to 0?
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
