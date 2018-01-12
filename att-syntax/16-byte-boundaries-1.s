# The two files 16-byte-boundaries-{1,2}.s are partners.
# What these programs do is unimportant. Both just return 255, as expected.
# They just exist to illustrate a funny property of the assembler.
# 
# This program should be assembled and run with
# F=16-byte-boundaries-1 && gcc -o $F $F.s && ./$F; echo $?
# Do the same for its partner file.
# 
# Then run objdump -d $F, for both, and look at the "<main>:" section.
# 
# Notice that the "<main>:" section in the slightly longer program
# includes just enough nop instuctions to make the function "<main>:"
# end on 16 byte boundaries, in both cases. In the longer function,
# there are more such instructions, but the goal seems to be the same.

    .globl _start
_start:
    movl    $0,     %ebx                # Clear %ebx
    push    $-1                         # Push 64 1s. push $-1 gives same
    popw    %dx                         # Pop 16 of them (can't do 8)
    movb    %dl,    %bl                 # Move lower 8 bits into %ebx

    movl    $1,     %eax                # Exit opcode -> %eax
    int     $0x80                       # Attention kernel! Do stuff!
