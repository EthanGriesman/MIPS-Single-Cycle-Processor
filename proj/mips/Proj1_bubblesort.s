.data
list:.word   5, 7, 9, 2, 3, 6, 11
size: .word 7

.text
.globl main

main:
                                            # $t0, outer loop iterator (i)
                                            # $t1, inner loop iterator (j)
                                            # $s0, list base address
                                            # $s1, size
                                            # $t7, inner loop upper bound
                                            # $t6, temporary
                                            # $s2, word a
                                            # $s3, word b

    add     $t0,        $zero,  $zero
    la      $s0,        list
    lw      $s1,        size
    addi    $t7,        $zero,  0

outer_loop:
                                            # Check if we've walked the whole list
    beq     $t0,        $s1,    exit

# upper bound of inner loop = size - i - 1
    sub     $t7,        $s1,    $t0
    addi    $t7,        $t7,    -1

# j = 0
    add     $t1,        $zero,  $zero

# for (j < $t7)
inner_loop:

    beq     $t1,        $t7,    continue


    sll     $t6,        $t1,    2           # Mult i by 4 to get correct address
    add     $t6,        $s0,    $t6

    lw      $s2,        0($t6)
    lw      $s3,        4($t6)

# if $s3 > $s2, swap, else goto sorted
    slt     $t2,        $s3,    $s2
    beq     $t2,        $zero,  sorted
    sw      $s3,        0($t6)
    sw      $s2,        4($t6)

sorted:
                                            # j++
    addi    $t1,        $t1,    1
    j       inner_loop

continue:
                                            # i++
    addi    $t0,        $t0,    1
    j       outer_loop

exit:
    halt    