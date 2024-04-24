-- Ethan Griesman
#This test tests various control flow instructions for the purposes of demonstrating the fetch logic

.text 
addi $8, $t1, 0x123
addiu $8, $8, 0x7FFFFFFF  #Shouldn't generate overflow
lui $9, 0x204
addu $9, $9, $8           #Also shouldn't generate overflow
and $10, $8, $9
andi $11, $9, 0x2F0       #Should still be 0x200

lui $8, 0x1234
lui $9, 0x1234
beq	$8, $9, br_eq
addi $1, $1, 0x00002468   #!!!This should never be executed!!!

br_eq:
bne $8, $9, br_ne
addi $1, $1, 0x00001245   #!!!This should always be executed!!!

br_ne:
j next

addi $1, $1, 0x00002468   #!!!This should never be executed!!!
addi $1, $1, 0x0000ABCD   #!!!This should never be executed!!!

next:
jal jal_label             #We expect that $31 should be updated with the address of the next instruction
addi $1, $1, 0x00002468   #!!!This should never be executed!!!
addi $1, $1, 0x0000ABCD   #!!!This should never be executed!!!

jal_label:
addu $21, $0, $31         #Test that the $ra register updated correctly
bgez $0, b_gez
addi $1, $1, 0x00002468   #!!!This should never be executed!!!
addi $1, $1, 0x0000ABCD   #!!!This should never be executed!!!

b_gez:
bgtz $8, b_gtz
addi $1, $1, 0x00002468   #!!!This should never be executed!!!
addi $1, $1, 0x0000ABCD   #!!!This should never be executed!!!

b_gtz:
blez $0, b_lez
addi $1, $1, 0x00002468   #!!!This should never be executed!!!
addi $1, $1, 0x0000ABCD   #!!!This should never be executed!!!

b_lez:
lui $8, 0x8FFF
bltz, $8, b_ltz
addi $1, $1, 0x00002468   #!!!This should never be executed!!!
addi $1, $1, 0x0000ABCD   #!!!This should never be executed!!!

b_ltz:
bgezal $9, j_back
bltzal $8, j_back
halt

j_back:
jr $31