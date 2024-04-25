.data
res:
    .word -1, -1, -1, -1       # Initialize result array with all elements set to -1
nodes:
    .byte 97 # a               # Byte array with ASCII values for 'a', 'b', 'c', 'd'
    .byte 98 # b
    .byte 99 # c
    .byte 100 # d
adjacencymatrix:
    .word 6                    # Adjacency matrix for graph, first row
    .word 0                    # Second row (no connections)
    .word 0                    # Third row (no connections)
    .word 3                    # Fourth row
visited:
    .byte 0, 0, 0, 0           # Array to keep track of visited nodes, initialized to 0
res_idx:
    .word 3                    # Current index in result array (starts at 3)
.text
    li $sp, 0x10011000         # Set stack pointer to fixed memory address
    li $fp, 0                  # Set frame pointer to 0 (not used effectively)
    la $ra, pump               # Load address of 'pump' label into return address register
    j main                     # Jump to main function to start execution
    nop                        # No operation (fills delay slot)

pump:
    halt                       # Stop the processor

main:
    addiu $sp, $sp, -40        # Allocate 40 bytes on stack for local storage
    sw $ra, 36($sp)            # Store return address on stack
    sw $fp, 32($sp)            # Store frame pointer on stack
    move $fp, $sp              # Update frame pointer to current stack pointer
    sw $zero, 24($fp)          # Initialize loop index at offset 24($fp) to 0
    j main_loop_control        # Jump to loop control block
    nop                        # No operation (fills delay slot)

main_loop_control:
    lw $2, 24($fp)             # Load loop index from memory into $2
    slti $2, $2, 4             # Set $2 to 1 if index < 4, otherwise $2 to 0
    beq $2, $zero, exit_main_loop # Exit loop if $2 is 0 (index >= 4)
    nop                        # No operation (fills delay slot)
    j main_loop_body           # Continue to main loop body
    nop                        # No operation (fills delay slot)

main_loop_body:
    lw $4, 24($fp)             # Load current node index into $4
    la $ra, trucks             # Load address of 'trucks' label into $ra
    j is_visited               # Jump to is_visited to check if node has been visited
    nop                        # No operation (fills delay slot)
trucks:
    xori $2, $2, 0x1           # XOR $2 with 1 to check visited status
    andi $2, $2, 0x00ff        # Mask $2 to keep only the lower byte
    beq $2, $0, increment_index # If node is visited, increment index
    nop                        # No operation (fills delay slot)
    la $ra, billowy            # Load address of 'billowy' label into $ra
    j topsort                  # Jump to topsort function
    nop                        # No operation (fills delay slot)
billowy:
    j loop_continue            # Jump to continue the loop
    nop                        # No operation (fills delay slot)
increment_index:
    lw $2, 24($fp)             # Load current index into $2
    addiu $2, $2, 1            # Increment index
    sw $2, 24($fp)             # Store updated index back to memory
    j main_loop_control        # Jump back to loop control
    nop                        # No operation (fills delay slot)
loop_continue:
    j main_loop_control        # Jump back to start of loop control
    nop                        # No operation (fills delay slot)

exit_main_loop:
    sw $zero, 28($fp)          # Store 0 into location at 28($fp) to mark loop end
    j topsort_init             # Jump to initialization of topsort
    nop                        # No operation (fills delay slot)

topsort_init:
    lw $2, 28($fp)             # Load node index for topsort
    slti $2, $2, 4             # Check if index is less than 4
    xori $2, $2, 0x1           # Invert the result
    beq $2, $0, end_main       # If result is 0, end main function
    nop                        # No operation (fills delay slot)
    j iterate_nodes            # Otherwise, proceed to iterate nodes
    nop                        # No operation (fills delay slot)

iterate_nodes:
    lw $4, 28($fp)             # Load current node index into $4
    la $ra, new                # Load address of 'new' label into $ra
    j is_visited               # Jump to is_visited to check if node has been visited
    nop                        # No operation (fills delay slot)
new:
    xori $2, $2, 0x1           # XOR $2 with 1 to flip visited status
    andi $2, $2, 0x00ff        # Mask $2 to keep only the lower byte
    beq $2, $0, store_result   # If node is not visited, store result
    nop                        # No operation (fills delay slot)
    la $ra, partner            # Load address of 'partner' label into $ra
    j topsort                  # Jump to topsort function
    nop                        # No operation (fills delay slot)
partner:
    addiu $2, $fp, 28          # Calculate address to store result
    move $4, $2                # Move calculated address into $4
    la $ra, badge              # Load address of 'badge' label into $ra
    j next_edge                # Jump to next_edge function
    nop                        # No operation (fills delay slot)
badge:
    sw $2, 24($fp)             # Store result at address calculated earlier
    j iterate_nodes            # Continue iterating nodes
    nop                        # No operation (fills delay slot)

store_result:
    la $v0, res_idx            # Load address of res_idx into $v0
    lw $v0, 0($v0)             # Load value of res_idx into $v0
    addiu $4, $2, -1           # Subtract 1 from $2, store result in $4
    la $3, res_idx             # Load address of res_idx into $3
    sw $4, 0($3)               # Store new value of res_idx
    la $4, res                 # Load address of result array into $4
    sll $3, $2, 2              # Shift left $2 by 2 bits to get byte offset
    srl $3, $3, 1              # Shift right $3 by 1 bit
    sra $3, $3, 1              # Arithmetic shift right $3 by 1 bit
    sll $3, $3, 2              # Shift left $3 by 2 bits to finalize offset calculation
    la $2, res                 # Load address of result array into $2
    andi $at, $2, 0xffff       # AND immediate with $2, mask with 0xffff
    addu $2, $4, $at           # Add $4 and masked $2, store result in $2
    addu $2, $3, $2            # Add $3 to $2, final address for storing result
    lw $3, 48($fp)             # Load value at 48($fp) into $3
    sw $3, 0($2)               # Store value of $3 into calculated result address
    move $sp, $fp              # Restore stack pointer from frame pointer
    lw $ra, 44($sp)            # Load return address from stack
    lw $fp, 40($sp)            # Restore frame pointer from stack
    addiu $sp, $sp, 48         # Adjust stack pointer to release allocated space
    jr $ra                     # Return to previous function

end_main:
    move $sp, $fp              # Restore stack pointer from frame pointer
    lw $ra, 36($sp)            # Load return address from stack
    lw $fp, 32($sp)            # Restore frame pointer from stack
    addiu $sp, $sp, 40         # Adjust stack pointer to release allocated space
    jr $ra                     # Jump to return address, effectively ending the program
