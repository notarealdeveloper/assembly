    .globl _start
_start:
    movl    $5,     %ebx    # The number to find the factorial of
    movl    $1,     %eax    # We'll store intermediate results in %eax
    call instructions
    call factorial
    call exit

instructions:
    # Demonstrates usage of several x86 instructions.
    # This section does nothing that affects the end result.
    cbw                         # Convert byte to word
    clc                         # Clear carry flag      CF = 0;
    cld                         # Clear direction flag  DF = 0;
    cmc                         # Complement carry flag
    nop                         # No operation
    not %edx                    # Logical not
    ret

factorial:
    cmpl    $1,     %ebx
    je      exit
    imull   %ebx,   %eax
    decl    %ebx
    jmp     factorial

exit:
    movl    %eax,   %ebx
    movl    $1,     %eax
    int     $0x80
