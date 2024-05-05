############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
.data
part1: .asciiz "#Part 1 Test Cases: \n"
part2: .asciiz "#Part 2 Test Cases: \n"
part3: .asciiz "#Part 3 Test Cases: \n"
part4: .asciiz "#Part 4 Test Cases: \n"
part5: .asciiz "#Part 5 Test Cases: \n"
hash: .asciiz "#"
null: .asciiz "NULL"
terms: .asciiz " terms in polynomial: "
x: .asciiz "x"
plus: .asciiz " plus "
newline: .asciiz "\n"
pairs1: .word 2 3 7 1 3 3 0 -1 0 9
pairs2: .word 9 1 7 6 3 4 0 -1 9 1 7 6 3 4 0 -1
pairs3: .word 2 3 3 1 0 -1 0 -1 9 8 8 8
pairs4: .word 4 2 7 0 0 -1 483
pairs5: .word 4 2 7 1 0 -1 284
pairs6: .word 2 3 7 1 0 -1 3 4 2 4
pairs7: .word -2 3 7 1 0 -1 0 69 69
pairs8: .word 2 3 -7 1 0 -1 1
pairs9: .word 2 3 3 1 14 5 7 0 0 -1 -239
pairs10: .word 2 5 -2 5 0 -1 -1
pairs102: .word 2 5 -2 5 0 -1 -1
pairs11: .word 8 9 4 5 3 10 -2 9 -5 5 1 5 -7 10 2 10 8 1 2 10 0 -1 89
pairs12: .word 8 9 4 5 -6 9 3 10 -2 9 -5 5 1 5 2 10 -7 10 -3 1 8 1 2 10 -5 1 0 -1 69420
pairs122: .word 8 9 4 5 -6 9 3 10 -2 9 -5 5 1 5 2 10 -7 10 -3 1 8 1 2 10 -5 1 0 -1 69420
pairs13: .word 1 2 3 4 5 6 7 8 0 -1
pairs14: .word 8 7 6 5 4 3 2 1 0 -1
pairs15: .word -2 3 3 3 -1 3 0 -1
pairs69: .word 6 9 6 9 6 9 6 9 6 9 6 9 6 9 6 9 6 9 6 9 6 9 6 9 -3 9 0 -1
invalidPair1: .word 0 8 9 7 2 3 0 -1 3 4
invalidPair2: .word 8 8 9 -7 2 3 0 -1 3 4 0 -1
invalidPair3: .word 0 -4 1 1 0 -1
badcoeff: .word 0
exp0: .word 0
coeff1: .word 1
exp1: .word 1
coeff2: .word 2
exp2: .word 2
coeff3: .word 3
exp7: .word 7
coeff256839: .word 256839
badexp1: .word -1
coeffneg1: .word -1
badexp2: .word -92034
coeffneg2: .word -2
exp87: .word 87
coeffneg3: .word -3
exp4: .word 4






