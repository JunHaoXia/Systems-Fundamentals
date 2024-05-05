########### JunHao Xia ############
########### junxia ################
########### 113196003 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl substr
substr:
	bltz $a1, outBound
	ble $a2, $a1, outBound
	add $t4, $a0, $0  #base pointer        t4
	add $t0, $a0, $a1  #move to lower bound    t0
	add $t1, $a0, $a2  #upper bound set   t1
	lb $t3, 0($t1)
	addi $t1, $t1, -1
	lb $t5, 0($t1)
	beqz $t5, outBound
	checkString:
		lb $t2, 0($t0)
		beq $t2, $t3, checkExit    #leaves when done
		beq $t2, $0, outBound  #check null term
		sb $t2, 0($t4)      #add char to base pointer
		addi $t4, $t4, 1    #move base pointer
		addi $t0, $t0, 1    #move string pointer
		j checkString
	checkExit:
	li $t6, 0		
	sb $t6, 0($t4)    #adding null term at end
	li $v0, 0					
 jr $ra

.globl encrypt_block
encrypt_block:
li $t4, 4                   #t4 is counter
li $t2, 0                   #t2 is ans
enLoop:
lb $t0, 0($a0)             #get 1 byte of a0
lb $t1, 0($a1)             #get 1 byte of a1
xor $t3, $t0, $t1          #get xor of a0 and a1 into t3
add $t2, $t2, $t3          #add t3 into t2
addi $t4, $t4, -1          #countdown
beqz $t4, enLoopExit
sll $t2, $t2, 8            #shift ans
addi $a0, $a0, 1
addi $a1, $a1, 1
j enLoop
enLoopExit:
add $v0, $t2, $0
 jr $ra

.globl add_block
add_block:
#a0 is dest a1 is bindex and a2 is code
sll $t0, $a1, 2      #make a1 a mult of 4               
add $t1, $a0, $t0   #$t1 is at index 
li $t3, 24          #set t3 as 24 for now
li $t4, 4           #counter
addLoop:
add $t2, $a2, $0       #copy code into t2
sllv $t6, $t2, $t3   #shift left by t3
srl $t6, $t6, 24     #shift right by 24
sb $t6, 0($t1)       #insert char
addi $t4, $t4, -1    #countdown
beqz $t4, addExit
addi $t1, $t1, 1    #move pointer
addi $t3, $t3, -8    #change amount moved
j addLoop
addExit:
 jr $ra

.globl gen_key
gen_key:
sll $t0, $a1, 2      #make a1 a mult of 4               
add $t1, $a0, $t0    #$t1 is at index 
li $t4, 4           #counter
move $t0, $a0
move $t3, $a1
genLoop:
beqz $t4, genExit
li $a1, 128           #random char generator
li $v0, 42
syscall
sb $a0, 0($t1)       #store random char at pointer
addi $t4, $t4, -1    #countdown
addi $t1, $t1, 1     #move pointer
j genLoop
genExit:
move $a1, $t3    #move back a1
move $a0, $t0    #move back a0
 jr $ra
############################################################################################################################        PART 5
.globl encrypt
encrypt:
move $t3, $a3
addi $t4, $0, 4
div $t3, $t4           #length divide by 4
mflo $t5              #t5 is quotient
mfhi $t6              #t6 is remainder

beqz $t6, divByFour

#a1 needs to be bindex execpt for encrypt a block
#a0 needs to be the address it needs to be placed into
encryptRemain:
move $t2, $a0    #move a0 into t2
move $t3, $a1    #move a1 into t2
add $t1, $t2, $a3   #move to where to add chars
sub $t4, $t4, $t6   #amount of random chars to add
li $t7, 0           #counter
remainLoop:
beq $t7, $t4, exitRemain
li $a1, 128           #random char generator
li $v0, 42
syscall
sb $a0, 0($t1)      #add in the random char
addi $t1, $t1, 1    #increase count
addi $t7, $t7, 1    #increase count
j remainLoop
exitRemain:
addi $t5, $t5, 1
move $a0, $t2
move $a1, $t3

divByFour:
addi $sp, $sp, -12     #allocate memory in stack
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 12($sp)

li $t2, 0            #index counter
add $a0, $a1, $0         #move a0 to a1(going to hold key)
genKeyLoop:
beq $t2, $t5, genKeyExit

add $a1, $t2, $0         #move index into a1 (bindex)

jal gen_key
#gen_key returns a0 with key in address

addi $a0, $a0, 1     #move pointer by counter
addi $t2, $t2, 1     #increase counter
j genKeyLoop
genKeyExit:
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 12($sp)
addi $sp, $sp, 12     #deallocate memory in stack
addi $sp, $sp, -16     #allocate memory in stack
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 12($sp)

add $a1, $t2, $0         #move index in a1
move $t9, $a0        #move a0 into t9
addBlockLoop:
beq $a1, $t5, addBlockExit

lw $a2, 0($t9)        #gets 1st word

jal add_block
#add_block returns a0 with block in address

addi $t9, $t9, 4    #move pointer by counter
addi $a1, $a1, 1     #increase counter
j addBlockLoop
addBlockExit:
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16     #deallocate memory in stack
addi $sp, $sp, -16     #allocate memory in stack
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $a2, 8($sp)
sw $ra, 12($sp)
li $t7, 0            #index counter

encryptBlockLoop:
beq $t7, $t5, encryptBlockExit
                      #key stays in a1
jal encrypt_block
#encrypt_block returns a0 with block in address
sw $v0, 0($a2)
addi $a2, $a2, 4    #move pointer by counter
addi $a0, $a0, 1    #move block address pointer
addi $a1, $a1, 1    #move key address pointer
addi $t7, $t7, 1     #increase counter
j encryptBlockLoop
encryptBlockExit:

lw $a0, 0($sp)
lw $a1, 4($sp)
lw $a2, 8($sp)
lw $ra, 12($sp)
addi $sp, $sp, 16     #deallocate memory in stack
 jr $ra


.globl decrypt_block
decrypt_block:
li $t4, 4                   #t4 is counter
li $t2, 0                   #t2 is ans
addi $a1, $a1, 3            #move pointer to end
deLoop:
lb $t0, 0($a0)             #get 1 byte of a0
lb $t1, 0($a1)             #get 1 byte of a1
xor $t3, $t0, $t1          #get xor of a0 and a1 into t3
add $t2, $t2, $t3          #add t3 into t2
addi $t4, $t4, -1          #countdown
beqz $t4, deLoopExit
sll $t2, $t2, 8            #shift ans
addi $a0, $a0, 1          #move pointer
addi $a1, $a1, -1         #move pointer
j deLoop
deLoopExit:
add $v0, $t2, $0
 jr $ra

.globl decrypt
decrypt:
move $t3, $a2
addi $t4, $0, 4
div $t3, $t4           #length divide by 4
mflo $t5              #t5 is quotient
mfhi $t6              #t6 is remainder
li $t6, 0             #counter

addi $sp, $sp, -12     #allocate memory in stack
sw $a0, 0($sp)
sw $a1, 4($sp)
sw $ra, 12($sp)
decryptLoop:
beq $t6, $t5, decryptExit

jal decrypt_block
sw $v0, 0($a3)
addi $a0, $a0, 1
addi $a1, $a1, 4
addi $t6, $t6, 1
addi $a3, $a3, 4
j decryptLoop

decryptExit:
lw $a0, 0($sp)
lw $a1, 4($sp)
lw $ra, 12($sp)
addi $sp, $sp, 12     #deallocate memory in stack
 jr $ra

outBound:
	li $v0, -1
	jr $ra