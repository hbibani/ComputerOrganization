#lab06_1

.data
msg_input: .asciiz "\n\nPlease input n (2-45) for Fib[n]: " 
msg_error: .asciiz "\nOut of range, please try again."
msg_output1: .asciiz "\nFib["
msg_output2: .asciiz "]= "

.text
.globl main

main:
	move $s7, $ra		# save return address in global register

usr_input:	
	li $v0, 4		# print message for user input
	la $a0, msg_input
	syscall

	li $v0, 5		# ask for n
	syscall
	
	blt $v0, 2, error	# validate n
	bgt $v0, 45, error
	
	move $s1, $v0		# $s1 stores n

	move $a0, $v0		# pass n to fib
	jal fib			# go to the calculation
	
# Print the result
	move $s2, $v0		# $s2 stores the returned result	
	
	li $v0, 4		# print the result with the messages
	la $a0, msg_output1
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	li $v0, 4
	la $a0, msg_output2
	syscall
	li $v0, 1
	move $a0, $s2
	syscall

	move $ra, $s7		# program ends	
	jr $ra

fib:				
	move $v0, $0		# initialize $v0 for storing the sum
	move $t1, $a0		# $t1 stores n
	addu $t3, $0, 1

add_up:
	move $t2, $t3		# move F[n-1] to F[n-2]
	move $t3, $v0		# move F[n] to F[n-1]
	add $v0, $t3, $t2	# F[n]=F[n-1]+F[n-2]
	
	sub $t1, $t1, 1		# n decreases 1
	bgt  $t1, $0, add_up	# continue the loop until n reaching zero

	jr $ra
	
error:
	li $v0, 4		# display out of range error message
	la $a0, msg_error
	syscall
	j usr_input
