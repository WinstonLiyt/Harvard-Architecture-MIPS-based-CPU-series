.text
addi $1, $0, 50
addi $2, $0, 36
addi $3, $0, 0
addi $4, $0, 0
addi $5, $0, 0
addi $6, $1, 1
addi $7, $0, 1

loop:
    addi $4, $4, 1
    add $8, $6, $5
    srl $8, $8, 1
    slt $9, $2, $8
    beq $9, $7, broken
    addi $5, $8, 0
    j over

broken:
    addi $3, $3, 1
    addi $6, $8, 0

over:
    addi $10, $5, 1
    bne $10, $6, loop

check_broken:
    bne $6, $8, not_broken
    addi $3, $3, 1
    addi $7, $0, 1
    j end
not_broken:
    addi $7, $0, 0

end:

