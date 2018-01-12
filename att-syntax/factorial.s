    .globl _start
_start:
    movl    $5,     %ebx    # The number to find the factorial of
    movl    $1,     %eax    # We'll store intermediate results in %eax
    call factorial
    call exit

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
