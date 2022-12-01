#lab06_3

# Pseudocode
# void main() {
#	print(message_ask_for_n);
#	read (n);
#	f=fib(n);
#	print(result);
#	return;
# {
#
# int fib(x) {
# 	int last_element;
#	if (x<2) {
#		last_element=0;		
#		return 1;
#	}
#	x--;
# 	return fib(x)+last_element;
# }	

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
	sub $sp, $sp, 8		# push registers into stack
	sw $a0, 0($sp)
	sw $ra, 4($sp)	

	bgt $a0, 2, call_fib	# keep recursing reaching the base case, then return 1
	add $v0, $0, 1
	j result

call_fib:			
	sub $a0, $a0, 1		# n decrease 1
	jal fib
	

result:
	lw $a0, 0($sp)		# pop registers from stack
	lw $ra, 4($sp)
	add $sp, $sp, 8

	move $t3, $v0		# swap $v0 and $t2, as a result, 
	move $v0, $t2		# $t2 stores F[n-1] and $v0 stores F[n-2]
	move $t2, $t3
	add $v0, $v0, $t2	# return F[n-1] + F[n-2]
	jr $ra
	
error:
	li $v0, 4		# display out of range error message
	la $a0, msg_error
	syscall
	j usr_input
