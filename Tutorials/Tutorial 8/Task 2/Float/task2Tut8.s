.data

startValue:		.float 0.0
incrementValue: 	.float 0.1
proportion:		.float 0.8
numberOne:		.float 1.0
maxValue:		.float 1.1
zero:           .float 0.0

message1: .asciiz "\nThis program demonstrates the Graph in question 3: \n"
message2: .asciiz "\nThe value for proportion ["
message3: .asciiz "   |  "
message4: .asciiz "\n"
message5: .asciiz "Fraction     |    SpeedUp \n"


.text
.globl main

main:

	li $v0, 4
	la $a0, message1
	syscall

	l.s $f0, startValue
	l.s $f1, incrementValue
	l.s $f2, numberOne
	l.s $f3, maxValue
	l.s $f4, proportion
	l.s $f7, zero
	
	li $v0, 4
	la $a0, message5
	syscall

	loop:
	
	mul.s $f5,$f0, $f4			# 0.8 * x ( t2 / T)
	sub.s $f5, $f2, $f5			# 1 - (0.8*x)
	div.s   $f6, $f2, $f5			# 1 / (1-0.8*x)

	li $v0, 2
	add.s $f12, $f7, $f0
	syscall

	

	li $v0, 4
	la $a0, message3
	syscall

	li $v0, 2
	add.s $f12, $f7, $f6
	syscall

	li $v0, 4
	la $a0, message4
	syscall


	add.s $f0, $f0, $f1         # x + 0.1
	c.lt.s $f0, $f3
	bc1t loop

 exit:

	li $v0, 10
	syscall









