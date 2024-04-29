# test all the instructions

	#.global  main
	
main:
	addi $a1, $zero, 10 	#$a1 = 10
	addi $a2, $zero, 20  	#$a2 = 20
	NOP
	NOP
	NOP
	add  $t3, $a1, $a2   	#$t3 = $a1 + $a2 = 30 
	
	addi $a3, $zero, -16 	#$a3 = -16
	NOP
	NOP
	NOP
	addu $t2, $zero, $a3 	#$t2 = 0xfffffff0

	NOP
	addiu $a3, $t3, -2 	#$a3 = 28
	NOP
	NOP
	NOP
	addiu $a0, $a3, -30     #$a0 = 0xfffffffe
	
	NOP
	NOP
	NOP
	and   $t1, $a0, $t2	#$a0 & $t2 = 0xfffffff0
	NOP
	NOP
	NOP
	andi  $t2, $t1, 0       #$t2 = 0x00000000
	
	# test on load words 
	lui   $t4, 0x1001  #$t4 = 0x10010000
	NOP
	NOP
	NOP
	sw    $t3, 4($t4)      # store 0x000001e to the 0x10010004 
	lw    $t1, 4($t4)      # get the data from 0x10010004 and store into the $t1, $t1 = 30 (0x0000001e)
	
	
	#test nor, xor , xori 
	
	nor   $t5, $a0, $zero # $a0 = 0xfffffffe nor zero = 0x00000001 (only 0 & 0 has output 1)
	NOP
	NOP
	NOP 
	xor   $t6, $t1, $t5   # $t1 = 0x0000001e xor 0x00000001 = 0x0000001f
	xori  $t2, $a1, 100   # 0x0000000a xor 0x00000064 = 0x0000006e
	
	or    $t3, $t1, $t5  # t3 = 0x000000lf 
	ori    $t7, $a2, -1  # $t7 = 0xffffffff
	NOP
	
	slt   $t1, $t2, $t1  # set $t1 to 0
	slt   $t5, $t5, $a1  #set $t5 to 1
	
	slti  $t6, $t3, 100   #set $t6 to 1
	slti  $t6, $t3, 1     #set $t6 to 0 
	
	sll   $t1, $a1, 2    # 10 * 4, $t1 = 40 
	srl   $t5, $a2, 2    # 20 / 4, $t5 = 5 
	
	addi  $s0, $0, -53 
	NOP
	NOP
	NOP
	sra   $t7, $s0, 2     # $t7 = -14 
	
	sub   $t0, $a2, $a1   # 20 -10 
	sub   $t2, $a1, $a2   # 10 - 20 
	
	subu  $t3, $a1, $a2  
	
	beq   $t7, $s0, main 
	NOP
	NOP
	NOP
	addi  $s0, $zero, 0 
	NOP
	NOP
	NOP
	beq   $zero, $s0, test
	NOP
	NOP
	NOP
	addi  $s0, $zero, 100 
	
	test: 
	addi $t7, $0, 100 
	bne  $t1, $0, branch 
	NOP
	NOP
	NOP
	addi $t1, $0, 0
	
	branch: addi $t2, $0, 5  # i = 5 
	j loop 
	NOP
	NOP
	NOP
	
	loop: 
	addi $t7, $t7, 1   # 100 + 1 
	addi $t2, $t2, -1  # i--
	NOP
	NOP
	NOP
	bne  $t2, $zero, loop
	NOP
	NOP
	NOP
	# $t0 = 105 
	
	jal branch2
	NOP
	NOP
	NOP
	add $t1, $0, 1	   # $t1 = 1 
	NOP
	NOP
	NOP
	beq $t2, $t1, exit #if ald execute branch2, go exit 
	NOP
	NOP
	NOP
	
	branch2: 
	addi $t2, $0, 1   # $t2 = 1
	NOP
	NOP
	NOP
	add $t0, $t2, $t7  # $t0 = 106
	NOP
	jr $ra
	NOP
	NOP
	NOP
	
	
	exit:
	
	
	halt
	