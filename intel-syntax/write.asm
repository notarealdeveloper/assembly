SECTION .data
msg     db      "Hey there babycakes.", 0Ah
len     equ      21

SECTION .text
global _start

_start:

mov     eax, 4      ; sys_write kernel opcode
mov     ebx, 1      ; Write to STDOUT
mov     ecx, msg    ; Where to start writing
mov     edx, len    ; How many bytes to write.
int     80h         ; Call the kernel

mov     eax, 1      ; sys_exit kernel opcode
mov     ebx, 0      ; return 0 exit status (no errors)
int     80h         ; Call the kernel
