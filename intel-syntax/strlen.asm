SECTION .data
msg     db      "Hey beep boop", 0x0A, "And hello to you too!", 0x0A

SECTION .text
global _start

_start:
    mov     ebx, msg        ; ebx = address of msg
    mov     eax, ebx        ; eax = ebx = address of msg's first character

nextchar:
    cmp     byte [eax], 0   ; if [eax] == \0
    jz      finished        ; then goto finished
    inc     eax             ; move pointer to next character
    jmp     nextchar        ; jump back to nextchar

finished:
    sub     eax, ebx        ; eax = eax - ebx, so now eax = len(msg)
    mov     edx, eax        ; edx = eax = len(msg)
    mov     ecx, msg        ; ecx = address of msg's first character
    mov     ebx, 1          ; ebx = stdout file descriptor
    mov     eax, 4          ; eax = kernel opcode for SYS_WRITE syscall
    int     0x80            ; hey kernel, do stuff!

    mov     ebx, 0          ; exit code 0
    mov     eax, 1          ; eax = kernel opcode for SYS_EXIT syscall
    int     0x80
