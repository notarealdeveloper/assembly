# assemble, run, and echo exit status using:
# f=endian-2 && gcc -o $f $f.s && ./$f; echo $?
# this returns 60, as expected, since 60 = 0b00111100

    .globl _start
_start:
    movl    $0,     %ebx                # Clear %ebx
    push    $0b10000000000111100        # Push 0b10000000000111100
    popw    %dx                         # Pop 16 of them (can't do 8)
    movb    %dl,    %bl                 # Move lower 8 bits into %ebx

    movl    $1,     %eax                # Exit opcode -> %eax
    int     $0x80                       # Attention kernel! Do stuff!
