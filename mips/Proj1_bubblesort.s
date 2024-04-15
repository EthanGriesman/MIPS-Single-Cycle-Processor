# Ethan Griesman
# Spring 2024
# Department of Electrical and Computer Engineering
# Iowa State University
#
# This MIPS assembly code sorts an array of integers using the Bubble Sort algorithm.
# It iteratively compares and swaps adjacent elements if they are in the wrong order,
# ensuring the largest elements bubble to the end of the array after each iteration.

.data
list: .word 5, 7, 9, 2, 3, 6, 11    # Array to sort
size: .word 7                       # Number of elements in the array

.text
.globl main

main:
    # Initialize registers
    li $t0, 0                        # $t0, outer loop iterator (i)
    la $s0, list                     # $s0, base address of the list
    lw $s1, size                     # $s1, size of the list
    li $t7, 0                        # $t7, inner loop upper bound initially 0

    # Calculate the starting upper bound for the inner loop
    lw $t7, size                     # Load the size into $t7
    addi $t7, $t7, -1                # Decrement by 1 to account for 0-based index

outer_loop:
    # Termination condition for the outer loop
    beq $t0, $s1, exit               # If i equals array size, all elements are sorted

    # Set upper bound for inner loop (size - i - 1)
    sub $t7, $s1, $t0
    addi $t7, $t7, -1

    # Reset inner loop iterator
    li $t1, 0                        # $t1, inner loop iterator (j)

inner_loop:
    # Termination condition for the inner loop
    bge $t1, $t7, outer_loop_increment

    # Calculate addresses for current and next elements
    sll $t6, $t1, 2                  # Multiply index j by 4 to get word offset
    add $t6, $s0, $t6                # Add offset to base address to get element address

    # Load current and next elements
    lw $s2, 0($t6)                   # Load element at index j into $s2
    lw $s3, 4($t6)                   # Load element at index j+1 into $s3

    # Compare and possibly swap elements
    slt $t2, $s2, $s3                # Set $t2 to 1 if $s2 < $s3 (wrong order)
    beq $t2, $zero, inner_loop_increment  # If $s2 is less than $s3, go to next iteration

    # Swap elements
    sw $s3, 0($t6)                   # Store $s3 at index j
    sw $s2, 4($t6)                   # Store $s2 at index j+1

inner_loop_increment:
    # Increment inner loop iterator
    addi $t1, $t1, 1
    j inner_loop                     # Jump back to the start of inner loop

outer_loop_increment:
    # Increment outer loop iterator
    addi $t0, $t0, 1
    j outer_loop                     # Jump back to the start of outer loop

exit:
    li $v0, 10                       # Load exit syscall
    syscall                          # Exit the program