.text
main:

 #Part 1 tests:
 #CHECK BREAKPOINTS IF YOU WANNA CHECK PART 1 TEST CASES BUT PART 1 IS SO EZ YOU SHOULDNT HAVE TO.
 
 li $v0, 4 
 la $a0, part1
 syscall
 
 lw $a0, badcoeff
 lw $a1, exp4
 jal create_term #coeff is 0 should return -1
 
 lw $a0, coeff1
 lw $a1, badexp1
 jal create_term #exp is <0 should return -1
 
 lw $a0, coeff256839
 lw $a1, badexp2
 jal create_term #exp is <0 should return -1
 
 lw $a0, coeff2
 lw $a1, exp4
 jal create_term #term created successfully should return 0x10040000
 
 lw $a0, coeffneg1
 lw $a1, exp4
 jal create_term #term created successfully should return 0x1004000c
 
 lw $a0, coeffneg3
 lw $a1, exp7
 jal create_term #term created successfully should return 0x10040018
 
 lw $a0, coeff256839
 lw $a1, exp1
 jal create_term #term created successfully should return 0x10040024
 
 lw $a0, coeffneg3
 lw $a1, exp7
 jal create_term #term created successfully should return 0x10040030
 
 #Part 2 tests:
 
 li $v0, 4 
 la $a0, part2
 syscall
 
 #1
 la $a0, pairs1
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #2
 la $a0, pairs2
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #3
 la $a0, pairs3
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #4
 la $a0, pairs4
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #5
 la $a0, pairs5
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #6
 la $a0, pairs6
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #7
 la $a0, pairs7
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #8
 la $a0, pairs8
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #9
 la $a0, pairs9
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #10
 la $a0, pairs10
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #11
 la $a0, pairs11
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #12
 la $a0, pairs12
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #13
 la $a0, pairs15
 jal create_polynomial
 move $a0, $v0
 jal print
 
 #14
 la $a0, invalidPair1
 jal create_polynomial
 move $a0, $v0
 jal print #should just print null
 
 #15
 la $a0, invalidPair2
 jal create_polynomial
 move $a0, $v0
 jal print #should just print null
 
 #16
 la $a0, invalidPair3
 jal create_polynomial
 move $a0, $v0
 jal print #should just print null
 
 
 #Part 3 tests:
 
 li $v0, 4 
 la $a0, part3
 syscall
 
 #1
 la $a0, pairs1
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #2
 la $a0, pairs2
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #3
 la $a0, pairs3
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #4
 la $a0, pairs4
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #5
 la $a0, pairs5
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #6
 la $a0, pairs6
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #7
 la $a0, pairs7
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #8
 la $a0, pairs8
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #9
 la $a0, pairs9
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #10
 la $a0, pairs102
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #11
 la $a0, pairs11
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #13
 la $a0, pairs122
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #14
 la $a0, pairs13
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #15
 la $a0, pairs14
 jal create_polynomial

 move $a0, $v0
 jal sort_polynomial
 jal print
 
 #Part 4 tests:
 
 li $v0, 4 
 la $a0, part4
 syscall
 
 #1
 la $a0, pairs3
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs4
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #2
 la $a0, pairs3
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs5
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #3
 la $a0, pairs3
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs7
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #4
 la $a0, pairs7
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs8
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #5
 la $a0, pairs1
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs2
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #6
 la $a0, pairs14
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs13
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #7
 la $a0, invalidPair1
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs13
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #7
 la $a0, pairs69
 jal create_polynomial
 move $s0, $v0

 la $a0, invalidPair3
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #8
 la $a0, invalidPair3
 jal create_polynomial
 move $s0, $v0

 la $a0, invalidPair3
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal add_polynomial
 jal print
 
 #Part 5 tests:
 
 li $v0, 4
 la $a0, part5
 syscall
 
 #1
 la $a0, pairs1
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs2
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 
 #2
 la $a0, pairs3
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs4
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 
 #3
 la $a0, pairs3
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs5
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #4
 la $a0, pairs6
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs7
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #5
 la $a0, pairs7
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs8
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #6
 la $a0, pairs69
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs13
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #7
 la $a0, pairs15
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs1
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #8
 la $a0, invalidPair1
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs1
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #9
 la $a0, pairs1
 jal create_polynomial
 move $s0, $v0

 la $a0, invalidPair1
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #10
 la $a0, invalidPair3
 jal create_polynomial
 move $s0, $v0

 la $a0, invalidPair2
 jal create_polynomial
 move $s1, $v0
 
 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 #11
 la $a0, pairs13
 jal create_polynomial
 move $s0, $v0

 la $a0, pairs14
 jal create_polynomial
 move $s1, $v0

 move $a0, $s0
 move $a1, $s1
 jal mult_polynomial
 jal print
 
 j skippidydippitydoo
 print:
  move $t1, $v0
  li $v0, 4
  la $a0, hash
  syscall
  move $v0, $t1
  beq $v0, $0, printNull
  lw $t0, 0($v0)
  lw $a0, 4($v0)
  li $v0, 1
  syscall
  li $v0, 4
  la $a0, terms
  syscall
  mult1:
   beq $t0, $0, mult1done
   li $v0, 1
   lw $a0, 0($t0)
   syscall 
   li $v0, 4
   la $a0, x
   syscall
   li $v0, 1
   lw $a0, 4($t0)
   syscall 
   li $v0, 4
   la $a0, plus
   syscall
   lw $t0, 8($t0)
   j mult1
  mult1done:
  printNull:
  li $v0, 4
  la $a0, null
  syscall
  li $v0, 4
  la $a0, newline
  syscall
 jr $ra
 skippidydippitydoo:
 
