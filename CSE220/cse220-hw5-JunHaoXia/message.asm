##########
# TEST  DATA #
##########

.data
NULL: .word 0 -1
bullet: .asciiz " - "
comma: .asciiz ", "
test_case: .word 0
test_running: .asciiz "Running test case #"
test_failed: .asciiz "test failed!"
test_return_value: .asciiz "return value "
test_expected: .asciiz "expected: "
test_unexpected: .asciiz "unexpected value: "
test_not_word_aligned: .asciiz "address not word-aligned! "

printing_term_coeff: .asciiz "coefficient "
printing_term_exp: .asciiz "exponent "
printing_term_next: .asciiz "next term "

printing_polynomial_no_of_terms: .asciiz "no_of_terms "

printing_stack_error: .asciiz "Error with stack: at least one $s register was not preserved properly.\n"


#######
# Macros #
#######

.macro ss (%reg)
# Stores the given register to the stack.
addi $sp, $sp, -4
sw %reg, 0($sp)
.end_macro

.macro rs (%reg)
# Pops from the stack and restores to the given register.
lw %reg, 0($sp)
addi $sp, $sp, 4
.end_macro

.macro syscalli (%v0i)
# Performs syscall with a one-line macro and a provided immediate for $v0.
li $v0, %v0i
syscall
.end_macro

.macro exit ()
# Exits the program.
syscalli 10
.end_macro


##############
#    Testing Macros    #
##############

.macro print_int (%int)
# Prints int from the given register.
move $a0, %int
syscalli 1
.end_macro

.macro print_char (%char)
# Prints char from the least significant byte of the given register.
move $a0, %char
syscalli 11
.end_macro

.macro print_ln ()
li $a0, 0xA
print_char $a0
.end_macro

.macro print_str (%label)
# Prints the string from the given label.
la $a0, %label
syscalli 4
.end_macro

.macro print_str_ln (%label)
# Prints string and a newline.
print_str %label
print_ln
.end_macro

.macro print_bullet ()
print_str bullet
.end_macro

.macro test_stack_store ()
# Stores 1000 to all $s registers to the stack.
li $t0, 1000
move $s0, $t0
move $s1, $t0
move $s2, $t0
move $s3, $t0
move $s4, $t0
move $s5, $t0
move $s6, $t0
move $s7, $t0
.end_macro

.macro test_stack_check ()
# Checks if 1000 is present in all $s registers.
li $t0, 1000
bne $s0, $t0, test_stack_check_if1
bne $s1, $t0, test_stack_check_if1
bne $s2, $t0, test_stack_check_if1
bne $s3, $t0, test_stack_check_if1
bne $s4, $t0, test_stack_check_if1
bne $s5, $t0, test_stack_check_if1
bne $s6, $t0, test_stack_check_if1
bne $s7, $t0, test_stack_check_if1
j test_stack_check_if1_done
test_stack_check_if1:
	print_str printing_stack_error
test_stack_check_if1_done:
.end_macro

.macro print_test_run ()
# Prints the test case being run, indicated by $s0.
print_bullet
print_str test_running
la $t0, test_case
lw $t1, 0($t0)
print_int $t1
addi $t1, $t1, 1
sw $t1, 0($t0)
print_bullet
print_ln
.end_macro

.macro print_test_failed (%unexpected_val)
# Prints that a test case failed with an unexpected value.
ss $s0
move $s0, %unexpected_val
print_str test_failed
print_bullet
print_str test_unexpected
print_int $s0
print_ln
rs $s0
.end_macro

.macro print_test_failed (%unexpected_val, %expected_val)
# Prints that a test case failed with an expected value and what was gotten instead.
ss $s0
ss $s1
move $s0, %unexpected_val
move $s1, %expected_val
print_str test_failed
print_bullet
print_str test_unexpected
print_int $s0
print_bullet
print_str test_expected
print_int $s1
print_ln
rs $s1
rs $s0
.end_macro


######
# MAIN #
######

.macro set_test_case (%numi)
# Sets test case to %numi immediate.
li $t0, %numi
la $t1, test_case
sw $t0, 0($t1)
.end_macro

