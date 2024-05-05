################# JunHao Xia #################
################# junxia #################
################# 113196003 #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of the arguments is invalid\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here:
#li $s2,69
#li $v0, 1
#move $a0,$s2
#syscall
#li $v0, 10
#syscall

lw $a0, num_args
li $a2, 2           #$a0 is numargs
bne $a0, $a2, Err1  #$a1 is arg1_addr
                    #$t0 is arg2_addr

lw $t1, arg1_addr   #t1 has arg_num1
lbu $t2, 0($t1)  #t2 arg1 slot 0
lbu $t3, 1($t1)  #t3 arg1 slot 1
beqz $t2, invalid
bnez $t3, invalid  
bgtz $t1, switch
switch:
    addi $t4, $0, 'D'
    beq $t4, $t2, caseD
    addi $t4, $0, 'O'
    beq $t4, $t2, caseO
    addi $t4, $0, 'S'
    beq $t4, $t2, caseS
    addi $t4, $0, 'T'
    beq $t4, $t2, caseT
    addi $t4, $0, 'I'
    beq $t4, $t2, caseI
    addi $t4, $0, 'F'
    beq $t4, $t2, caseF
    addi $t4, $0, 'L'
    beq $t4, $t2, caseL
    j invalid

done1:
#part2
caseD:
    lw $t2, arg2_addr  #t2 is arg_num2
    li $t4, 0  #$t4 is used to count
    li $t5, 48
    li $s0, 0
    li $s1, 0
    for1:
        lbu $t3, 0($t2)   # $t3 is target char
        beqz $t3, done2    #exit loop if at null terminal
        beqz $t4, ifone
        addi $t2, $t2, 1    #increase counter
        addi $t5, $t3, -48   # $t5 now char-48
        addi $t6, $0, 0
        addi $t7, $0, 9
        blt $t5, $t6, invalid
        bgt $t5, $t7, invalid
        addi $t6, $0, 10
        mul $s0, $s0, $t6          #increase the base by a 10
        add $s0, $s0, $t5           #adds base to new value
        j for1
        ifone:
            li $t5, '-'
            bne $t5, $t3, positive
            addi $s1, $0, 1       # $s1 shows if negative or nah
            addi $t4, $t4, 1
            addi $t2, $t2, 1    #increase counter
            negative:
            lbu $t3, 0($t2)   # $t3 is target char
        beqz $t3, done2    #exit loop if at null terminal
            addi $t5, $t3, -48   # $t5 now char-48
                li $t6, 0
            li $t7, 9
                blt $t5, $t6, invalid
                bgt $t5, $t7, invalid
                addi $t6, $0, 10
                mul $s0, $s0, $t6          #increase the base by a 10
                sub $s0, $s0, $t5           #adds base to new value
                #addi $t4, $t4, 1
                addi $t2, $t2, 1    #increase counter
            j negative
            positive:
                addi $t5, $t3, -48   # $t5 now char-48
                li $t6, 0
            li $t7, 9
                blt $t5, $t6, invalid
                bgt $t5, $t7, invalid
                addi $t6, $0, 10
                mul $s0, $s0, $t6          #increase the base by a 10
                add $s0, $s0, $t5           #adds base to new value
                addi $t4, $t4, 1
                addi $t2, $t2, 1    #increase counter
                j for1                
    done2:
    move $a0, $s0
    li $v0, 1
    syscall
    li $v0, 10
    syscall
