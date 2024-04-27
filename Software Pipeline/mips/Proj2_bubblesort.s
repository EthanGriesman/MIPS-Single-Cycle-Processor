# Ethan Griesman
# Spring 2024
# Department of Electrical and Computer Engineering
# Iowa State University
#
# This optimized MIPS assembly code sorts an array of integers using the Bubble Sort algorithm.
# It iteratively compares and swaps adjacent elements if they are in the wrong order,
# ensuring the largest elements bubble to the end of the array after each iteration.

.data
array:
   	.word   10, 5, 27, 2, 1, 12
  	 
.text
# 4 no-ops or other instructions required between each instruction with read/write dependencies, 5 pipeline stages

main:
    #Set the number of elements we want to sort into $a0
    addiu   $4, $0, 6
    jal bubblesort
    # Prevent halt from entering the pipeline pre-mature bubblesort completion
    nop
    nop
    nop
    nop
    halt

bubblesort:
   	addiu   $sp,$sp,-32 # allocate space on the stack for the function frame
   	nop
   	nop
   	nop
   	sw  	$fp,28($sp) # store old frame pointer on the stack
   	#move	$fp,$sp     
   	add 	$fp, $sp, $0 # set up new frame pointer
   	nop
   	nop
   	nop
   	sw  	$4,32($fp)  # store number of elements on top of the frame
   	sw  	$0,8($fp)   # initialize outer loop counter to 0
   	b   	$L2 # begin loop 
   	nop
   	nop
   	nop
   	nop

# begin outer loop
$L6:
   	sw  	$0,12($fp) # reset inner loop counter to 0
   	b   	$L3 # branch to beginning of loop
   	nop
   	nop
   	nop
   	nop

# inner loop, performs element comparison and swap if needed
$L5: 
   	lw  	$3,12($fp) # 4 instructions between $3 dependency
   	lasw  	$2, array  # 4 instructions between $2 dependency
   	nop 
   	nop
   	nop
   	sll 	$3,$3,2
   	nop
   	nop
   	nop
   	addu	$2,$3,$2
   	nop
   	nop
   	nop
   	lw  	$3,0($2)
   	lw  	$2,12($fp)
   	nop
   	nop
   	nop
   	addiu   $4,$2,1
   	lasw  	$2, array
   	nop
   	nop
   	sll 	$4,$4,2
   	nop
   	nop
   	nop
   	addu	$2,$4,$2
   	nop
   	nop
   	nop
   	lw  	$2,0($2)
   	nop
   	nop
   	nop
   	slt 	$2,$2,$3
   	nop
   	nop
   	nop
   	beq 	$2,$0,$L4
   	nop
   	nop
   	nop
   	nop

   	lw  	$3,12($fp)
   	lasw  $2, array
   	nop
   	nop
   	nop
   	sll 	$3,$3,2
   	nop
   	nop
   	nop
   	addu	$2,$3,$2
   	nop
   	nop
   	nop
   	lw  	$2,0($2)
   	nop
   	nop
   	nop
   	sw  	$2,16($fp)
   	lw  	$2,12($fp)
   	nop
   	nop
   	nop
   	addiu   $3,$2,1
   	lasw  	$2, array
   	nop
   	nop
   	sll 	$3,$3,2
   	nop
   	nop
   	nop
   	addu	$2,$3,$2
   	nop
   	nop
   	lw  	$4,12($fp)
   	lw  	$3,0($2)
   	lasw  $2, array
   	nop
   	sll 	$4,$4,2
   	nop
   	nop
   	nop
   	addu	$2,$4,$2
   	nop
   	nop
   	nop
   	sw  	$3,0($2)
   	lw  	$2,12($fp)
   	nop
   	nop
   	nop
   	addiu   $3,$2,1
   	lasw  	$2, array
   	nop
   	nop
   	nop
   	sll 	$3,$3,2
   	nop
   	nop
   	nop
   	addu	$2,$3,$2
   	lw  	$3,16($fp)
   	nop
   	nop
   	nop
   	sw  	$3,0($2)
   	nop
   	nop
   	nop
$L4:
   	lw  	$2,12($fp)
   	nop
   	nop
   	nop
   	addiu   $2,$2,1
   	nop
   	nop
   	nop
   	sw  	$2,12($fp)
   	nop
   	nop
   	nop
$L3:
   	lw  	$3,32($fp)
   	lw  	$2,8($fp)
   	nop
   	nop
   	nop
   	subu	$2,$3,$2
   	lw  	$3,12($fp)
   	nop
   	nop
   	nop
   	slt 	$2,$3,$2
   	nop
   	nop
   	nop
   	bne 	$2,$0,$L5
   	nop
   	nop
   	nop
   	nop

   	lw  	$2,8($fp)
   	nop
   	nop
   	nop
   	addiu   $2,$2,1
   	nop
   	nop
   	nop
   	sw  	$2,8($fp)
   	nop
   	nop
   	nop
$L2: # outer loop, iterates over the array
   	lw  	$3,8($fp)
   	lw  	$2,32($fp)
   	nop
   	nop
   	nop
   	slt 	$2,$3,$2
   	nop
   	nop
   	nop
   	bne 	$2,$0,$L6
   	nop
   	nop
   	nop
   	nop
   	lw  	$fp,28($sp)
   	addiu   $sp,$sp,32
   	jr $31
   	nop
   	nop
   	nop
   	nop

