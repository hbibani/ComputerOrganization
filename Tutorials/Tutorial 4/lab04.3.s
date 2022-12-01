#lab04.3.s

.data
.align 2

X: .word 0
Z: .word 0, 1, 2, 3, 4, 5, 6, 7, 8, 9

.text
.globl main
main:

add $s7, $0, $ra

# Calculate Z[3]-Z[5] and store into X

la $s1, Z 		# load base address of Z, Z[0]
lw $s2, 12($s1) 	# $s2=Z[3]
lw $s3, 20($s1) 	# $s3=Z[5]
sub $t1, $s2, $s3 	# X=Z[3]-Z[5]
sw $t1, X		# store the result into X

add $ra, $0, $s7
jr $ra



