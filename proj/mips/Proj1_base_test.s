# Ethan Griesman
# Spring 2024
# Department of Electrical and Computer Engineering
# Iowa State University
#
# This test application is designed to exercise each arithmetic and logical instruction
# supported by a single-cycle processor. It is structured to demonstrate functionality
# rather than perform a specific task, ensuring each instruction is used effectively.


.data
    # No initialized data for this test.


.text
.global main


main:
    # Initialize registers with different values
    li $t0, 0xF0F0       # Initialize $t0 with a hexadecimal value
    li $t1, 0x0F0F       # Initialize $t1 with a complementary hex value
    li $t2, -123         # Initialize $t2 with a negative number
    li $t3, 100          # Initialize $t3 with a positive number
    li $t4, 0            # Initialize $t4 with zero


    # Basic arithmetic operations
    add $t5, $t0, $t1    # ADD: $t5 = $t0 + $t1
    sub $t6, $t3, $t2    # SUB: $t6 = $t3 - $t2
    addi $t7, $t5, 1     # ADDI: Increment $t5 by 1 and store in $t7
    addiu $t8, $t6, -1   # ADDIU: Decrement $t6 by 1 and store in $t8


    # Logical operations
    and $t9, $t0, $t1    # AND: $t9 = $t0 AND $t1
    or $s0, $t0, $t1     # OR: $s0 = $t0 OR $t1
    xor $s1, $t0, $t1    # XOR: $s1 = $t0 XOR $t1
    nor $s2, $t0, $t1    # NOR: $s2 = NOR of $t0 and $t1


    # Shift operations
    sll $s3, $t7, 2      # SLL: Shift $t7 left by 2 bits
    srl $s4, $t8, 2      # SRL: Shift $t8 right by 2 bits (logical)
    sra $s5, $t6, 3      # SRA: Shift $t6 right by 3 bits (arithmetic)


    # Set less than operation
    slt $s6, $t2, $t3    # SLT: Set $s6 to 1 if $t2 < $t3, otherwise 0


    # Use NOPs to separate instruction phases
    nop
    nop
    nop


    # Store results back into memory (dummy operations)
    sw $t5, 0($t4)
    sw $t6, 4($t4)
    sw $t7, 8($t4)
    sw $t8, 12($t4)
    sw $t9, 16($t4)
    sw $s0, 20($t4)
    sw $s1, 24($t4)
    sw $s2, 28($t4)
    sw $s3, 32($t4)
    sw $s4, 36($t4)
    sw $s5, 40($t4)
    sw $s6, 44($t4)


    # Final NOPs to simulate delay
    nop
    nop
    nop


    # Exit the test
    li $v0, 10           # Load syscall for exit
    syscall              # Execute the exit syscall