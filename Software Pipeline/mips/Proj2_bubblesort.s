# Ethan Griesman
# Spring 2024
# Department of Electrical and Computer Engineering
# Iowa State University
#
# This optimized MIPS assembly code sorts an array of integers using the Bubble Sort algorithm.
# It iteratively compares and swaps adjacent elements if they are in the wrong order,
# ensuring the largest elements bubble to the end of the array after each iteration.

.data
list: .word 5, 7, 9, 2, 3, 6, 11
size: .word 7

.text
.globl main

main:
    add $t0, $zero, $zero         # Initialize outer loop counter i to 0
    lasw $s0, list                # Load base address of the list into $s0 with safe load address instruction
    lw $s1, size                  # Load the size of the list into $s1
    addi $t7, $zero, 0            # Initialize inner loop upper bound

outer_loop:
    beq $t0, $s1, exit            # Exit loop if i == size
    sub $t7, $s1, $t0             # Calculate upper bound of inner loop = size - i
    addi $t7, $t7, -1             # Decrement upper bound to use zero-indexed array access

    add $t1, $zero, $zero         # Initialize inner loop counter j to 0

inner_loop:
    beq $t1, $t7, continue        # If j == upper bound, continue to increment i
    sll $t6, $t1, 2               # $t6 = j * 4 (offset for word access)
    add $t6, $s0, $t6             # $t6 = address of list[j]

    lw $s2, 0($t6)                # Load list[j] into $s2
    lw $s3, 4($t6)                # Load list[j+1] into $s3
    nop                           # NOP to avoid load-use hazard with $s3

    slt $t2, $s3, $s2             # Set $t2 if list[j+1] < list[j]
    beq $t2, $zero, sorted        # If not less, jump to sorted, i.e., do not swap
    sw $s3, 0($t6)                # Swap elements: list[j] = list[j+1]
    sw $s2, 4($t6)                # Swap elements: list[j+1] = list[j]

sorted:
    addi $t1, $t1, 1              # Increment inner loop counter j
    j inner_loop                  # Jump back to the start of inner loop

continue:
    addi $t0, $t0, 1              # Increment outer loop counter i
    j outer_loop                  # Jump back to the start of outer loop

exit:
    halt                          # Exit the program