.macro test_return (%val, %expected_vali)
# Tests if a return value matches the expected immediate.
# Prints an error if they do not match.
move $t0, %val
li $t1, %expected_vali
beq $t0, $t1, test_return_if_1
print_str test_return_value
print_test_failed $t0, $t1
test_return_if_1:
.end_macro

.macro test_return_not (%val, %not_expected_vali)
# Tests if a return value matches the given immediate.
# Prints an error if they DO match.
move $t0, %val
li $t1, %not_expected_vali
bne $t0, $t1, test_return_not_if_1
print_str test_return_value
print_test_failed $t0
test_return_not_if_1:
.end_macro

.macro test_create_term (%a0i, %a1i)
# Tests create_term expecting a return value of -1.
# %a0i: $a0 immediate; %a1i: $a1 immediate
# $v0 will contain the return value of create_term in case of further evaluation.
print_test_run
li $a0, %a0i
li $a1, %a1i
jal create_term
ss $v0
test_return $v0, -1	
test_stack_check
rs $v0
.end_macro

.macro test_create_term (%a0i, %a1i, %check_term_label)
# Tests creating a term expecting a valid address to the created Term
# and checks it against a predefined one.
# %a0i: $a0 immediate; %a1i: $a1 immediate;
# %check_term_label: Label of expected Term value to use in check_term.
# $v0 will contain the return value of create_term in case of further evaluation.
print_test_run
li $a0, %a0i
li $a1, %a1i
jal create_term
ss $v0
move $a0, $v0
la $a1, %check_term_label
jal check_term
test_stack_check
rs $v0
.end_macro

.macro test_create_polynomial (%terms_label)
# Tests creating a polynomial and expects a NULL return value.
# %terms_label: an invalid list of terms to create polynomial from
# $v0 will contain the return value of create_term in case of further evaluation.
print_test_run
la $a0, %terms_label
jal create_polynomial
ss $v0
test_return $v0, 0
test_stack_check
rs $v0
.end_macro
	
.macro test_create_polynomial (%terms_label, %expected_terms_label)
# Tests creating a polynomial and checks it against an expected array of terms.
# %terms_label: list of terms to create polynomial from;
# %expected_terms_label: list of expected term values of polynomial - can vary from terms array
#  if terms were combined 
# $v0 will contain the return value of create_polynomial in case of further evaluation.
print_test_run
la $a0, %terms_label
jal create_polynomial
ss $v0
move $a0, $v0
la $a1, %expected_terms_label
jal check_polynomial
test_stack_check
rs $v0
.end_macro

.macro test_sort_polynomial (%terms_label, %expected_terms_label)
# Tests sorting a polynomial and checks it against an expected array of terms.
# %terms_label: list of terms to create polynomial from;
# %expected_terms_label: list of expected term values of sorted polynomial
# $v0 will contain a saved pointer to the sorted polynomial in case of further evaluation.
print_test_run
la $a0, %terms_label
jal create_polynomial
ss $v0
move $a0, $v0
jal sort_polynomial
lw $a0, 0($sp)  # polynomial pointer
la $a1, %expected_terms_label
jal check_polynomial
test_stack_check
rs $v0
.end_macro

.macro test_add_polynomial (%terms_label1, %terms_label2, %expected_terms_label)
# Tests adding two polynomials and checks it against an expected array of terms.
# %terms_label1: 1st polynomial terms list; %terms_label2: 2nd polynomial terms list;
# %expected_terms_label: list of expected term values of adding both polynomials
# $v0 will contain the polynomial result in case of further evaluation.
print_test_run
la $a0, %terms_label1
jal create_polynomial
ss $v0
la $a0, %terms_label2
jal create_polynomial
rs $a0
move $a1, $v0
jal add_polynomial
ss $v0
move $a0, $v0
la $a1, %expected_terms_label
jal check_polynomial
test_stack_check
rs $v0
.end_macro

