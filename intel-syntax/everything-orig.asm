
SECTION .data
CPU X64                 ; just for fun

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
%define stdout          1
%define EXIT_SUCCESS    0
%define byte_at(reg) byte [reg]

; variables
NEWLINE:    db          0x0A
SPACE:      db          0x20

msg:        db          "Hey there babycakes" , 0x0A, 0x00
.len:       equ         $ - msg

dirname:    db          "/home/jason/Desktop/boop",     0x00
filename:   db          "/home/jason/Desktop/testfile", 0x00



SECTION .text
global _start

_start:

    ; print argv[0] and argv[1]
    call    print_first_two_args

    ; putstr msg
    mov     rax, msg
    call    putstr

    ; mkdir
    mov     rax, dirname
    call    mkdir

    ; fputs 
    mov     rax, filename
    mov     rbx, msg
    call    fputs

    ; rmdir
    mov     rax, dirname
    call    rmdir

    ; unlink
    mov     rax, filename
    call    unlink

    ; exit
    call exit


; void unlink(char *rax)
unlink:
    push    rax
    push    rdi

    mov     rdi, rax            ; directory name
    mov     rax, sys_unlink
    syscall

    pop     rdi
    pop     rax

    ret


; void fputs(char *rax, char *rbx)
; rax = filename
; rbx = string to write
fputs:
    push    rax
    push    rdi
    push    rsi
    push    rdx

    mov     r8,     rax         ; r8 = filename
    mov     r9,     rbx         ; r9 = msg
    mov     rax,    r9
    call    strlen
    mov     r10,    rax         ; r10 = string length
    dec     r10                 ; kludge for now. 

    ; open
    mov     rax,    sys_open
    mov     rdi,    r8          ; r8 = filename
    mov     rsi,    0o3101      ; open in write mode
    mov     rdx,    0o666       ; with rw- permissions for all
    syscall
    mov     r11,    rax         ; r11 = fd

    ; write
    mov     rax,    sys_write
    mov     rdi,    r11         ; rdi = fd
    mov     rsi,    r9          ; write msg to file
    mov     rdx,    r10         ; write all the bytes
    syscall

    ; close (not needed)
    mov     rax,    sys_close
    mov     rdi,    rdi
    syscall

    pop     rdx
    pop     rsi
    pop     rdi
    pop     rax

    ret



; void mkdir(char *rax)
mkdir:
    push    rax
    push    rdi
    push    rsi

    mov     rsi, 0o777      ; mode: this is 0o777
    mov     rdi, rax        ; directory name
    mov     rax, sys_mkdir  ; sys_mkdir on x86_64
    syscall

    pop     rsi
    pop     rdi
    pop     rax

    ret


; void rmdir(char *rax)
rmdir:
    push    rax
    push    rdi

    mov     rdi, rax        ; directory name
    mov     rax, sys_rmdir  ; sys_rmdir on x86_64
    syscall

    pop     rdi
    pop     rax

    ret


print_first_two_args:
    pop     rbp             ; since we call'd this instead of jmp'd to it
    pop     rbx             ; argc
    pop     rcx             ; argv + 0 (program name)
    pop     rdx             ; argv + 1 (first argument)

    cmp     rbx,    2       ; if no arguments, then
    jl      .finished       ; do nothing

    mov     rax, rcx        ; rax = argv + 0 (program name)
    call    putstr
    mov     rax,    SPACE
    call    putchar

    mov     rax, rdx        ; rax = argv + 1 (program name)
    call    putstr
    mov     rax,    NEWLINE
    call    putchar

    .finished:
    push    rdx
    push    rcx
    push    rbx
    push    rbp
    ret


; void putstr(char *rax)
putstr:
    push    rax

    .nextchar:
    cmp     byte_at(rax),   0   ; is *(rax) equal to 0?
    jz      .finished           ; if so, we're done
    call    putchar             ; else: print the character,
    inc     rax                 ; go to the next character,
    jmp     .nextchar           ; and loop again

    .finished:
    pop     rax
    ret


; void putchar(char *rax)
putchar:
    push    rax
    push    rbx
    push    rcx
    push    rdx
    push    rdi
    push    rsi

    mov     rdx, 1              ; Write one byte
    mov     rsi, rax            ; Where to start writing
    mov     rdi, stdout         ; Write to stdout
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall

    pop     rsi
    pop     rdi
    pop     rdx
    pop     rcx
    pop     rbx
    pop     rax
    ret


; rax = strlen(char *rax)
strlen:
    push    rbx
    mov     rbx, rax        ; set rbx = rax = address of our message

    .nextchar:
    cmp     byte [rax], 0   ; is *(rax) equal to 0?
    jz      .finished       ; if so, we're done
    inc     rax             ; else: up the address in rax by one byte
    jmp     .nextchar       ; and jump back up to the label nextchar

    .finished:
    sub     rax, rbx        ; rax = rax - rbx = # bytes in string
    pop     rbx
    ret                     ; return to where the function was called


exit:
    mov     rax, sys_exit
    mov     rdi, EXIT_SUCCESS
    syscall