#part3
caseO:
    lbu $t4, 0($t0)
    li $t5, '0'
    bne $t4, $t5, invalid
    lbu $t4, 1($t0)
    li $t5, 'x'
    bne $t4, $t5, invalid
    addi $t0, $t0, 2     #$t0 the hexadecimal
    li $t4, 0
    add $t5, $0, $t0
    countO:                    #checks if there are 32 bits
    lbu $t7, 0($t5)
    beqz $t7, returnO
    li $t6, 8
    bgt $t4, $t6, invalid
    addi $t5, $t5, 1
    addi $t4, $t4, 1
    j countO
    returnO:
    li $t3, 8
    sub $s0, $t3, $t4
    li $t3, 1
    li $t4, 0
    forO:                      #converts hexa to binary in address
    li $t5, 8
    bnez $s0, addSpaceO
    j fullHexaO
    addSpaceO:            
    addi $t4, $t4, 0
    addi $t3, $t3, 1
      bgt $t3, $t5, doneO
        sll $t4, $t4, 4
        addi $s0, $s0, -1
        j forO
        fullHexaO:
        lbu $t1, 0($t0)
        addi $t1, $t1, -48
        li $t2, 9
        bgt $t1, $t2, convertO
        j contO
        convertO:
        addi $t1, $t1, -7
        contO:
        add $t4, $t4, $t1
        addi $t0, $t0, 1    
        addi $t3, $t3, 1
        bgt $t3, $t5, doneO
        sll $t4, $t4, 4
        j forO
    doneO:
    srl $a0, $t4, 26
    li $v0, 1
    syscall
    li $v0, 10
    syscall
caseS:
    lbu $t4, 0($t0)
    li $t5, '0'
    bne $t4, $t5, invalid
    lbu $t4, 1($t0)
    li $t5, 'x'
    bne $t4, $t5, invalid
    addi $t0, $t0, 2     #$t0 the hexadecimal
    li $t4, 0
    add $t5, $0, $t0
    countS:                        #checks if there are 32 bits
    lbu $t7, 0($t5)
    beqz $t7, returnS
    li $t6, 8
    bgt $t4, $t6, invalid
    addi $t5, $t5, 1
    addi $t4, $t4, 1
    j countS
    returnS:
    li $t3, 8
    sub $s0, $t3, $t4
    li $t3, 1
    li $t4, 0
    forS:                      #converts hexa to binary in address
    li $t5, 8
    bnez $s0, addSpaceS
    j fullHexaS
    addSpaceS:            
    addi $t4, $t4, 0
    addi $t3, $t3, 1
      bgt $t3, $t5, doneS
        sll $t4, $t4, 4
        addi $s0, $s0, -1
        j forS
        fullHexaS:
        lb $t1, 0($t0)
        addi $t1, $t1, -48
        li $t2, 9
        bgt $t1, $t2, convertS
        j contS
        convertS:
        addi $t1, $t1, -7
        contS:
        add $t4, $t4, $t1
        addiu $t0, $t0, 1    
        addi $t3, $t3, 1
        bgt $t3, $t5, doneS      
        sll $t4, $t4, 4
        j forS
    doneS:
    sll $t4, $t4, 6
    srl $a0, $t4, 27
    li $v0, 1
    syscall
    li $v0, 10
    syscall
caseT:
    lbu $t4, 0($t0)
    li $t5, '0'
    bne $t4, $t5, invalid
    lbu $t4, 1($t0)
    li $t5, 'x'
    bne $t4, $t5, invalid
    addi $t0, $t0, 2     #$t0 the hexadecimal
    li $t4, 0
    add $t5, $0, $t0
    countT:                   #checks if there are 32 bits
    lbu $t7, 0($t5)
    beqz $t7, returnT
    li $t6, 8
    bgt $t4, $t6, invalid
    addi $t5, $t5, 1
    addi $t4, $t4, 1
    j countT
    returnT:
    li $t3, 8
    sub $s0, $t3, $t4
    li $t3, 1
    li $t4, 0
    forT:                      #converts hexa to binary in address
    li $t5, 8
    bnez $s0, addSpaceT
    j fullHexaT
    addSpaceT:            
    addi $t4, $t4, 0
    addi $t3, $t3, 1
      bgt $t3, $t5, doneT
        sll $t4, $t4, 4
        addi $s0, $s0, -1
        j forT
        fullHexaT:
        lb $t1, 0($t0)
        addi $t1, $t1, -48
        li $t2, 9
        bgt $t1, $t2, convertT
        j contT
        convertT:
        addi $t1, $t1, -7
        contT:
        add $t4, $t4, $t1
        addiu $t0, $t0, 1    
        addi $t3, $t3, 1
        bgt $t3, $t5, doneT      
        sll $t4, $t4, 4
        j forT
    doneT:
    sll $t4, $t4, 11
    srl $a0, $t4, 27
    li $v0, 1
    syscall
    li $v0, 10
    syscall
