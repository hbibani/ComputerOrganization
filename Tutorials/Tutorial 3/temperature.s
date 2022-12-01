# this programs asks for temperature in Fahrenheit
# and converts it to Celsius
# using formula Tc = (T-32)*5/9


  .text    
         .globl main  
main:                 # main has to be a global label
  addu  $s7, $0, $ra  # save return address in a global register
  
  
      # GETTING INPUT VALUE
  
  la $a0,input       # print_str (system call 4) 
  li $v0,4	     # print input
  syscall


      #READ INTEGER

  li $v0, 5	     #reads integer
	syscall
  
      # CALCULATING  
  
  addi $t0,$v0,-32    #  X - 32
  mul  $t0,$t0,5      # (X-32)*5
  div  $t0,$t0,9      # Tc = (X-32)*5/9

      # PRINTING

  # print string
  la $a0,result       
  li $v0,4            # print_str (system call 4) 
  syscall             # print result

  move $a0,$t0        
  li $v0,1            # print_int(system call 1) 
  syscall             # print X

  .data
input:  .asciiz "\n\nEnter temperature in Fahrenheit: "
result:  .asciiz "The temperature in Celsius is: "
  
  .text
  addu  $ra, $0, $s7 # restore the return address
  jr  $ra            # return to the main program
  add  $0, $0, $0    # nop (no operation)