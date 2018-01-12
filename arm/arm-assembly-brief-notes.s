# Only played around with this on the raspberry pi for a bit one day.
# Never actually done anything in ARM assembly, but it's nice to get
# some practice with something besides just x86.

    .global main
    .func main

# This is a comment
@ This is a comment
//This is a comment
/*This is a comment*/

# ARM syscall numbers defined in:
# /usr/include/asm/unistd_32.h
# /usr/include/asm/unistd_64.h

main:
   /* Stack the return address (lr) plus a dummy register (ip) to 
    * keep the stack 8-byte aligned. (I switched ip to r8)
    */
    # push     {r8, lr}         /* Note: This pushes lr *first*!!! */
    # push     {lr}             /* The above instruction == this... */
    # push     {r8}             /* ...then this. */
    push        {lr}            /* However, this is enough by itself */

    /* Print str */
    ldr     r0, =str            /* Load address of str into r0 */
    bl      printf              /* call printf (bl = "branch local") */

    /* How to make syscalls! */
    mov     r7,     #4          /* sys_write */
    mov     r0,     #1          /* stdout */
    ldr     r1,     =buf        /* r1 = buf */
    ldr     r2,     =buf.len    /* r2 = buf.len */
    swi     0

    /* Doing some arithmetic. */
    mov     r1, #6              /* r1 = 6 */
    mov     r2, #3              /* r2 = 3 */
    add     r0, r1, r2          /* r0 = r1 + r2 (r0 is now 9) */
    mul     r0, r0, r2          /* r0 = r0 * 3  (r0 is now 27) */
    mov     r6, #15
    add     r0, r0, r6          /* r0 += 15 (r0 is now 42) */

   /* Note: The r8 above and the r9 here are not important. 
    * Originally, they were both "ip," but I changed them to two random
    * other registers to make sure I understood what was going on.
    */
    # pop      {r9, pc}         /* orig r8 -> r9 & orig lr -> pc */
    # pop      {r9}             /* The above instruction == this... */
    # pop      {pc}             /* ...then this. */
    pop         {pc}            /* However, this is enough by itself */

    bx  lr                      /* "Branch and exchange." (ret) */


# The "z" suffix null terminates for us.
str:    .asciz "Hello, world\n"
buf:    .ascii "Yo babycakes\n\0"
        buf.len = . - buf
