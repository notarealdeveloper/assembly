# How to link to the C standard library from assembly manually
# 
# F="c-stdlib-link"
# as -o "${F}.o" "${F}.s"
# ld -o "${F}" -dynamic-linker /lib/ld-linux-x86-64.so.2 /usr/lib/crt1.o /usr/lib/crti.o -lc "${F}.o" /usr/lib/crtn.o
# ./"${F}"

mystr:
    .string "Hello from the C librax\bry."
    .globl  main

main:
    movl    $mystr, %edi
    call    puts

    movl    $mystr, %edi
    incl    %edi
    call    puts

    movl    $mystr, %edi
    subl    $1,     %edi
    call    puts

    # exit syscall so we don't coredump

    movl $1, %eax   # syscall for program exit
    movl $0, %ebx   # exit status. view with echo $?
    int  $0x80      # poke the kernel
