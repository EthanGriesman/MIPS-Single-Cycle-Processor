	# Ethan Griesman
	addi $s0, $s1, 4
	NOP
	NOP
	NOP
	add  $s2, $s0, $zero
	NOP
	NOP
	NOP
	addu $s3, $s2, $s0
	NOP
	NOP
	NOP
	addiu $s4, $s2, 2
	NOP
	NOP
	NOP
	and  $s5, $s4, $s2
	NOP
	NOP
	NOP
	andi $s5, $s5, 0x00000000
	NOP
	NOP
	NOP
	lui $a0, 4096
	NOP
	NOP
	NOP
	sw $a0, 0($a0)
	NOP
	NOP
	NOP
	lw $a0 , 0($a0)
	NOP
	NOP
	NOP
	nor $t0, $s4, $zero
	xor $t1, $s4, $s2
	NOP
	NOP
	NOP
	xori $t2, $t1, 0x00000F0F
	NOP
	NOP
	NOP
	or $t3, $zero, $t2
	ori $t4, $zero, 0x0000FFFF
	slt $at, $s2, $s4
	slti $s0, $s2, 0x00000F00
	sll $t5, $s4, 7
	NOP
	NOP
	NOP
	srl $t5, $t5, 7
	sra $t4, $t4, 9
	sub $s2, $s2, $s3
	NOP
	NOP
	NOP
	subu $s2, $s2, $s3

        lb $t6, 0($a0)             # Load byte: Load a byte from memory address 0($a0) into $t6
	halt
