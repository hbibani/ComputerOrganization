# The main program is to perform calculation as per formula: f = (a+b) - (c-d)
# 
# 
# The program places variables, f, a, b, c and d in registers $s0, $s1, $s2, $s3 and $s4 respectively. 
#                                               
#        
#
#
  .data
  .globl  message  


message:  .asciiz "The value of f is: "   # Ascii characters stored in memory(data segment)
extra:    .asciiz "\nHave a nice day :)"  # Ascii characters stored in memory(data segment)
thankyou: .asciiz "\n\n\n ... Thank you :)" #Ascii characters stored in memory(data segment)

  .align 2                  # align directive will be explained later

  .text
  .globl main
main:                       # main has to be a global label
  addu  $s7, $0, $ra        # save return address in a global register

        # CALCULATING

  addi  $s1, $0, 12         # a = 12
  addi  $s2, $0, -2         # b = -2
  addi  $s3, $0, 13         # c = 13
  addi  $s4, $0, 3          # d = 3
  add   $t0, $s1, $s2       # a  +  b = 12-2
  sub   $t1, $s3, $s4       # c - d = 13 - 3
  sub   $s0, $t0, $t1       # f = 10 - 10

        # PRINTING
        
        # print string
  li    $v0, 4              # print_str (system call 4) 
  la    $a0, message        # $a0 loads address of message(for printing)
  syscall
  
        # print Integer
  li    $v0, 1              # print_int (system call 1) 
  add   $a0, $0, $s0        # $a0 contains f = 0 (contained in $s0, for printing)
  syscall
  
        # print string
  li    $v0, 4              # print_str (system call 4) 
  la    $a0, extra          # $a0 loads address of message(for printing)
  syscall

  li    $v0, 4              #print_str (system call 4) 
  la    $a0, thankyou       # $a0 loads address of thankyou(for printing)
  syscall
  
        # Usual stuff at the end of the main

  addu  $ra, $0, $s7        # restore the return address
  jr    $ra                 # return to the main program
  add   $0, $0, $0          # nop (no operation)