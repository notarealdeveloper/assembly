# A simple reminder of how to use the new x86_64 "syscall" instruction.
# Notice, for example, that the  syscall number for "write" is now
# 1 (instead of 4), and the syscall number for "exit" is 60 (instead of 1).
# This is only for the method of making syscalls using the "syscall" instruction.
# The old int $0x80 method still uses the old syscall numbers.
#
# In the linux kernel sources, under arch/x86/include/generated
# you can find two files: syscalls_32.h and syscalls_64.h
# This is where those syscalls are defined. Here are the key lines:
#
# In syscalls_32.h
# __SYSCALL_I386(1, sys_exit, sys_exit)
# __SYSCALL_I386(4, sys_write, sys_write)
#
# In syscalls_64.h
# __SYSCALL_COMMON(1, sys_write, sys_write)
# __SYSCALL_COMMON(60, sys_exit, sys_exit)
#
# Assemble and run with: 
# F="syscall" && as -o "$F.o" "$F.s" && ld -o "$F" "$F.o" && ./"$F"
mystr:
    .string "Well hello there\n\0"

    .globl    _start

_start:
    movq    $mystr,  %rsi   # put string's address in %rdi
    call    putstr          # call putstr to print it
    call    exit            # exit cleanly

putstr:                     # putstr: prints a string
    cmpb    $0x00,  (%rsi)  # if *(rdi) != 0
    jne     onemore         # then goto onemore
    jmp     nomore          # else goto nomore
    onemore:                # to print one more character:
    call putchr             # (1) call putchr to print current char 
    incq    %rsi            # (2) advance to next char in the string
    jmp putstr              # (3) go back to the top of putstr
    nomore:                 # to be done printing characters
    ret                     # return from putstr back to caller

putchr:                     # putchr: prints a character
    movq    $1,     %rax    # syscall for write         -> %rax
    movq    $1,     %rdi    # stdout file descriptor    -> %rdi = "dst"
    movq    %rsi,   %rsi    # address of the character  -> %rsi = "src"
    movq    $1,     %rdx    # number of chars to print  -> %rdx
    syscall                 # poke the kernel in the special x86_64 way
    ret                     # return from putchr back to caller

exit:                       # exit the program
    movq    $60,    %rax    # use the exit syscall
    movq    $0,     %rdi    # exit code 0
    syscall                 # poke the kernel in the special x86_64 way
