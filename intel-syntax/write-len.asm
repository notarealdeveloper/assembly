SECTION .data
msg     db      "Hey there babycakes.", 0Ah

SECTION .text
global _start

_start:
mov     ebx, msg        ; mov address of our message into ebx
mov     eax, ebx        ; mov address of our message into eax

nextchar:
cmp     byte [eax], 0   ; is the byte at MEM[eax] equal to 0?
jz      finished        ; if so: jump to the label "finished"
inc     eax             ; else: up the address in EAX by one byte
jmp     nextchar        ; and jump back up to the label nextchar

finished:
sub     eax, ebx        ; eax = eax - ebx = # bytes in string
mov     edx, eax        ; now edx = # bytes in string
mov     ecx, msg        ; Where to start writing
mov     ebx, 1          ; Write to STDOUT
mov     eax, 4          ; sys_write kernel opcode
int     80h             ; Call the kernel

mov     ebx, 0          ; return 0 exit status (no errors)
mov     eax, 1          ; sys_exit kernel opcode
int     80h             ; Call the kernel