.macro test_mult_polynomial (%terms_label1, %terms_label2, %expected_terms_label)
# Tests multiplying two polynomials and checks it against an expected array of terms.
# %terms_label1: 1st polynomial terms list; %terms_label2: 2nd polynomial terms list;
# %expected_terms_label: list of expected term values of multiplying both polynomials
# $v0 will contain the polynomial result in case of further evaluation.
print_test_run
la $a0, %terms_label1
jal create_polynomial
ss $v0
la $a0, %terms_label2
jal create_polynomial
rs $a0
move $a1, $v0
jal mult_polynomial
ss $v0
move $a0, $v0
la $a1, %expected_terms_label
jal check_polynomial
test_stack_check
rs $v0
.end_macro


.text
main:
	test_stack_store
	
	## Test cases: [1, 10]
	# Tests create_term.
	set_test_case 1

	.data
	term2: .word 1 0 0
	term4: .word -7 6 0
	.text

	# 1: Term(0, 0) => -1 (coeff is 0)
	test_create_term 0, 0  # 1
	
	# 2: Term(1, 0) => Term*
	test_create_term 1, 0, term2  # 2
	
	# 3: Term(0, 5) => -1 (coeff is 0)
	test_create_term 0, 5  # 3
	
	# 4: Term(-7, 6) => Term*
	test_create_term (-7, 6, term4)  # 4
	
	# 5: Term(4, -1) => -1 (exp < 0)
	test_create_term 4, -1  # 5
	
	## Test cases: [11, 20]
	# Test create_polynomial
	set_test_case 11
	
	.data
	polynomial11_1: .word 1 2 3 4 5 6 0 -1
	polynomial11_2: .word 1 2 3 4 5 6 0 -1
	polynomial12_1: .word 1 1 2 1 3 1 0 -1
	polynomial12_2: .word 6 1 0 -1
	polynomial13_1: .word 5 6 4 4 -2 3 2 4 1 1 0 -1
	polynomial13_2: .word 5 6 6 4 -2 3 1 1 0 -1
	polynomial14: .word 0 -1
	polynomial15: .word 2 2 0 1 0 -1
	polynomial16: .word 1 5 4 3 2 -1 6 7 0 -1
	polynomial17_1: .word 1 2 -2 3 2 3 -1 2 0 -1
	polynomial17_2: .word 0 -1
	.text
	
	# 11: create_polynomial([(1, 2), (3, 4), (5, 6)])
	# => no_of_terms = 3 -> Term(1, 2) -> Term(3, 4) -> Term(5, 6) -> NULL
	test_create_polynomial polynomial11_1, polynomial11_2  # 11
	
	# 12: create_polynomial([(1, 1), (2, 1), (3, 1)])
	# => no_of_terms = 1 -> Term(6, 1) -> NULL
	test_create_polynomial polynomial12_1, polynomial12_2  # 12
	
	# 13: create_polynomial([(5, 6), (4, 4), (-2, 3), (2, 4), (1, 1)])
	# => no_of_terms = 4 -> Term(5, 6) -> Term(6, 4) -> Term(-2, 3) -> Term(1, 1) -> NULL
	test_create_polynomial polynomial13_1, polynomial13_2  # 13
	
	# 14: create_polynomial([]) => NULL; empty list is invalid
	test_create_polynomial polynomial14  # 14
	
	# 15: create_polynomial([(2, 2), (0, 1), (0, -1)]) => NULL; (0, 1) is invalid
	test_create_polynomial polynomial15  # 15
	
	# 16: create_polynomial([(1, 5), (4, 3), (2, -1), (6, 7), (0, -1)]) => NULL; (2, -1) is invalid
	test_create_polynomial polynomial16  # 16
	
	# 17: create_polynomial([(1, 2), (-2, 3), (2, 3), (-1, 2)])
	# => no_of_terms = 0 -> NULL
	test_create_polynomial polynomial17_1, polynomial17_2  # 17
	
	
	## Test cases: [21, 30]
	# Tests sort_polynomial
	set_test_case 21
	
	.data
	polynomial21_1: .word 1 2 3 4 5 6 0 -1
	polynomial21_2: .word 5 6 3 4 1 2 0 -1
	polynomial22_1: .word 1 3 -1 3 0 -1
	polynomial22_2: .word 0 -1
	polynomial23_1: .word 5 4 3 2 1 0 0 -1
	polynomial23_2: .word 5 4 3 2 1 0 0 -1
	polynomial24_1: .word 1 3 7 0 -8 4 3 9 2 2 0 -1
	polynomial24_2: .word 3 9 -8 4 1 3 2 2 7 0 0 -1
	.text
	
	# 21: sort_polynomial(Polynomial([(1, 2), (3, 4), (5, 6)])
	# => head_term -> Term(5, 6) -> Term(3, 4) -> Term(1, 2) -> NULL
	test_sort_polynomial polynomial21_1, polynomial21_2  # 21
	
	# 22: sort_polynomial(Polynomial([(1, 3), (-1, 3)]))
	# => head_term -> NULL
	test_sort_polynomial polynomial22_1, polynomial22_2  # 22
	
	# 23: sort_polynomial(Polynomial([(5, 4), (3, 2), (1, 0)]))
	# => head_term -> Term(5, 4) -> Term(3, 2) -> Term(1, 0) -> NULL
	test_sort_polynomial polynomial23_1, polynomial23_2  # 23
	
	# 24: sort_polynomial(Polynomial([(1, 3), (7, 0), (-8, 4), (3, 9), (2, 2)]))
	# => head_term -> Term(3, 9) -> Term(-8, 4) -> Term(1, 3) -> Term(2, 2) -> Term(7, 0) -> NULL
	test_sort_polynomial polynomial24_1, polynomial24_2  # 24
	
	
	## Test cases: [31, 40]
	# Tests add_polynomial
	set_test_case 31
	
	.data
	polynomial31_1: .word 6 5 4 3 2 1 0 -1
	polynomial31_2: .word 6 5 4 3 2 1 0 -1
	polynomial31_3: .word 12 5 8 3 4 1 0 -1
	polynomial32_1: .word 4 3 6 5 2 1 0 -1
	polynomial32_2: .word -6 5 -4 3 -2 1 0 -1
	polynomial32_3: .word 0 -1
	polynomial33_1: .word 1 2 3 4 0 -1
	polynomial33_3: .word 3 4 1 2 0 -1
	polynomial34_2: .word 1 2 3 4 0 -1
	polynomial34_3: .word 3 4 1 2 0 -1
	polynomial35_3: .word 0 -1
	polynomial36_1: .word -4 2 4 2 0 -1
	polynomial36_2: .word 6 3 -6 3 0 -1
	polynomial36_3: .word 0 -1
	.text
	
	# 31: add_polynomial(Polynomial([(6, 5), (4, 3), (2, 1)]), Polynomial([(6, 5), (4, 3), (2, 1)]))
	# => Polynomial([(12, 5), (8, 3), (4, 1)])
	test_add_polynomial polynomial31_1, polynomial31_2, polynomial31_3  # 31
	
	# 32: add_polynomial(Polynomial([(4, 3), (6, 5), (2, 1)]), Polynomial([(-6, 5), (-4, 3), (-2, 1)]))
	# => Polynomial()
	test_add_polynomial polynomial32_1, polynomial32_2, polynomial32_3  # 32
	
	# 33: add_polynomial(Polynomial([(1, 2), (3, 4)]), NULL)
	# => Polynomial([(3, 4), (1, 2)])
	test_add_polynomial polynomial33_1, NULL, polynomial33_3  # 33
	
	# 34: add_polynomial(NULL, Polynomial([(1, 2), (3, 4)]))
	# => Polynomial([(3, 4), (1, 2)])
	test_add_polynomial NULL, polynomial34_2, polynomial34_3  # 34
	
	# 35: add_polynomial(NULL, NULL)
	# => Polynomial()
	test_add_polynomial NULL, NULL, polynomial35_3  # 35
	
	# 36: add_polynomial(Polynomial([(-4, 2), (4, 2)])=Polynomial(), Polynomial([(-6, 3), (6, 3)])=Polynomial())
	# => Polynomial()
	test_add_polynomial polynomial36_1, polynomial36_2, polynomial36_3  # 36
	
	
	## Test cases: [41, 50]
	# Tests mult_polynomial
	set_test_case 41
	
	.data
	polynomial41_1: .word 2 0 1 2 0 -1
	polynomial41_2: .word 1 2 2 0 0 -1
	polynomial41_3: .word 1 4 4 2 4 0 0 -1
	polynomial42_1: .word 1 1 -4 0 0 -1
	polynomial42_2: .word 4 0 1 1 0 -1
	polynomial42_3: .word 1 2 -16 0 0 -1
	polynomial43_1: .word 1 4 6 5 -2 3 0 -1
	polynomial43_3: .word 0 -1
	polynomial44_2: .word 66 67 68 69 0 -1
	polynomial44_3: .word 0 -1
	polynomial45_1: .word -2 3 2 3 0 -1
	polynomial45_3: .word 0 -1
	polynomial46_1: .word 1 2 3 4 0 -1
	polynomial46_2: .word 1 1 -1 1 0 -1
	polynomial46_3: .word 0 -1
	.text
	
	# 41: mult_polynomial(Polynomial([(2, 0), (1, 2)]), Polynomial([(1, 2), (2, 0)]))
	# => Polynomial([(1, 4), (4, 2), (4, 0)])
	test_mult_polynomial polynomial41_1, polynomial41_2, polynomial41_3  # 41
	
	# 42: mult_polynomial(Polynomial([(1, 1), (-4, 0)]), Polynomial([(4, 0), (1, 1)]))
	# => Polynomial([(1, 2), (-16, 0)])
	test_mult_polynomial polynomial42_1, polynomial42_2, polynomial42_3  # 42
	
	# 43: mult_polynomial(Polynomial([(1, 4), (6, 5), (-2 , 3)]), NULL)
	# => Polynomial()
	test_mult_polynomial polynomial43_1, NULL, polynomial43_3  # 43
	
	# 44: mult_polynomial(NULL, Polynomial([(66, 67), (68, 69)]))
	# => Polynomial()
	test_mult_polynomial NULL, polynomial44_2, polynomial44_3  # 44
	
	# 45: mult_polynomial(Polynomial([(-2, 3), (2, 3)])=Polynomial(), NULL)
	# => Polynomial()
	test_mult_polynomial polynomial45_1, NULL, polynomial45_3  # 45
	
	# 46: mult_polynomial(Polynomial([(1, 2), (3, 4)]), Polynomial([(1, 1), (-1, 1)])=Polynomial())
	# => Polynomial()
	test_mult_polynomial polynomial46_1, polynomial46_2, polynomial46_3  # 46
	
	
	## Test cases: 51+
	# Add miscellaneous tests here.
	set_test_case 51
	
	
	exit

