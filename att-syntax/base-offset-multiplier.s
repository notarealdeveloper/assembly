# Just some notes to self about how AT&T syntax works
# 
# %edi - Holds the index of the data item being examined
# %ebx - Largest data item found
# %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used to terminate the data

.section .data

# This is the list of numbers
data_items:
    .long 3,67,34,45,75,54,34,222,44,33,22,11,66,0

.section .text
.globl _start
_start:
    movl $0, %edi                       # move 0 into the index register.
    movl data_items(,%edi,4), %eax      # load the first byte of data
    movl %eax, %ebx                     # first item (%eax) is biggest so far

start_loop:                             # start the loop
    cmpl $0, %eax                       # check to see if we've hit the end
    je loop_exit                        # if so, jump to loop_exit label
    incl %edi                           # index++
    movl data_items(,%edi,4), %eax      # load the next byte of data
    cmpl %ebx, %eax                     # compare current to record holder
    jle start_loop                      # if current <= record, go to top
    movl %eax, %ebx                     # if we got here, we set new record
    jmp start_loop                      # now go back to the beginning

loop_exit:                              # answer is currently in %ebx
    movl $1, %eax                       # $1 is the exit() syscall
    int $0x80                           # poke linux with our syscall
