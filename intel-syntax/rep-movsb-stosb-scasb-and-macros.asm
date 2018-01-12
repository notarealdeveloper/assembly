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
%define byte_at(reg)    byte [reg]
%define jmovb           mov byte


%macro reg_eq_strlen 2
    ; Usage: reg_eq_strlen reg, str
    ; Computing the length of a nul-terminated string using repne scasb
    ; Inputs: rdi = string address, al = byte to search for
    ; Output: rcx = length of the string in rdi
    ; Clobbered: reg, rcx
    push    rax
    push    rdi
    mov     rdi, %2     ; Put starting address in di
    mov     al,  0x00   ; Put byte to search for in al
    mov     rcx, -1     ; Start count at 0xffff
    cld                 ; Clear direction flag (increment di each time)
    repne   scasb       ; Scan string for NUL, doing --cx for each char
    add     rcx, 2      ; cx will be -2 for length 0, -3 for length 1...
    neg     rcx         ; cx is now -(strlen), so negate it.
    pop     rdi
    pop     rax
    mov     %1, rcx
%endmacro

%macro print 1
    reg_eq_strlen rdx, %1
    mov     rsi,  %1
    mov     rdi, stdout
    mov     rax, sys_write
    syscall
%endmacro


section .data
hey:        db          "AAAAAAAAAAAAAAAAAAAAAA" , 0x0A, 0x00
msg:        db          "Hey there babycorkles!" , 0x0A, 0x00 ; give it a nonsense petname
.len:       equ         $ - msg                               ; this lets us refer to msg.len


section .bss
buf:        resb        64                                    ; reserve 64 bytes of uninitialized data 

section .text
global _start
_start:

    ; The REP prefixes apply only to one string instruction at a time.
    ; To repeat a block of instructions, use the LOOP instruction or
    ; another looping construct.

    ; using instructions of the form rep <string-operation>
    ; rep movsb: move (e)cx bytes from [(e)si] to es:[(e)di]
    mov     rdi,    msg
    mov     rsi,    hey
    mov     rcx,    10
    rep     movsb

    ; rep stosb: fill (e)cx bytes at es:[(e)di] with al
    mov     rdi,    msg
    mov     al,     "B"
    mov     rcx,    9
    rep     stosb

    ; repne scasb: find al, starting at es:[(e)di]
    ; Here we find the first "o" and replace it with "@"

    ; Find "o"
    cld                 ; Ensure direction flag is 0, (rdi++ each time)
    mov     rdi, msg    ; Put starting address in di
    mov     al, "o"     ; Put byte to search for in al
    mov     cx, -1      ; Start count at 0xffff
    repne   scasb       ; Scan string for al, doing --cx for each char
    add     cx, 2       ; cx will be -2 for char at index 0, -3 for 1 ...
    neg     cx          ; cx is now -(character index), so negate it.

    ; Just to illustrate all the awesomeness of NASM's address syntax

    ; (1) Replace o with @
    mov     byte [msg+rcx],     "@"

    ; (2) Make the "l" uppercase without typing "L" (Do: char -= 0x20)
    sub     [msg+rcx+3], byte 0x20

    ; (3) Make the "e" uppercase without typing "E" (Do: char += -0x20)
    ; Also: Just generally being an asshole ;-)
    add     [msg+rcx+(1<<63>>61)], byte -(1<<8>>2>>2<<1)

    ; (4) Turn the s into a $
    mov     [2*msg-msg+3*rcx-2*rcx+10/2], byte ("$"*3-"$"*2)*2/2+5-4-1


    ; Using the loop instructions
    ; ;;;;;;;;;;;;;;;;;;;;;;;;;;;
    ; Note: The operand of loop must be in the range from 128 bytes 
    ; before the instruction to 127 bytes ahead of the instruction.

    ; loopnz <label>: if rcx != 0, goto label, else proceed.
    mov     rcx, 3
    loop_nz:
    mov     [msg+rcx+4], byte "C"
    loopnz   loop_nz

    ; loopnz <label>: if rcx != 0, goto label, else proceed.
    mov     rcx, 3
    loop:
    mov     [msg+rcx+2], byte "D"
    loopnz   loop

    ; print the heavily modified string
    call    fputs

    ; much cooler way, using a macro!
    print   msg

    ; exit
    call exit

fputs:
    mov     rdx, msg.len        ; Write msg.len bytes
    mov     rsi, msg            ; Where to start writing
    mov     rdi, stdout         ; File descriptor
    mov     rax, sys_write      ; sys_write kernel opcode in x86_64
    syscall
    ret


exit:
    mov     rax, sys_exit
    mov     rdi, EXIT_SUCCESS
    syscall

