-- Ethan Griesman
main:
        addiu   $4, $0, 6                        # 0x6
        jal     rec

        halt

rec:
        addiu   $sp,$sp,-32
        sw      $31,28($sp)
        sw      $fp,24($sp)
        #move    $fp,$sp
        and     $fp, $0, $0
        addu    $fp, $sp, $0
        sw      $4,32($fp)
        lw      $2,32($fp)
        blez    $2,$L2

        lw      $2,32($fp)
        addiu   $2,$2,-1
        sw      $2,32($fp)
        lw      $4,32($fp)
        jal     rec

$L2:
        #move    $sp,$fp
        and     $sp, $0, $0
        addu    $sp, $fp, $0
        lw      $31,28($sp)
        lw      $fp,24($sp)
        addiu   $sp,$sp,32
        jr      $31