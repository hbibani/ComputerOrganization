.data
msg_fp_fraction: .asciiz "\n\nFP Fraction"
msg_speedup: 	.asciiz "Speedup\n"
msg_delimiter: 	.asciiz " | "
msg_newline: 	.asciiz "\n"
msg_percent:	.asciiz "%"
msg_dot:	.asciiz "."

x: 	.double 0.0
y: 	.double 0.0

.text
.globl main

main:
move $s7, $ra

li $v0, 4		# print 1st column header
la $a0, msg_fp_fraction
syscall

li $v0, 4		# print delimiter
la $a0, msg_delimiter
syscall

li $v0, 4		# print 2nd column header
la $a0, msg_speedup
syscall

cal_print:
la $a0, x		# pass the references of variables
la $a1, y
jal cal

# print the result
l.d $f2, x		# $f2 gets x
l.d $f12, y		# $f12 gets y
li.d $f4, 0.1
li.d $f6, 1.0
li.d $f8, 100.0

li $v0, 1		# print x
mov.d $f10, $f2
mul.d $f10, $f10, $f8
round.w.d $f10, $f10
mfc1 $a0, $f10
syscall

li $v0, 4		# print percent sign
la $a0, msg_percent
syscall

li $v0, 4		# print delimiter
la $a0, msg_delimiter
syscall

mul.d $f12, $f12, $f8	# calculate and print the integer portion of y
round.w.d $f12, $f12
mfc1 $t1,$f12
div $t1, $t1, 100
mflo $s1
mfhi $s2
li $v0, 1
move $a0, $s1
syscall

li $v0, 4		# print a dot
la $a0, msg_dot
syscall

div $s2, $s2, 10	# calculate and print the decimal portion of y
mflo $s1
mfhi $s2
li $v0, 1		
move $a0, $s1
syscall
li $v0, 1
move $a0, $s2
syscall

li $v0, 4
la $a0, msg_newline
syscall

add.d $f2, $f2, $f4	# increase x by 0.1
s.d $f2, x		# save x into memory
c.le.d $f2, $f6		# branch if x <= 1
bc1t cal_print

# program ends
move $ra, $s7
jr $ra
nop

cal:
l.d $f2, 0($a0)		# $f2 gets x

# calcualtion - y = 1 / (1 - 0.8 * x)
li.d $f6, 0.8
li.d $f8, 1.0
mul.d $f6, $f6, $f2
sub.d $f6, $f8, $f6 
div.d $f6, $f8, $f6

s.d $f6, 0($a1)		# store and return the result

jr $ra







