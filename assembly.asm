addi $s0, $0, 10
addi $s1, $s0, 10
sw $s1, 12($0)
lw $s2, 12($0)
add $s2, $s0, $s2
sw $s2,4($s0)
add $s2,$s0,$s2