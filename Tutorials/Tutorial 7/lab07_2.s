.data

msg_input: .asciiz "\n\nPlease input p: "
msg_output: .asciiz "\nThe extracted numbers are "
msg_output2: .asciiz " and "

.text
.globl main

main:

	move $s7, $ra		# save the return address in $s7

input:	
	li $v0, 4		# print the input messages
	la $a0, msg_input
	syscall

	li $v0, 5		# read_int
	syscall

	beq $v0, $0, end	# if input = 0, terminate the program

	move $s1, $v0		# $s1 stores p	

	move $a0, $v0
	jal extract

	move $s2, $v0		# $s2 stores the unsigned result
	move $s3, $v1		# $s3 stores the signed result

	li $v0, 4		# print the output message
	la $a0, msg_output
	syscall

	li $v0, 1		# print_int
	move $a0, $s2		# print the unsigned result
	syscall

	li $v0, 4
	la $a0, msg_output2
	syscall

	li $v0, 1		# print_int
	move $a0, $s3		# print the signed result
	syscall

	j input			# start over until user input 0

extract:
	## program still works if comment out this part ##	
	addu $t0, $0, 0xffffffff	# create a mask
	srl $t0, $t0, 27
	sll $t0, $t0, 3	
	move $t1, $a0			# $t1 stores p
	and $t1, $t1, $t0		# $t1 = p & mask
	## program still works if comment out this part ##

	sll $t1, $t1, 24	# extract bit 3-5 from p
	srl $t2, $t1, 27	# $t2 stores the extracted unsigned number 
	sra $t1, $t1, 27	# $t1 stores the extracted signed number
		
	move $v0, $t2		# v0 = unsigned
	move $v1, $t1		# v1 = signed
	jr $ra

end:
	move $ra, $s7		# restores the return address 
	jr $ra			# and terminate the program
	


