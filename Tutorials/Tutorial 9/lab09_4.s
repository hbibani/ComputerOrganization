.data
msg1:   .asciiz "\n\nStart entering characters: \n"   # string to print
msg2: .asciiz "\nTotal number of characters = "  # string to print
terminator:  .ascii "\n"
buffer: .space 6


.text
.globl main
main:                          # main has to be a global label
     addu $s7, $0, $ra         # save the return address in a global register

    li  $v0, 4                 # print_str
    la  $a0, msg1              # takes address of string as argument
    syscall

    lui  $t0, 0xffff           # load ffff0000 in $t0
    la $s2, buffer	       # load base address of buffer
    lbu  $s3, terminator       # load terminating character

readloop1:
    move $s4, $zero	       # buffer counter reset
    
readloop2:
    li   $s1, 6		       # $s1 stores buffer size in byes
    lw   $t1, 0($t0)           # receiver control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero,readloop2  # if not ready	    
    lw   $s0, 4($t0)           # receiver data
    beq  $s0, $s3, writeloop1  # check terminate character

    add $t4, $s4, $s2	       # calculate the buffer address
    sb $s0, ($t4)	       # save the input character in buffer
    add $s4, $s4, 1	       # buffer counter increases 1
    add $s5, $s5, 1	       # $s5 stores total number of characters
    bne $s4, $s1, readloop2    # if buffer is not full, go back and wait for new inputs 

    move $s4, $zero	       # buffer counter reset
    j writeloop2	       # buffer is full, display the characters

writeloop1:
    beq $s4, $0, exit
    move $s1, $s4	       # number of characters to read
    move $s4, $zero	       # buffer counter reset

writeloop2:
    lw  $t1, 8($t0)            # transmitter control
    andi $t1, $t1,0x0001       # check if ready
    beq  $t1, $zero, writeloop2  # if not ready

    add $t4, $s4, $s2	       # calculate the buffer address
    lbu $s0, ($t4)	       # load characters from buffer
    sw  $s0, 12($t0)           # transmit data to console
    add $s4, $s4, 1	       # buffer offset increases 1
    bne $s4, $s1, writeloop2   # continue until reaching the last character in buffer 
	
    beq $s4, 6, readloop1      # if buffer counter != buffer size, which means 				       # terminator character is not received, program continues

exit:    
    li  $v0, 4                 # print_str
    la  $a0, msg2              # takes address of string as argument
    syscall

    li $v0, 1                 # print total number of characters entered
    move $a0, $s5
    syscall

             # Usual stuff at the end of the main
    addu $ra, $0, $s7	       # restore the return address
    jr  $ra                    # return to the main program
    add $0, $0, $0             # nop
