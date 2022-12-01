.data
.align 2
msg1:   .asciiz "\nStart entering characters: \n"   # string to print
msg2: .asciiz "\nProgram terminated\n"  # string to print
buffer: .space 6


.text
.globl main
main:                          # main has to be a global label
    addu $s7, $0, $ra          # save the return address in a global register

    li  $v0, 4                 # print_str
    la  $a0, msg1              # takes address of string as argument
    syscall

    li  $t0, 0xffff            # first place 0000ffff in $t0
    sll $t0, $t0, 16           # so we now have ffff0000 in $t0

    li $s1, 6		       # $s1 stores buffer size in byes
    la $s2, buffer	       # load base address of buffer

    move $t3, $zero	       # buffer counter and offset
readloop:
    lw   $t1, 0($t0)           # receiver control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero,readloop   # if not ready	
    
    lw   $s0, 4($t0)           # receiver data
    add $t4, $t3, $s2	       # calculate the buffer address
    sb $s0, ($t4)
    add $t3, $t3, 1	       # buffer counter increases one
    bne $t3, $s1, readloop

    move $t3, $zero	       # buffer counter and offset
writeloop:
    lw  $t1, 8($t0)            # transmitter control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero, writeloop  # if not ready

    add $t4, $t3, $s2
    lb $s0, ($t4)
    sw   $s0, 12($t0)          # transmit data
    add $t3, $t3, 1
    bne $t3, $s1, writeloop
	
exit:
    li  $v0, 4                 # print_str
    la  $a0, msg2              # takes address of string as argument
    syscall

             # Usual stuff at the end of the main
    addu	$ra, $0, $s7       # restore the return address
    jr  $ra                    # return to the main program
    add $0, $0, $0             # nop
