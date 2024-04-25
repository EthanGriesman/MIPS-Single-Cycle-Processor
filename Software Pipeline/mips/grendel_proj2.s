.data
res:
    .word -1-1-1-1
nodes:
    .byte 97 # a
    .byte 98 # b
    .byte 99 # c
    .byte 100 # d
adjacencymatrix:
    .word 6
    .word 0
    .word 0
    .word 3
visited:
    .byte 0 0 0 0
res_idx:
    .word 3
.text
    li $sp, 0x10011000
    li $fp, 0
    la $ra, pump
    j main
pump:
    halt

main:
    addiu $sp, $sp, -40
    sw $31, 36($sp)
    sw $fp, 32($sp)
    add $fp, $sp, $zero
    sw $0, 24($fp)
    j main_loop_control

main_loop_body:
    lw $4, 24($fp)         # Load current node
    nop                    # Prevent load-use hazard
    la $ra, trucks
    j is_visited
    nop                    # Delay slot filler
trucks:
    xori $2, $2, 0x1
    andi $2, $2, 0x00ff
    beq $2, $0, kick
    nop                    # Delay slot filler
    lw $4, 24($fp)         # Load current node again after branch
    la $ra, billowy
    j topsort
    nop                    # Delay slot filler
billowy:

kick:
    lw $2, 24($fp)
    addiu $2, $2, 1
    sw $2, 24($fp)
    j main_loop_control
    nop                    # Delay slot filler

main_loop_control:
    lw $2, 24($fp)
    slti $2, $2, 4
    beq $2, $zero, hew
    nop                    # Delay slot filler
    j main_loop_body
    nop                    # Delay slot filler
hew:
    sw $0, 28($fp)
    j welcome
    nop                    # Delay slot filler
filler
