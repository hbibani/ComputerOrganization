#lab04.4.s

.data
.align 2

Z: .space 400

msg_input_k: .asciiz "\n\nPlease input k (0-99): "
msg_input_m: .asciiz "\nPlease input m (0-99): "
msg_result: .asciiz "\nThe result of Z[k]+Z[k+m] is: "

.text
.globl main
main:

add $s7, $0, $ra

li $t1, 0 		# i=0


# Load Z[0]=0, Z[1]=1, Z[2]=2 ... Z[99]=99
loop: 
la $t0, Z 		# load base address of Z, Z[0]
sll $t2, $t1, 2 	# i*4
add $t2, $t2, $t0 	# i*4 + Z[0]
sw $t1, 0($t2) 		# initialize Z

add $t1, $t1, 1 	# i += 1
bne $t1, 100, loop 	# if i != 100, goto loop

add $s1, $0, $t0	# $s1 gets the base address of Z

li $v0, 4
la $a0, msg_input_k
syscall			# print message to ask for k

li $v0, 5
syscall
add $t2, $0, $v0	# $t2 gets k

# input m
li $v0, 4
la $a0, msg_input_m
syscall			# print message to ask for m

li $v0, 5
syscall
add $t3, $0, $v0	# $t3 gets m

# Load Z[k]
sll $t2, $t2, 2  	# k*4
add $t2, $t2, $s1 	# $t2 points to Z[k]
lw $s2, 0($t2) 		# $s2 gets Z[k]

# Load Z[k+m]
sll $t3, $t3, 2		# m*4
add $t3, $t3, $t2	# $t3 points to Z[k+m]
lw $s3, 0($t3)		# $s3 gets Z[k+m]

#Calculate and store the result in Z[12]
add $s4, $s2, $s3	# $s4 gets Z[k]+Z[k+m]
sw $s4, 48($s1)		# store the result in Z[12], 48 bytes + base address of Z

#Print the result
li $v0, 4
la $a0, msg_result
syscall			# print the result message

li $v0, 1
add $a0, $0, $s4
syscall			# print the result


add $ra, $0, $s7
jr $ra

	

