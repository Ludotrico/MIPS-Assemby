#                                           ICS 51, Lab #1
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                       DO NOT change anything outside the marked blocks.
# 
#
j main
###############################################################
#                           Data Section
.data
# 


new_line: .asciiz "\n"
space: .asciiz " "
triple_range_lbl: .asciiz "\nTrible range (Decimal Values) \nExpected output:\n240000 0 -300\nObtained output:\n"
swap_bits_lbl: .asciiz "\nSwap bits (Hexadecimal Values)\nExpected output:\n55555555 02138A9B FDEC7564\nObtained output:\n"
count_ones_lbl: .asciiz "\nCount ones \nExpected output:\n16 12 20\nObtained output:\n"

swap_bits_test_data:  .word 0xAAAAAAAA, 0x01234567, 0xFEDCBA98
swap_bits_expected_data:  .word 0x55555555, 0x02138A9B, 0xFDEC7564

triple_range_test_data: .word 80000, 111, 0, -111, 11
triple_range_expected_data: .word 240000, 0, -300

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                            PART 1 (Count Bits)
# 
# You are given an 32-bits integer stored in $t0. Count the number of 1's
#in the given number. For example: 1111 0000 should return 4
count_ones:
move $t0, $a0 
############################## Part 1: your code begins here ###
move $t5, $zero


meat:
beqz $t0, end
and $t1, $t0, 1

beq $t1, 1, increment
meat2:
srl $t0, $t0, 1
j meat

increment:
add $t5, $t5, 1
j meat2
end:
move $t0, $t5
############################## Part 1: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
###############################################################
#                            PART 2 (Swap Bits)
# 
# You are given an 32-bits integer stored in $t0. You need swap the bits
# at odd and even positions. i.e. b31 <-> b30, b29 <-> b28, ... , b1 <-> b0
# The result must be stored inside $t0 as well.
swap_bits:
move $t0, $a0 
############################## Part 2: your code begins here ###
move $t5, $zero
li $t7, 16		# loop 16 times


main1:
sll $t5, $t5, 1
li $t3, 0x40000000
and $t4, $t0, $t3
beqz $t4, main2
add $t5, $t5, 1

main2:
sll $t5, $t5, 1
li $t3, 0x80000000
and $t4, $t0, $t3
beqz $t4, looping
add $t5, $t5, 1

looping:
sll $t0, $t0, 2
sub $t7,$t7,1
bne $t7, $zero, main1

move $t0, $t5


############################## Part 2: your code ends here ###
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                           PART 3
# 
# You are given three integers. You need to find the smallest 
# one and the largest one and multiply their sum by three and return it.
# 
# Implementation details:
# The three integers are stored in registers $t0, $t1, and $t2. You 
# need to store the answer into register $t0. It will be returned by the
# function to the caller.

triple_range:
move $t0, $a0
move $t1, $a1
move $t2, $a2
############################### Part 3: your code begins here ##

#min stored in $t4
#max stores in $t5

move $t5, $t0
bgt $t1, $t5, set_1_max
bgt $t2, $t5, set_2_max
j find_min

set_1_max:
move $t5, $t1
bgt $t2, $t5, set_2_max
j find_min

set_2_max:
move $t5, $t2
j find_min




find_min:
move $t4, $t0
blt $t1, $t4, set_1_min
blt $t2, $t4, set_2_min
j calculate

set_1_min:
move $t4, $t1
blt $t2, $t4, set_2_min
j calculate

set_2_min:
move $t4, $t2
j calculate


calculate:
add $t6, $t5, $t4
li $t3, 3
mul $t0, $t6, $t3




############################### Part 3: your code ends here  ##
move $v0, $t0
jr $ra

###############################################################
###############################################################
###############################################################
#                          Main Function 
main:

li $v0, 4
la $a0, new_line
syscall
la $a0, count_ones_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p1:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal count_ones

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p1

li $v0, 4
la $a0, new_line
syscall
la $a0, swap_bits_lbl
syscall

# Testing part 2
li $s0, 3 # num of test cases
li $s1, 0
la $s2, swap_bits_test_data

test_p2:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
jal swap_bits

move $a0, $v0
jal print_hex
li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p2

li $v0, 4
la $a0, new_line
syscall
la $a0, triple_range_lbl
syscall


# Testing part 3
li $s0, 3 # num of test cases
li $s1, 0
la $s2, triple_range_test_data

test_p3:
add $s4, $s2, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 8($s4)
jal triple_range

move $a0, $v0        # $integer to print
li $v0, 1
syscall

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 4
addi $s0, $s0, -1
bgtz $s0, test_p3

_end:
# end program
li $v0, 10
syscall