check_term:
# Tries to match a term with a known correct one from .data.
# Ignores and does not check next_term pointer.
# Will print an unexpected-expected error if something does not match.
# $a0: Term* to check; $a1: Term* expected
	ss $s0
	ss $s1
	
	## $s0 = Term* to check
	## $s1 = Term* expected
	move $s0, $a0
	move $s1, $a1
	
	# Check if $s0 is word-aligned before proceeding
	li $t0, 4
	div $s0, $t0
	mfhi $t0
	beqz $t0, check_term_if_3
	print_str test_not_word_aligned
	print_str_ln test_failed
	j check_term_return
	check_term_if_3:
	
	# Check coefficient
	lw $t0, 0($s0)
	lw $t1, 0($s1)
	beq $t0, $t1, check_term_if_1
	print_str printing_term_coeff
	print_test_failed $t0, $t1
	check_term_if_1:
	
	# Check exponent
	lw $t0, 4($s0)
	lw $t1, 4($s1)
	beq $t0, $t1, check_term_if_2
	print_str printing_term_exp
	print_test_failed $t0, $t1
	check_term_if_2:
	
	# Check next_term (should always be 0 when using create_term)
	lw $t0, 8($s0)
	lw $t1, 8($s1)
	beq $t0, $t1, check_term_if_4
	print_str printing_term_next
	print_test_failed $t0, $t1
	check_term_if_4:
	
	check_term_return:
	rs $s1
	rs $s0
	jr $ra

