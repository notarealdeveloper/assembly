mystr:
    .string "This is not a string.\n\0"

    .globl    _start

_start:
    movq    $mystr,  %rdi   # put string's address in %rdi
    call    putstr          # call putstr to print it
    call    exit            # exit cleanly

putstr:                     # putstr: prints a string
    cmpb    $0x00,  (%rdi)  # if *(rdi) != 0
    jne     onemore         # then goto onemore
    jmp     nomore          # else goto nomore
    onemore:                # to print one more character:
    call putchr             # (1) call putchr to print current char 
    incq    %rdi            # (2) advance to next char in the string
    jmp putstr              # (3) go back to the top of putstr
    nomore:                 # to be done printing characters
    ret                     # return from putstr back to caller

putchr:                     # putchr: prints a character
    movq    $4,     %rax    # syscall for write         -> %rax
    movq    $1,     %rbx    # stdout file descriptor    -> %rbx
    movq    %rdi,   %rcx    # address of the character  -> %rcx
    movq    $1,     %rdx    # number of chars to print  -> %rdx
    int     $0x80           # poke the kernel
    ret                     # return from putchr back to caller

exit:                       # exit the program
    movq    $1,     %rax    # syscall for exit
    int     $0x80           # poke the kernel
