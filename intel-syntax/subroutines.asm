; To compile and link:
; F=subroutines; 
; nasm -f elf -o $F.o $F.asm && ld -m elf_i386 -o $F $F.o && ./$F

SECTION .data
msg     db      "Hey there babycakes.", 0Ah

SECTION .text
global _start

_start:
mov     eax, msg        ; mov address of our message into eax
call    strlen          ; call our function to calculate the length

mov     edx, eax        ; now edx = # bytes in string
mov     ecx, msg        ; Where to start writing
mov     ebx, 1          ; Write to STDOUT
mov     eax, 4          ; sys_write kernel opcode
int     80h             ; Call the kernel

mov     ebx, 0          ; return 0 exit status (no errors)
mov     eax, 1          ; sys_exit kernel opcode
int     80h             ; Call the kernel

strlen:
push    ebx             ; push ebx onto the stack to save it for later
mov     ebx, eax        ; set ebx = eax = address of our message

nextchar:
cmp     byte [eax], 0   ; is the byte at MEM[eax] equal to 0?
jz      finished        ; if so: jump to the label "finished"
inc     eax             ; else: up the address in EAX by one byte
jmp     nextchar        ; and jump back up to the label nextchar

finished:
sub     eax, ebx        ; eax = eax - ebx = # bytes in string
pop     ebx             ; pop the value on the stack back into ebx
ret                     ; return to where the function was called