check_polynomial:
# Tries to traverse a polynomial and match the terms with
# an array of known correct terms from .data.
# Also checks if no_of_terms is correct.
# $a0: Polynomial* to check; $a1: terms[] of expected polynomial
	ss $s0
	ss $s1
	ss $s2
	ss $s3
	
	## $s0 = Polynomial*
	move $s0, $a0
	
	## $s1 = terms[] pointer
	move $s1, $a1
	
	# Check if $s0 is word-aligned before proceeding
	li $t0, 4
	div $s0, $t0
	mfhi $t0
	beqz $t0, check_polynomial_if1
	print_str test_not_word_aligned
	print_str_ln test_failed
	j check_polynomial_return
	check_polynomial_if1:
	
	## $s2 = next_term = head_term*
	lw $s2, 0($s0)
	
	## $s3 = no_of_terms counter
	move $s3, $0
	
	# For each element of terms[] until it reaches (0, -1),
	# compare pairs with corresponding polynomial Terms
	check_polynomial_loop1:
	# Branch if element == (0, -1)
	## $t0 = expected term coeff
	## $t1 = expected term exp
	## $s1 = next element of terms[]
	lw $t0, 0($s1)
	lw $t1, 4($s1)
	addi $s1, $s1, 8
	beqz $t0, check_polynomial_loop1_done
	li $t2, -1
	beq $t1, $t2, check_polynomial_loop1_done
		## $s3++ (no_of_terms)
		addi $s3, $s3, 1
		# If term values do not match, print error and break
		lw $t2, 0($s2)
		lw $t3, 4($s2)
		bne $t0, $t2, check_polynomial_loop1_if
		bne $t1, $t3, check_polynomial_loop1_if
		j check_polynomial_loop1_if_done
		check_polynomial_loop1_if:
			print_str test_failed
			print_bullet
			print_str test_expected
			print_int $t0
			print_str comma
			print_int $t1
			print_bullet
			print_str test_unexpected
			print_int $t2
			print_str comma
			print_int $t3
			print_ln
			j check_polynomial_loop1_done
		check_polynomial_loop1_if_done:
		# Load next Term
		lw $s2, 8($s2)
	j check_polynomial_loop1
	check_polynomial_loop1_done:
	
	# Check if no_of_terms matches expected no_of_terms
	lw $t0, 4($s0)
	beq $t0, $s3, check_polynomial_if2
		print_str printing_polynomial_no_of_terms
		print_str test_failed
		print_bullet
		print_str test_expected
		print_int $s3
		print_bullet
		print_str test_unexpected
		print_int $t0
		print_ln
	check_polynomial_if2:
	
	check_polynomial_return:
	rs $s3
	rs $s2
	rs $s1
	rs $s0	
	jr $ra

