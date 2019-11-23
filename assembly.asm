addi $s0, $0, 10
addi $s1, $s0, 10
sw $s1, 10($0)
lw $s2, 10($0)
add $s2, $s0, $s1
sw $s2, 0($0)