.data
#.extern myspace 4
myspace: .word 0

.globl mess

mess: .asciiz "\nThe value of f is: "



f: .word 1
g: .word 5
h: .word -20
i: .word 13
jj: .word 3

.text

main:
addu $s7, $0, $ra

add $t1, $0, 10
#sw $t1, myspace
#lw $t2, myspace
sw $t1, 0x8000($gp)
lw $t2, 0x8000($gp)
#sw $t0, myspace
#sw $t0, -0x8000($gp)
#lw $s1, -0x8000($gp)


lw $s1, g
lw $s2, h
lw $s3, i
lw $s4, jj

add $t0, $s1, $s2



add $t1, $s3, $s4
sub $s0, $t0, $t1

li $v0, 4
la $a0, mess
syscall

li $v0, 1
add $a0, $0, $s0
syscall

addu $ra, $0, $s7
jr $ra

