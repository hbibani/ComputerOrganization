#lab06_2

.data
msg_input: .asciiz "\n\nPlease input n (2-50) for Fib[n]: " 
msg_error: .asciiz "\nOut of range, please try again."
msg_output1: .asciiz "\nFib["
msg_output2: .asciiz "]= "
#result: .double 0.0  # option 2: return the result by store it into memory

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
	bgt $v0, 50, error	
	
	move $s1, $v0		# $s1 stores n
	move $a0, $v0		# pass n to fib
	jal fib			# go to the calculation
	
# Print the result
	mtc1.d $v0, $f12	# $f12 stores the returned result for print
	li $v0, 4		
	la $a0, msg_output1
	syscall
	li $v0, 1
	move $a0, $s1
	syscall
	li $v0, 4
	la $a0, msg_output2
	syscall
	li $v0, 3
	syscall

	
	#li $v0, 4	# option 2: return the result by store it into memory	
	#la $a0, msg_output1
	#syscall
	#li $v0, 1
	#move $a0, $s1
	#syscall
	#li $v0, 4
	#la $a0, msg_output2
	#syscall
	#li $v0, 3
	#l.d $f12, result
	#syscall


	move $ra, $s7		# program ends	
	jr $ra

fib:
	move $t1, $a0		# $t1 stores n	
	move $v0, $0		# initialize $v0 for storing the sum
	addu $t2, $0, 1		# pass F[1] to fib, which is 1		
	mtc1 $t2, $f4		# passing F[1] to $f4 for storing the sum, F[n]=F[n-1]+F[n-2]
	cvt.d.w $f4, $f4	# convert the data type to double precision floating point

add_up:	
	mov.d $f2, $f4		# move F[n-1] to F[n-2]
	mov.d $f4, $f6		# move F[n] to F[n-1]
	add.d $f6, $f4, $f2	# F[n] = F[n-1] + F[n-2]

	sub $t1, $t1, 1		# n decreases 1
	bgt  $t1, $0, add_up	# continue the loop until n reaching zero

#	s.d $f6, result		# option 2: return the result by store it into memory

	mfc1.d $v0, $f6		# returns the result to $v0, $v1
	jr $ra
	
error:
	li $v0, 4		# display out of range error message
	la $a0, msg_error
	syscall
	j usr_input
