#Lab05 Q4

.data
	P: .space 40 # 10 elements, 4 bytes each
	Q: .space 40 # 10 elements, 4 bytes each

	msg_input_n: 	.asciiz "\n\nHow many elements in P(1-9)? "
	msg_error:	.asciiz "\nInvalid range, please try again."
	msg_input_open: .asciiz "\nPlease input P["
	msg_output_P:	.asciiz "P["
	msg_output_Q:	.asciiz "Q["
	msg_close: 	.asciiz "]: "
	msg_tab:	.asciiz "\t"
	msg_newline:	.asciiz "\n"

.text
main:
	move $s7, $ra		# backup program return address

input_size:
	li $v0, 4 		# Print message to ask how many elements in P
	la $a0, msg_input_n
	syscall

	li $v0, 5 		# Read the size of P from the user
	syscall
	
	blt $v0, 1, error_msg	# test if the user input is in the range
	bgt $v0, 9, error_msg

	move $s3, $v0		# store the size of P in $s3
	move $t1, $0		# initialize the index i for user input loop
	move $s2, $0		# initialize $s2 to carry the sum of P[i]

user_input:
	li $v0, 4 		# Print message to ask for elements in P
	la $a0, msg_input_open
	syscall
	
	li $v0, 1 		# Ask for the contents of the elements in P
	move $a0, $t1
	syscall

	li $v0, 4 		# Print end of the message
	la $a0, msg_close
	syscall

	li $v0, 5		# read user input of P[i]
	syscall
	
	sll $t2, $t1, 2		# address pointer = i * 4
	sw $v0, P($t2)		# store the contents in P
	add $s2, $s2, $v0
	sw $s2, Q($t2)		# store the cumulative sum in Q
	
	add $t1, $t1, 1		# jumps to the next element
	blt $t1, $s3, user_input # if i < size of P, continue to input

	move $t1, $0		# initialize the index i for output loop

	la  $s4, msg_output_P
	la $s1, P		# $s1 = base address of P
	jal output

	li $v0, 4		# print a new line
	la $a0, msg_newline
	syscall

	la $s4, msg_output_Q
	la $s1, Q		# $s1 = base address of Q
	jal output

	move $ra, $s7		# restore program return address and return
	jr $ra

output:		
	li $v0, 4		# print the results
	move $a0, $s4		# load the address of the message 
	syscall
	
	li $v0, 1		# print the contents
	move $a0, $t1
	syscall
	
	li $v0, 4
	la $a0, msg_close
	syscall
	
	sll $t2, $t1, 2 	# address pointer=i*4
	addu $t2, $t2, $s1	# add offset to the base address of the array
	li $v0, 1		# print the contents
	lw $a0, 0($t2)		
	syscall

	li $v0, 4		# print tab space
	la $a0, msg_tab
	syscall
	
	add $t1, $t1, 1		# jumps to the next element
	blt $t1, $s3, output	

	move $t1, $0		# reset i

	jr $ra

error_msg:
	li $v0, 4
	la $a0, msg_error
	syscall
	jr input_size


