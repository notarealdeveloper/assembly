; Both of these assemble without any error messages.
;
; As a result of (a) this, and (b) my own stupidity,
; I spent a fucking long time trying to get hardware
; interrupts working in protected mode, because I was
; using the first version to try to program the PIC...

%macro outb_A 2
    mov dx, %0  ; %0 = port (WRONG!)
    mov al, %1  ; %1 = byte (WRONG!)
    out dx, al
%endmacro

%macro outb_B 2
    mov dx, %1  ; %1 = port
    mov al, %2  ; %2 = byte
    out dx, al
%endmacro


global _start
_start:

outb_A    0x10, 0x20
outb_B    0x10, 0x20
