# Ethan Griesman
# Spring 2024
# Department of Electrical and Computer Engineering
# Iowa State University
#
# This script tests control-flow instructions in MIPS with a call depth of at least 5.
# Each function performs a simple arithmetic operation and calls the next function,
# demonstrating the functionality of the MIPS call stack and procedure calling convention.

.data
    value: .word 10   # Initial value for computation

.text
.globl main

main:
    # Setup initial stack frame
    lui $sp, 0x7FFF
    addi $sp, $sp, -20  # Allocate space for main's frame

    # Load initial value to pass to the first function
    lw $a0, value
    jal func1           # Jump and link to func1

    li $v0, 10          # Load syscall for exit
    syscall             # Execute the exit syscall

# Function 1
func1:
    subi $sp, $sp, 20   # Allocate stack space for func1
    sw $ra, 16($sp)     # Save return address
    sw $a0, 12($sp)     # Save argument

    addi $a0, $a0, 5    # Some operation
    jal func2           # Call next function

    lw $a0, 12($sp)     # Restore argument
    lw $ra, 16($sp)     # Restore return address
    addi $sp, $sp, 20   # Deallocate stack space
    jr $ra              # Return to caller

# Function 2
func2:
    subi $sp, $sp, 20   # Allocate stack space for func2
    sw $ra, 16($sp)     # Save return address
    sw $a0, 12($sp)     # Save argument

    addi $a0, $a0, 10   # Some operation
    jal func3           # Call next function

    lw $a0, 12($sp)     # Restore argument
    lw $ra, 16($sp)     # Restore return address
    addi $sp, $sp, 20   # Deallocate stack space
    jr $ra              # Return to caller

# Function 3
func3:
    subi $sp, $sp, 20   # Allocate stack space for func3
    sw $ra, 16($sp)     # Save return address
    sw $a0, 12($sp)     # Save argument

    addi $a0, $a0, -3   # Some operation
    jal func4           # Call next function

    lw $a0, 12($sp)     # Restore argument
    lw $ra, 16($sp)     # Restore return address
    addi $sp, $sp, 20   # Deallocate stack space
    jr $ra              # Return to caller

# Function 4
func4:
    subi $sp, $sp, 20   # Allocate stack space for func4
    sw $ra, 16($sp)     # Save return address
    sw $a0, 12($sp)     # Save argument

    addi $a0, $a0, 20   # Some operation
    jal func5           # Call next function

    lw $a0, 12($sp)     # Restore argument
    lw $ra, 16($sp)     # Restore return address
    addi $sp, $sp, 20   # Deallocate stack space
    jr $ra              # Return to caller

# Function 5
func5:
    subi $sp, $sp, 20   # Allocate stack space for func5
    sw $ra, 16($sp)     # Save return address
    sw $a0, 12($sp)     # Save argument

    addi $a0, $a0, -7   # Some operation

    lw $a0, 12($sp)     # Restore argument
    lw $ra, 16($sp)     # Restore return address
    addi $sp, $sp, 20   # Deallocate stack space
    jr $ra              # Return to caller
