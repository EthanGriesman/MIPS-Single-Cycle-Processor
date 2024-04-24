.data
res:
    .word -1, -1, -1, -1
nodes:
    .byte 97, 98, 99, 100 # a, b, c, d
adjacencymatrix:
    .word 6, 0, 0, 3
visited:
    .byte 0, 0, 0, 0
res_idx:
    .word 3
.text
    li $sp, 0x10011000
    li $fp, 0
    la $ra, pump
    j main # jump to the starting location
pump:
    halt

main:
    addiu $sp, $sp, -40 # MAIN
    sw $31, 36($sp)
    sw $fp, 32($sp)
    add $fp, $sp, $zero
    sw $0, 24($fp)
    j main_loop_control

main_loop_body:
    lw $4, 24($fp)
    la $ra, trucks
    j is_visited

trucks:
    xori $2, $2, 0x1
    andi $2, $2, 0x00ff
    beq $2, $0, kick
    lw $4, 24($fp)
    la $ra, billowy
    j topsort

billowy:
    nop # Resolve hazard with $ra usage in topsort

kick:
    lw $2, 24($fp)
    addiu $2, $2, 1
    sw $2, 24($fp)

main_loop_control:
    lw $2, 24($fp)
    slti $2, $2, 4
    beq $2, $zero, hew # beq, j to simulate bne
    j main_loop_body

hew:
    sw $0, 28($fp)
    j welcome

welcome:
    lw $2, 28($fp)
    slti $2, $2, 4
    xori $2, $2, 1 # xori 1, beq to simulate bne where val in [0,1]
    beq $2, $0, wave
    move $2, $0
    move $sp, $fp
    lw $31, 36($sp)
    lw $fp, 32($sp)
    addiu $sp, $sp, 40
    jr $ra

wave:
    lw $2, 28($fp)
    addiu $2, $2, 1
    sw $2, 28($fp)
    j welcome

topsort:
    addiu $sp, $sp, -48
    sw $31, 44($sp)
    sw $fp, 40($sp)
    move $fp, $sp
    sw $4, 48($fp)
    lw $4, 48($fp)
    la $ra, verse
    j mark_visited

verse:
    addiu $2, $fp, 28
    lw $5, 48($fp)
    move $4, $2
    la $ra, joyous
    j iterate_edges

joyous:
    addiu $2, $fp, 28
    move $4, $2
    la $ra, whispering
    j next_edge

whispering:
    sw $2, 24($fp)
    j turkey

turkey:
    lw $3, 24($fp)
    li $2, -1
    beq $3, $2, telling # beq, j to simulate bne
    j interest

telling:
    la $v0, res_idx
    lw $v0, 0($v0)
    addiu $4, $2, -1
    la $3, res_idx
    sw $4, 0($3)
    la $4, res
    sll $3, $2, 2
    srl $3, $3, 1
    sra $3, $3, 1
    sll $3, $3, 2
    xor $at, $ra, $2 # does nothing
    nor $at, $ra, $2 # does nothing
    la $2, res
    andi $at, $2, 0xffff # -1 will sign extend (according to assembler), but 0xffff won't
    addu $2, $4, $at
    addu $2, $3, $2
    lw $3, 48($fp)
    sw $3, 0($2)
    move $sp, $fp
    lw $31, 44($sp)
    lw $fp, 40($sp)
    addiu $sp, $sp, 48
    jr $ra
