
SECTION .data
CPU X64                 ; just for fun

; macros
%define sys_write       1
%define stdout          1
%define EXIT_SUCCESS    0
%define byte_at(reg) byte [reg]

; variables
msg:        db          "Hey there babycockles!" , 0x0A, 0x00
.len:       equ         $ - msg

sys_exit    dq          60


SECTION .text
global _start

_start:
    ; putstr msg
    mov     rax, msg
    call    putstr

    ; putstr2 msg
    mov     rax, msg
    call    putstr2

    ; putstr3 msg
    mov     rax, msg
    call    putstr3

    ; exit
    call exit


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


; void putstr2(char *rax)
putstr2:
    push    rax
    push    rdi
    push    rsi
    push    rdx

    mov     rcx, rax            ; rcx = msg
    call    strlen              ; rax = strlength

    mov     rdx, rax            ; rdx = strlength
    mov     rsi, rcx            ; rsi = msg
    mov     rdi, stdout         ; Write to stdout
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall

    pop     rdx
    pop     rsi
    pop     rdi
    pop     rax
    ret


; void putstr3(char *rax)
putstr3:
    push    rax
    push    rdi
    push    rsi
    push    rdx

    mov     rdx, msg.len        ; rdx = strlength
    mov     rsi, rax            ; rsi = msg
    mov     rdi, stdout         ; Write to stdout
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall

    pop     rdx
    pop     rsi
    pop     rdi
    pop     rax
    ret


; void putchar(char *rax)
putchar:
    push    rax
    push    rdi
    push    rsi
    push    rdx

    mov     rdx, 1              ; Write one byte
    mov     rsi, rax            ; Where to start writing
    mov     rdi, stdout         ; Write to stdout
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall

    pop     rdx
    pop     rsi
    pop     rdi
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
    mov     rax, [sys_exit]
    mov     rdi, EXIT_SUCCESS
    syscall
