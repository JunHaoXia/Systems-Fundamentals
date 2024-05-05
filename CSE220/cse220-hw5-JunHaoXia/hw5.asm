############## JunHaoXia ##############
############## junxia #################
############## 113196003 ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term
create_term:
move $t7, $a0                    #store a0 into t9
beqz $a0, invalid_term           #if coeff is zero
bltz $a1, invalid_term           #if expo is negative
li $a0, 12                       #bytes to allocate
li $v0, 9                        #sbrk
syscall
sw $t7, 0($v0)                   #coeff into first 4
sw $a1, 4($v0)                   #then expo into next 4
sw $0, 8($v0)                    #finally 0 into last 4
j complete_term
invalid_term:
li $v0, -1
jr $ra
complete_term:
  jr $ra

.globl create_polynomial
create_polynomial:
li $t6, 0             #counter
lw $t0, 0($a0)                      #stores first coeff
lw $t1, 4($a0)                      #stores first expo
beqz $t0, check_empty            #check if it is empty
j damedane

check_empty:
bltz $t1, invalid_create_poly

damedane:
move $t9, $a0         #save pointer at start
move $t3, $t9

addi $sp, $sp, -16
sw $a0, 0($sp)
sw $ra, 8($sp)

#### add into pointer
add_into_linked_list:
lw $t0, 0($t9)                      #stores first coeff
lw $t1, 4($t9)                      #stores first expo
beqz $t0, check_end_zero            #check if it ends
bltz  $t1, invalid_create_poly

move $a0, $t0
move $a1, $t1
jal create_term

beqz $t6, first_term
sw $v0, 8($t2)
j escape

first_term:
sw $0, 8($v0)
move $t4, $v0          #pointer to head term
escape:
move $t2, $v0

lw $a0, 0($sp)
lw $ra, 8($sp)
addi $t9, $t9, 8
addi $t6, $t6, 1
j add_into_linked_list

check_end_zero:                    #it ends or is there an error
li $t2, -1
beq $t1, $t2, is_first_term
j invalid_create_poly

is_first_term:
beqz $t6, invalid_create_poly
j exit_create_addition_poly

exit_create_addition_poly:
sw $0, 8($v0)
li $a0, 8                       #bytes to allocate
li $v0, 9                        #sbrk
syscall
sw $t4, 0($v0)
sw $t6, 4($v0)
move $t3, $v0
addi $sp, $sp, 16
########################################
move $t0, $t4
add_like_expo_values_create:
lw $t1, 0($t0)             #coeff
lw $t2, 4($t0)             #expo
lw $t4, 8($t0)             #next term address
move $t9, $t0              #store a copy of prev address
move $t8, $t4             #store a copy
beqz $t4, exit_add_like_expo_val_create

search_like_expo_values_create:
lw $t5, 0($t4)            #coeff
lw $t6, 4($t4)            #expo
lw $t7, 8($t4)            #next term address

beq $t2, $t6, add_expo_val_create
move $t9, $t4                   #stores prev address
finish_adding_create:
beqz $t7, next_expo_search_create
move $t4, $t7                   #to next term in list
j search_like_expo_values_create

next_expo_search_create:
move $t0, $t8
j add_like_expo_values_create

add_expo_val_create:
add $t1, $t1, $t5
sw $t1, 0($t0)
sw $t7, 8($t9)
j finish_adding_create
exit_add_like_expo_val_create:
lw $t0, 0($t3)
li $t6, 0
####################################
counting_time_lets_go:
lw $t1, 8($t0)
lw $t2, 0($t0)
beqz $t2, finish_counting_bro
addi $t6, $t6, 1
beqz $t1, finish_counting_bro
move $t0, $t1
j counting_time_lets_go

finish_counting_bro:
sw $t6, 4($t3)
move $v0, $t3
jr $ra

invalid_create_poly:
#la $v0, NULL
li $v0, 0
  jr $ra

.globl sort_polynomial
sort_polynomial:
lw $t0, 0($a0)            #get address of head term

li $t9, 0          #counter
get_head_term:
lw $t1, 0($t0)            #get coeff of head term
lw $t2, 4($t0)            #get expo of head term
beqz $t1, exit_sort_poly          #if next term address is 0, leave
lw $t3, 8($t0)            #get next term address
lw $t7, 8($t0)            #checkpoint of sorts
addi $t9, $t9, 1
beqz $t3, exit_sort_poly          #if next term address is 0, leave