#CHECK YOU PROGRAM PRINTS THE FOLLOWING:

#Part 1 Test Cases: 
#Part 2 Test Cases: 
#2 terms in polynomial: 5x3 plus 7x1 plus NULL
#3 terms in polynomial: 9x1 plus 7x6 plus 3x4 plus NULL
#2 terms in polynomial: 2x3 plus 3x1 plus NULL
#2 terms in polynomial: 4x2 plus 7x0 plus NULL
#2 terms in polynomial: 4x2 plus 7x1 plus NULL
#2 terms in polynomial: 2x3 plus 7x1 plus NULL
#2 terms in polynomial: -2x3 plus 7x1 plus NULL
#2 terms in polynomial: 2x3 plus -7x1 plus NULL
#4 terms in polynomial: 2x3 plus 3x1 plus 14x5 plus 7x0 plus NULL
#0 terms in polynomial: NULL
#2 terms in polynomial: 6x9 plus 8x1 plus NULL
#0 terms in polynomial: NULL
#0 terms in polynomial: NULL
#NULL
#NULL
#NULL
#Part 3 Test Cases: 
#2 terms in polynomial: 5x3 plus 7x1 plus NULL
#3 terms in polynomial: 7x6 plus 3x4 plus 9x1 plus NULL
#2 terms in polynomial: 2x3 plus 3x1 plus NULL
#2 terms in polynomial: 4x2 plus 7x0 plus NULL
#2 terms in polynomial: 4x2 plus 7x1 plus NULL
#2 terms in polynomial: 2x3 plus 7x1 plus NULL
#2 terms in polynomial: -2x3 plus 7x1 plus NULL
#2 terms in polynomial: 2x3 plus -7x1 plus NULL
#4 terms in polynomial: 14x5 plus 2x3 plus 3x1 plus 7x0 plus NULL
#0 terms in polynomial: NULL
#2 terms in polynomial: 6x9 plus 8x1 plus NULL
#0 terms in polynomial: NULL
#4 terms in polynomial: 7x8 plus 5x6 plus 3x4 plus 1x2 plus NULL
#4 terms in polynomial: 8x7 plus 6x5 plus 4x3 plus 2x1 plus NULL
#Part 4 Test Cases: 
#4 terms in polynomial: 2x3 plus 4x2 plus 3x1 plus 7x0 plus NULL
#3 terms in polynomial: 2x3 plus 4x2 plus 10x1 plus NULL
#1 terms in polynomial: 10x1 plus NULL
#0 terms in polynomial: NULL
#4 terms in polynomial: 7x6 plus 3x4 plus 5x3 plus 16x1 plus NULL
#8 terms in polynomial: 7x8 plus 8x7 plus 5x6 plus 6x5 plus 3x4 plus 4x3 plus 1x2 plus 2x1 plus NULL
#4 terms in polynomial: 7x8 plus 5x6 plus 3x4 plus 1x2 plus NULL
#1 terms in polynomial: 69x9 plus NULL
#0 terms in polynomial: NULL
#Part 5 Test Cases: 
#5 terms in polynomial: 35x9 plus 64x7 plus 21x5 plus 45x4 plus 63x2 plus NULL
#3 terms in polynomial: 8x5 plus 26x3 plus 21x1 plus NULL
#4 terms in polynomial: 8x5 plus 14x4 plus 12x3 plus 21x2 plus NULL
#2 terms in polynomial: -4x6 plus 49x2 plus NULL
#3 terms in polynomial: -4x6 plus 28x4 plus -49x2 plus NULL
#4 terms in polynomial: 483x17 plus 345x15 plus 207x13 plus 69x11 plus NULL
#0 terms in polynomial: NULL
#0 terms in polynomial: NULL
#0 terms in polynomial: NULL
#0 terms in polynomial: NULL
#7 terms in polynomial: 56x15 plus 82x13 plus 82x11 plus 60x9 plus 28x7 plus 10x5 plus 2x3 plus NULL

exit:
 li $v0, 10
 syscall

.include "hw5.asm"