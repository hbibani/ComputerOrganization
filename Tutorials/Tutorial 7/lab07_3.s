.data

msg_input_p: .asciiz "\n\nPlease input p: "
msg_input_m: .asciiz "\nPlease input m: "
msg_input_n: .asciiz "\nPlease input n: "

msg_output1: .asciiz "\nThe extracted numbers are "
msg_output2: .asciiz " and "

.text
.globl main

main:

	move $s7, $ra		# save the return address in $s7

input:	
	li $v0, 4		# ask for p
	la $a0, msg_input_p
	syscall

	li $v0, 5		# read p
	syscall
	beq $v0, $0, end	# if input = 0, terminate the program
	move $t1, $v0		# $t1 stores p	

	li $v0, 4		# ask for n
	la $a0, msg_input_n
	syscall

	li $v0, 5		# read n
	syscall
	move $t2, $v0		# $t2 stores n

	li $v0, 4		# ask for m
	la $a0, msg_input_m
	syscall

	li $v0, 5		# read m
	syscall
	move $t3, $v0		# $t3 stores m

	move $a0, $t1		# pass p, n, m to extract
	move $a1, $t2
	move $a2, $t3
	jal extract

	move $s2, $v0		# $s2 stores the unsigned result
	move $s3, $v1		# $s3 stores the signed result

	li $v0, 4		# print the output message
	la $a0, msg_output1
	syscall

	li $v0, 1		# print_int
	move $a0, $s2		# print the signed result
	syscall

	li $v0, 4
	la $a0, msg_output2
	syscall

	li $v0, 1		# print_int
	move $a0, $s3		# print the unsigned result
	syscall

	j input			# start over until user input 0

extract:
	move $t1, $a0		# $t1 stores p
	move $t2, $a1		# $t2 stores n
	move $t3, $a2		# $t3 stores m
	
	# extract p

	## program still works if comment out this part ##
	addu $t0, $0, 0xffffffff	# create a mask
	addu $t6, $0, 32		# total number of bits
	sub $t6, $t6, $t1		# shift to right 32 - n bits
	srl $t0, $t0, $t6
	sll $t0, $t0, $a2		# shift to left m bits
	and $t1, $t1, $t0		# $t1 = p & mask
	## program still works if comment out this part ##

	addu $t3, $t2, $t3	# calculate number of bits to shift left
	sub $t3, $0, $t3
	add $t3, $t3, 32
	sll $t1, $t1, $t3	# shift p to the left
	
	sub $t2, $0, $t2	# calculate number of bits to shift right
	add $t2, $t2, 32	
	srl $t4, $t1, $t2	# $t4 = extracted unsigned number 
	sra $t5, $t1, $t2	# $t5 = extracted signed number
		
	move $v0, $t4		# v0 = unsigned
	move $v1, $t5		# v1 = signed
	jr $ra

end:
	move $ra, $s7		# restores the return address 
	jr $ra			# and terminate the program
	