search_largest_loop:

lw $t4, 0($t3)           #get coeff of other term
lw $t5, 4($t3)           #get expo of other term
lw $t6, 8($t3)           #get next term address of other term
bgt $t5, $t2, swap_terms                #if expo is greater, swap
resume_checking_sort:
beqz $t6, next_term_check               #move onto next position in linked list
j lordwhyyoudothis

next_term_check:
move $t0, $t7                           #move over in the linked list
j get_head_term

lordwhyyoudothis:
move $t3, $t6
j search_largest_loop

swap_terms:                   #swap coeff and expo between terms
lw $t1, 0($t0)
lw $t2, 4($t0)
sw $t4, 0($t0)
sw $t5, 4($t0)
sw $t1, 0($t3)
sw $t2, 4($t3)
lw $t1, 0($t0)
lw $t2, 4($t0)
j resume_checking_sort

exit_sort_poly:
sw $t9, 4($a0)
  jr $ra

.globl add_polynomial
add_polynomial:
beqz $a0, check_both_null
beqz $a1, two_is_null
lw $t0, 0($a0)
move $t3, $t0
lw $t1, 0($a1)
j merge_poly_add

check_both_null:
beqz $a1, both_null
j one_is_null

merge_poly_add:
lw $t2, 8($t0)
beqz $t2, merge_poly_together
move $t0, $t2
j merge_poly_add

merge_poly_together:
sw $t1, 8($t0)

move $t0, $t3
li $t3, 0               #counter
add_like_expo_values:
lw $t1, 0($t0)             #coeff
lw $t2, 4($t0)             #expo
lw $t4, 8($t0)             #next term address
move $t9, $t0              #store a copy of prev address
move $t8, $t4             #store a copy
beqz $t4, exit_add_like_expo_val

search_like_expo_values:
lw $t5, 0($t4)            #coeff
lw $t6, 4($t4)            #expo
lw $t7, 8($t4)            #next term address

beq $t2, $t6, add_expo_val
finish_adding:
beqz $t7, next_expo_search
move $t9, $t4
move $t4, $t7
j search_like_expo_values

next_expo_search:
move $t0, $t8
j add_like_expo_values

add_expo_val:
add $t1, $t1, $t5
sw $t1, 0($t0)
sw $t7, 8($t9)
j finish_adding

exit_add_like_expo_val:
lw $t0, 0($a0)
count_the_amount_add:
lw $t2, 0($t0)             #coeff
lw $t4, 8($t0)             #next term address
beqz $t2, cut_the_term_bro
li $t5, 'G'
beq $t5, $t2, cut_the_term_bro
j abcdefgidk

cut_the_term_bro:
addi $t3, $t3, -1

abcdefgidk:
addi $t3, $t3, 1
beqz $t4, leave_counting_add
move $t0, $t4
j count_the_amount_add

leave_counting_add:
sw $t3, 4($a0)           #store size into a0
addi $sp, $sp, -8
sw $ra, 0($sp)

jal sort_polynomial

lw $ra, 0($sp)
addi $sp, $sp, 8

move $v0, $a0
jr $ra

one_is_null:
#lw $t1, 0($a1)
#sw $0, 4($a1)           #store size into a0
move $a0, $a1
addi $sp, $sp, -8
sw $ra, 0($sp)

jal sort_polynomial

lw $ra, 0($sp)
addi $sp, $sp, 8

move $v0, $a0
jr $ra

two_is_null:
#lw $t0, 0($a0)
#sw $0, 4($a0)           #store size into a0
addi $sp, $sp, -8
sw $ra, 0($sp)

jal sort_polynomial

lw $ra, 0($sp)
addi $sp, $sp, 8
move $v0, $a0
jr $ra

both_null:
create_empty_poly:
move $t0, $a0
li $a0, 20                       #bytes to allocate
li $v0, 9                        #sbrk
syscall
sw $0, 0($v0)
li $t1, -1
sw $t1, 4($v0)
sw $0, 8($v0)
sw $v0, 12($v0)
sw $0, 16($v0)
addi $v0, $v0, 12
  jr $ra

.globl mult_polynomial
mult_polynomial:
beqz $a0, null_in_mult
beqz $a1, null_in_mult

