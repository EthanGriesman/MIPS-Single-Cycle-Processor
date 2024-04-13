.data
temp: .word 255                                         # declare data and set to 255
.text
.globl main

main:
    # Setup stack pointer
    lui $sp, 0x7FFF
    addi $sp, $sp, 0xEFFC
    
    jal func1
    halt


func1:
    subi $sp, $sp, 16
    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $a1, 0($sp)

    jal func2

    
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)

    addi $sp, $sp, 16

    jr $ra

func2:

    subi $sp, $sp, 16
    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $a1, 0($sp)

    jal func3

    
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)

    addi $sp, $sp, 16

    jr $ra

func3:

    subi $sp, $sp, 16
    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $a1, 0($sp)

    jal func4

    
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)

    addi $sp, $sp, 16

    jr $ra

func4:
    subi $sp, $sp, 16
    sw $ra, 8($sp)
    sw $a0, 4($sp)
    sw $a1, 0($sp)

    jal func5

    
    lw $ra, 8($sp)
    lw $a0, 4($sp)
    lw $a1, 0($sp)

    addi $sp, $sp, 16

    jr $ra

func5:
    jr $ra