print_term:
# Prints the term from the given address.
# $a0: Term*
	ss $s0
	
	move $s0, $a0
	
	print_str printing_term_coeff
	lw $t0, 0($s0)
	print_int $t0
	print_bullet
	print_str printing_term_exp
	lw $t0, 4($s0)
	print_int $t0
	print_bullet
	print_str printing_term_next
	lw $t0, 8($s0)
	print_int $t0
	print_ln
	
	rs $s0
	jr $ra

print_polynomial:
# Traverses the given polynomial and prints each term.
# $a0: Polynomial*
	ss $s0
	
	## $s0 = next_term
	lw $s0, 0($a0)
	
	# Print no_of_terms
	lw $t0, 4($a0)
	print_bullet
	print_str printing_polynomial_no_of_terms
	print_int $t0
	print_bullet
	
	# While next_term is not NULL, print the next term's values.
	print_polynomial_loop:
	# Branch if $s0 == 0
	beqz $s0, print_polynomial_loop_done
		lw $t0, 0($s0)
		print_int $t0
		print_str comma
		lw $t0, 4($s0)
		print_int $t0
		print_bullet
		# Get next_term
	# Set next_term
	lw $s0, 8($s0)
	j print_polynomial_loop
	print_polynomial_loop_done:
	
	print_ln
	
	rs $s0
	jr $ra
	
.include "hw5.asm"
