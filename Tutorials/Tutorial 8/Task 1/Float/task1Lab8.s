.data

message1: .asciiz "Enter a value for T(total execution time):"
message2: .asciiz "\nEnter T2: "
message3: .asciiz "\nEnter the enhancement (N) [please pick a value between 0-20]:"
message4: .asciiz  "\nThe total speed up after the enhancement is: "
message5: .asciiz  "\nThat was an invalid value [please pick a number between 0 - 20]: "


T: .float 0.0
T2: .float 0.0
N: .float 0.0
speedup: .float 0.0
MAX: .float 20.0
MIN: .float 0.0

.text
.globl main
main: 

	l.s $f10, MIN
	l.s $f11, MAX
	
  

input:
	li $v0, 4
	la $a0, message1
	syscall

	li $v0, 6
	syscall
        s.s $f0, T

	li $v0, 4
	la $a0, message2
	syscall

	li $v0, 6
	syscall
	s.s $f0, T2		#$f2 = T2

	li $v0, 4
	la $a0, message3
	syscall

	li $v0, 6
	syscall
	mov.s $f3, $f0

	j looptest


redo: 
	li $v0, 4
	la $a0, message5
	syscall

	li $v0, 6
	syscall
	mov.s $f3, $f0		#$f3 = floaiting point enhancment

looptest:
	c.le.s $f3, $f10
	bc1t redo
	c.lt.s $f3, $f11
	bc1f redo
	
	s.s $f0, N

loopOut:

	la $a1, speedup
	la $a0, T
	la $a2, T2
        la $a3, N

        jal calculation
	li $a0, 0
	
	l.s $f8, 0($a1)

Print: 
	li $v0, 4
	la $a0, message4
	syscall

	li $v0, 2
	add.s $f12, $f12, $f8
	syscall

Exit:
	li $v0, 10
	syscall

calculation:
	l.s $f1, 0($a0)
	l.s $f2, 0($a2)
	l.s $f3, 0($a3)

  	sub.s $f4, $f1, $f2	      #t1 = T - t2
  	div.s $f5, $f2, $f3           #t'2 = t2/N
  	add.s $f6, $f4, $f5	      #T' = t1 + t'2
  	div.s $f8, $f1, $f6           #Speedup

 	s.s $f8, 0($a1)

  	jr $ra                         #return Address
 




