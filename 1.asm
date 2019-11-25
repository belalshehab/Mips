addi $s0,$0,1
addi $s1,$0,2
slt $s2,$s0,$s1
slt $s3,$s1,$s0
add $s4,$s1,$s0
sw $s0,0($0)
sw $s1,4($0)
sw $s2,8($0)
sw $s3,12($0)
sw $s4,16($0)
lw $s5, 16($0)