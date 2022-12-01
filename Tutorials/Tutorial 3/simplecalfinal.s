# The main program is to perform calculation as per formula: f = (g+h) - (i - j + k)
# Variable f, g, h, i, j  and k are placed in registers $s0,$s1, $s2, $s3, $s4, $s5,
# 
#                        |                           |
#             list of variables          list of registers
#
#
  .data
  .globl  message  
message:  .asciiz "The value of f is: "   # saved in data segment
extra:    .asciiz "\nHave a nice day :)"  # saved in data segment
thankyou: .asciiz "\n\n\n ... Thank you :)"
  .align 2                  # align directive will be explained later

  .text
  .globl main
main:                       # main has to be a global label
  addu  $s7, $0, $ra        # save return address in a global register

        # CALCULATING

  addi  $s1, $0, 12         # g = 12
  addi  $s2, $0, -2         # h = -2
  addi  $s3, $0, 13         # i = 13
  addi  $s4, $0, 3          # j = 3
  addi  $s5, $0, 2          # k = 2
  add   $t0, $s1, $s2       # g + h = 12 + (-2)
  sub   $t1, $s3, $s4       # i - j = 13 - 3
  add   $t1, $t1, $s5       # i - j + k = 10 + 2
  sub   $s0, $t0, $t1       # f = 10 - 12

        # PRINTING
        
        # print string
  li    $v0, 4              # print_str (system call 4) 
  la    $a0, message        # Prints Message
  syscall
  
        # print Integer
  li    $v0, 1              # print_int (system call 1) 
  add   $a0, $0, $s0        # print f
  syscall
  
        # print string 
  li    $v0, 4              #  print_str (system call 4) 
  la    $a0, extra          #  print extra
  syscall

	 # print string 
  li    $v0, 4              #print_str (system call 4) 
  la    $a0, thankyou       #print thankyou 
  syscall
  
        # Usual stuff at the end of the main

  addu  $ra, $0, $s7        # restore the return address
  jr    $ra                 # return to the main program
  add   $0, $0, $0          # nop (no operation)