caseI:                      #checks if there are 32 bits
    lbu $t4, 0($t0)
    li $t5, '0'
    bne $t4, $t5, invalid
    lbu $t4, 1($t0)
    li $t5, 'x'
    bne $t4, $t5, invalid
    addi $t0, $t0, 2     #$t0 the hexadecimal
    li $t4, 0
    add $t5, $0, $t0
    countI:                 #checks if there are 32 bits
    lbu $t7, 0($t5)
    beqz $t7, returnI
    li $t6, 8
    bgt $t4, $t6, invalid
    addi $t5, $t5, 1
    addi $t4, $t4, 1
    j countI
    returnI:
    li $t3, 8
    sub $s0, $t3, $t4
    li $t3, 1
    li $t4, 0
    forI:                      #converts hexa to binary in address
    li $t5, 8
    bnez $s0, addSpaceI
    j fullHexaI
    addSpaceI:            
    addi $t4, $t4, 0
    addi $t3, $t3, 1
      bgt $t3, $t5, doneI
        sll $t4, $t4, 4
        addi $s0, $s0, -1
        j forI
        fullHexaI:
        lb $t1, 0($t0)
        addi $t1, $t1, -48
        li $t2, 9
        bgt $t1, $t2, convertI
        j contI
        convertI:
        addi $t1, $t1, -7
        contI:
        add $t4, $t4, $t1
        addiu $t0, $t0, 1    
        addi $t3, $t3, 1
        bgt $t3, $t5, doneI      
        sll $t4, $t4, 4
        j forI
    doneI:
    sll $t4, $t4, 16
    sra $a0, $t4, 16
    li $v0, 1
    syscall
    li $v0, 10
    syscall
#PART 4
caseF:
li $t2, 0        #counter
add $t4, $0, $t0
checkSize:               #checks for size while checking valid args
lbu $t1, 0($t4)
beqz $t1, loopExit1        #leaves when at null terminal
addi $t1, $t1, -48       #ASCII to decimal
li $t3, 0
blt $t1, $t3, invalid         #less than zero --> invalid
li $t3, 9
bgt $t1, $t3, check2            #greater than nice --> check2
addi $t2, $t2, 1         #increase count
addi $t4, $t4, 1       #next byte
j checkSize
check2:
li $t3, 17
blt $t1, $t3, invalid          #less than A --> invalid
li $t3, 22
bgt $t1, $t3, invalid           #greater than F --> invalid
addi $t2, $t2, 1     #increase count
addi $t4, $t4, 1       #next byte
j checkSize    
loopExit1:
li $t4, 0
li $t6, 1
li $t3, 8
li $t7, 0
bne $t2, $t3, invalid   #not 8 long --> invalid
lw $t3, arg2_addr  #t3 is arg_num2
li $t5, 8

add $t7, $t7, $t3
getValue:
        lb $t1, 0($t7)
        addi $t1, $t1, -48
        li $t2, 9
        bgt $t1, $t2, convert
        j cont
        convert:
        addi $t1, $t1, -7
        cont:
        add $t4, $t4, $t1
        addiu $t7, $t7, 1    
        addi $t6, $t6, 1
        bgt $t6, $t5, valueExit    
        sll $t4, $t4, 4
        j getValue

