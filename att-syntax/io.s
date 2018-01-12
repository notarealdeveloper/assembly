# Reminders of how to do some basic I/O using the raw syscalls

mystr: .string "Hello there\n\0"
fname: .string "myfile\0"
.globl    main

main:
    movq    $mystr, %rsi    # put string's address in %rdi
    call    openfile        # open a new file to write into
    call    putstr          # call putstr to print it
    call    exit            # exit cleanly

openfile:                   # openfile: opens a file (create if !exist)
    movq    $5,     %rax    # syscall for open          -> %rax
    movq    $fname, %rbx    # pointer to filename       -> %rbx
    movq    $03101, %rcx    # open file in write mode   -> %rcx
    movq    $0666,  %rdx    # file permissions          -> %rdx
    int     $0x80           # poke the kernel
    movq    %rax,   %rdi    # move new file descriptor into %rdi
    ret                     # return from openfile back to caller

putchr:                     # putchr: prints a character
    movq    $4,     %rax    # syscall for write         -> %rax
    movq    %rdi,   %rbx    # file descriptor           -> %rbx
    movq    %rsi,   %rcx    # address of the character  -> %rcx
    movq    $1,     %rdx    # number of chars to print  -> %rdx
    int     $0x80           # poke the kernel
    ret                     # return from putchr back to caller

putstr:                     # putstr: prints a string
    cmpb    $0x00,  (%rsi)  # if *(rsi) != 0
    jne     onemore         # then goto onemore
    jmp     nomore          # else goto nomore
    onemore:                # to print one more character:
    call putchr             # (1) call putchr to print current char 
    incq    %rsi            # (2) advance to next char in the string
    jmp putstr              # (3) go back to the top of putstr
    nomore:                 # to be done printing characters
    ret                     # return from putstr back to caller

exit:                       # exit the program
    movq    $1,     %rax    # syscall for exit
    movq    $0,     %rbx    # exit code 0
    int     $0x80           # poke the kernel
