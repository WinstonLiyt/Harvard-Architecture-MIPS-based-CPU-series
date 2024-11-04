.data
A:.space 240
B:.space 240
C:.space 240
D:.space 240

.text
add $6,$0,$0
add $7,$0,$0
add $8,$0,$0
add $9,$0,$0
add $10,$0,$0
add $11,$0,$0
add $12,$0,$0
add $13,$0,$0

sll $11,$6,2
addi $7,$0,0
sw $7,A($11)
addi $8,$0,1
sw $8,B($11)
add $9,$0,$7
sw $9,C($11)
add $10,$0,$8
sw $10,D($11)
addi $6,$6,1

p1:
sll $11,$6,2
add $7,$7,$6
sw $7,A($11)
mul $12,$6,3
add $8,$8,$12
sw $8,B($11)
add $9,$0,$7
sw $9,C($11)
add $10,$0,$8
sw $10,D($11)
addi $6,$6,1
slti $13,$6,20
bne $13,$0,p1

p2:
sll $11,$6,2
add $7,$7,$6
sw $7,A($11)
mul $12,$6,3
add $8,$8,$12
sw $8,B($11)
add $9,$7,$8
sw $9,C($11)
mul $10,$7,$9
sw $10,D($11)
addi $6,$6,1
slti $13,$6,40
bne $13,$0,p2

p3:
sll $11,$6,2
add $7,$7,$6
sw $7,A($11)
mul $12,$6,3
add $8,$8,$12
sw $8,B($11)
mul $9,$7,$8
sw $9,C($11)
mul $10,$8,$9
sw $10,D($11)
addi $6,$6,1
slti $13,$6,60
bne $13,$0,p3
