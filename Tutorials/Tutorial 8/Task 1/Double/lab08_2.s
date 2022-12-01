.data
msg_input_T: .asciiz "\n\nInput T: "
msg_input_N: .asciiz "\nInput N (0-20): "
msg_input_t2: .asciiz "\nInput t2: "
msg_result: .asciiz "\nSpeedup = "
msg_error: .asciiz "Out of range. Please try again."

T: .double 0.0
N: .double 0.0
t2: .double 0.0
result: .double 0.0
#hundred: .double 100.0

.text
.globl main

main:
move $s7, $ra

li $v0, 4		# print message to read T
la $a0, msg_input_T
syscall

li $v0, 7		# read T
syscall
s.d $f0, T		# store T into memory

input_N:
li $v0, 4		# print message to read N
la $a0, msg_input_N
syscall

li $v0, 7		# read N
syscall

li.d $f10, 0.0		# if N < 0, print error message and ask to retry
c.lt.d $f0, $f10
bc1t error

li.d $f10, 20.0		# if N > 20, print error message and ask to retry
c.lt.d $f10, $f0
bc1t error

s.d $f0, N		# store N into memory

li $v0, 4		# print message to read t2
la $a0, msg_input_t2
syscall

li $v0, 7		# read t2
syscall
s.d $f0, t2		# store t2 into memory

la $a0, T		# pass the references of variables
la $a1, N
la $a2, t2
la $a3, result

jal cal

li $v0, 4		# print the result
la $a0, msg_result
syscall

li $v0, 3
l.d $f12, result
syscall

move $ra, $s7		# program ends
jr $ra
nop

cal:
l.d $f2, 0($a0)		# $f2 gets T
l.d $f4, 0($a1)		# $f4 gets N
l.d $f6, 0($a2)		# $f6 gets t2

div.d $f8, $f6, $f4	# calcualtion - speedup = T / (T - t2 + t2/N)
add.d $f8, $f8, $f2	
sub.d $f8, $f8, $f6 
div.d $f8, $f2, $f8

s.d $f8, 0($a3)		# stores the result

jr $ra

error:
li $v0, 4
la $a0, msg_error
syscall
j input_N







