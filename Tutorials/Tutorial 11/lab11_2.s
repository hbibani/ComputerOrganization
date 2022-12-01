 .text
  .globl main
main:                        # main has to be a global label
    addu $s7, $0, $ra        # save the return address in a global register
#------------------------------------ getting a
    .data
    .globl  message1
message1:  .asciiz "\nInput 0 or 1 for a: "  #string to print
    .text
input_1:
    li   $v0, 4              # print_string (system call 4)
    la   $a0, message1       # takes the address of string as an argument 
  syscall  
    li   $v0, 5              # read_int (system call 5) 
    syscall              
    move $s3, $v0	     # move to $s3
    move $a0, $v0 	     # validate input number
    jal validate_num
    bne $v0, $0, input_1     # if not return 0, it's an invalid number
#------------------------------------ getting b
    .data
    .globl  message2
message2:  .asciiz "Input 0 or 1 for b: "  #string to print
    .text
input_2:
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message2       # takes the address of string as an argument 
    syscall  
    li   $v0, 5              # read_int (system call 5)
    syscall          
    move $s4, $v0            # move to $s4
    move $a0, $v0 	     # validate input number
    jal validate_num
    bne $v0, $0, input_2     # if not return 0, it's an invalid number
#----------------------------------- calculating (a AND b)
    and  $t0, $s3, $s4       # register $t0 contains (a AND b)
#----------------------------------- printing a AND b on the console
    .data
    .globl message3  
message3:  .asciiz "           a AND b: "  # string to print
message4:  .asciiz "\n---------------------" # next string to print
    .text
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message3       # takes the address of string as an argument 
    syscall
    li   $v0, 1              # print_int (system call 1)
    add  $a0, $0, $t0        # put value to print in $a0
    syscall  
    li   $v0, 4              # print_str (system call 4)
    la   $a0, message4       # takes the address of string as an argument 
    syscall
    j  input_1               # back to calculating  
    .data
msg_error: .asciiz "\nMust be 0 or 1! Please try again.\n"
    .text
validate_num:
    sub $sp, $sp, 4	     # preserve $a0 into stack
    sw $a0, ($sp)
    blt $a0, $0, invalid      # invalid number if <0 or >1
    bgt $a0, 1, invalid   
    move $v0, $0	     # return 0, it is an valid number
    j valid 
invalid:
    li $v0, 4		    # print error message
    la $a0, msg_error
    syscall
    add $v0, $0, -1	     # return -1, it is an invalid number
valid:   
    lw $a0, ($sp)	     # restore $a0 from stack
    add $sp, $sp, 4
    jr $ra
#----------------------------------- usual stuff at the end of the main
end:
    addu $ra, $0, $s7        # restore the return address
    jr   $ra                 # return to the main program
    nop