valueExit:
#filter special floating points
li $t2, 0x00000000
beq $t2, $t4, zero1
li $t2, 0x80000000
beq $t2, $t4, zero1
li $t2, 0xFF800000
beq $t2, $t4, infneg
li $t2, 0x7F800000
beq $t2, $t4, infpos
checkpoint:                     #checking NAN
lb $t2, 0($t3)
li $t5, '7'
beq $t2, $t5, checkpoint2
li $t5, 'F'
beq $t2, $t5, checkpoint2
j checkdone
checkpoint2:
lb $t2, 1($t3)
li $t5, 'F'
beq $t2, $t5, checkpoint3
j checkdone
checkpoint3:
lb $t2, 2($t3)
li $t5, '8'
beq $t2, $t5, nan1
bgt $t2, $t5, nan1
checkdone:
#exponent
add $t5, $t4, $0     #copy arg2 into t5
sll $t5, $t5, 1
srl $t5, $t5, 24
addi $t5, $t5, -127        
move $a0, $t5    #a0 has the exponent
li $v0, 1
syscall
#sign
add $t5, $t4, $0     #copy arg2 into t5
srl $t5, $t5, 31
add $t7, $0, $t5   #t1 has the sign
#mantissa
la $a1, mantissa
addi $t1, $a1, 0
li $t2, '1'
addi $t2, $t2, -48
beq $t7, $t2, negValue       #checks sign
j posValue
negValue:
li $t2, '-'
sb $t2, 0($t1)
addi $t1, $t1, 1
posValue:
li $t2, '1'
sb $t2, 0($t1)
addi $t1, $t1, 1
li $t2, '.'
sb $t2, 0($t1)
addi $t1, $t1, 1
exitF:
sll $t4, $t4, 9    
srl $t4, $t4, 9    #t4 has mantissa
li $t2, 23   #counter
loopF:
beqz $t2, leaveLoopF
addi $t5, $t4, 0
srl $t5, $t5, 22
andi $t5, $t5, 0x1
addi $t5, $t5, 48
sb $t5, 0($t1)
addi $t1, $t1, 1
sll $t4, $t4, 1
addi $t2, $t2, -1           #countdown
j loopF
leaveLoopF:
li $t2, 0
sb $t2, 0($t1)
#move $a1, $t1
li $v0, 10
syscall
#PART 5
caseL:
lw $t1, arg2_addr       #t1 has arg2
li $t4, 0   #count cards
li $s0, 0   #merch cards
li $s1, 0   #pirate cards
loopL:
	lbu $t2, 0($t1)  #t2 has char
	li $t3, 5
	bgt $t4, $t3, exitLoopL
	li $t3, 'M'     #t3 is temp
	beq $t2, $t3, merchant
	li $t3, 'P'     #t3 is temp
	beq $t2, $t3, pirate
	j invalidHand
	merchant:
		lbu $t2, 1($t1)   #t2 has num
		addi $t2, $t2, -48
		li $t3, 3     #t3 is temp
		li $t5, 8     #t3 is temp
		bgt $t2, $t5, invalidHand
		blt $t2, $t3, invalidHand
		addi $t1, $t1, 2        #next set
		addi $t4, $t4, 1         #plus count
		addi $s0, $s0, 1     #add merch card
		j loopL
	pirate:
		lbu $t2, 1($t1)   #t2 has num
		addi $t2, $t2, -48
		li $t3, 1     #t3 is temp
		li $t5, 4     #t3 is temp
		bgt $t2, $t5, invalidHand
		blt $t2, $t3, invalidHand
		addi $t1, $t1, 2        #next set
		addi $t4, $t4, 1         #plus count
		addi $s1, $s1, 1      #add pirate card
		j loopL
exitLoopL:
li $t2, 6
bne $t4, $t2, invalidHand
sll $s0, $s0, 3
add $a0, $s0, $s1
li $v0, 1
syscall
li $v0, 10
syscall

Err1:
    li $v0, 4
    la $a0, args_err_msg
    syscall
    li $v0, 10
    syscall
invalid:
    la $a0, invalid_arg_msg
    li $v0, 4
    syscall
    li $v0, 10
    syscall
invalidHand:
    la $a0, invalid_hand_msg
    li $v0, 4
    syscall
    li $v0, 10
    syscall
zero1:
    la $a0, zero
    li $v0, 4
    syscall
    li $v0, 10
    syscall
infneg:
    la $a0, inf_neg
    li $v0, 4
    syscall
    li $v0, 10
    syscall
infpos:
    la $a0, inf_pos
    li $v0, 4
    syscall
    li $v0, 10
    syscall
nan1:
    la $a0, nan
    li $v0, 4
    syscall
    li $v0, 10
    syscall
   
li $v0, 10
syscall