lw $t0, 0($a0)
lw $t1, 0($a1)

lw $t0, 0($t0)
lw $t1, 0($t1)

beqz $t0, null_in_mult
beqz $t1, null_in_mult

lw $t0, 0($a0)
lw $t1, 0($a1)

li $t9, 0
term1_loop_through:
lw $t2, 0($t0)           #coeff
lw $t3, 4($t0)           #expo
lw $t4, 8($t0)           #next term address
j term2_loop_through
next_term1:              #next term for 1st arg
beqz $t4, exit_mult_poly    #if add end of the 1st arg
move $t0, $t4
lw $t1, 0($a1)
j term1_loop_through

term2_loop_through:
lw $t5, 0($t1)           #coeff
lw $t6, 4($t1)           #expo
lw $t7, 8($t1)          #next term address
j poly_mult
mult_completed:
beqz $t7, next_term1    #if add end of the 2nd arg

move $t1, $t7               #next term for 2nd arg
j term2_loop_through

poly_mult:                    #multiplication with creating new term for new polynomial
mul $t5, $t5, $t2
add $t6, $t6, $t3
li $a0, 12                       #bytes to allocate
li $v0, 9                        #sbrk
syscall
sw $t5, 0($v0)
sw $t6, 4($v0)
beqz $t9, head_term_creation          #if head_term hasn't been created yet, set next address to zero

sw $v0, 8($t9)
j mariobejumping

head_term_creation:
sw $0, 8($v0)
move $t8, $v0            #save head term address

mariobejumping:
move $t9, $v0
j mult_completed

exit_mult_poly:
li $a0, 8                       #bytes to allocate
li $v0, 9                        #sbrk
syscall
sw $t8, 0($v0)                 #store head term address
move $t0, $t8                 #move head term address
move $t3, $v0                 #t3 contains reference of polynomial
lw $t0, 0($t3)
##############
add_like_expo_values_mult:
lw $t1, 0($t0)             #coeff
lw $t2, 4($t0)             #expo
lw $t4, 8($t0)             #next term address
move $t9, $t0              #store a copy of prev address
move $t8, $t4             #store a copy
beqz $t4, exit_add_like_expo_val_mult

search_like_expo_values_mult:
lw $t5, 0($t4)            #coeff
lw $t6, 4($t4)            #expo
lw $t7, 8($t4)            #next term address

beq $t2, $t6, add_expo_val_mult
finish_adding_mult:
beqz $t7, next_expo_search_mult
move $t9, $t4
move $t4, $t7
j search_like_expo_values_mult

next_expo_search_mult:
move $t0, $t8
j add_like_expo_values_mult

add_expo_val_mult:
add $t1, $t1, $t5
sw $t1, 0($t0)
sw $t7, 8($t9)
j finish_adding_mult
exit_add_like_expo_val_mult:
#################
move $t8, $t3
lw $t0, 0($t3)
li $t9, 0
cleanse:
lw $t1, 0($t0)       #coeff
lw $t2, 4($t0)       #expo
lw $t3, 8($t0)       #next address
beqz $t1, check_next_has
beqz $t3, exit_cleanse
li $a0, 12
li $v0, 9
syscall

beqz $t9, store_new_head_zero
j not_first_skip

store_new_head_zero:
move $t4, $v0

not_first_skip:
sw $t1, 0($v0)       #coeff
sw $t2, 4($v0)       #expo
sw $t3, 8($v0)       #next address
addi $t9, $t9, 1
move $t0, $t3
j cleanse

check_next_has:
beqz $t3, exit_cleanse
move $t0, $t3
j cleanse

exit_cleanse:
sw $t4, 0($t8)
move $a0, $t8     #load multiplied polynomial

addi $sp, $sp, -8
sw $ra, 0($sp)

jal sort_polynomial

lw $ra, 0($sp)
addi $sp, $sp, 8

move $v0, $a0
jr $ra

null_in_mult:             #error case
move $t0, $a0
li $a0, 20                       #bytes to allocate
li $v0, 9                        #sbrk
syscall
sw $0, 0($v0)
li $t1, -1
sw $t1, 4($v0)
sw $0, 8($v0)
sw $v0, 12($v0)
sw $0, 16($v0)
addi $v0, $v0, 12
  jr $ra
