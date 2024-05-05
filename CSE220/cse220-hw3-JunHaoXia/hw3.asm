######### JunHao Xia ##########
######### 113196003 ##########
######### junxia ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
  lb $t8, 332($a1)                              #save the last byte of buffer into t8
  move $t0, $a1                                 #move buffer to $t0

  li $a1, 0                                     #loads the file in read mode
  li $a2, 0                                     #set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a0, $v0                                 #moves file discriptor to $a0
  move $a1, $t0                                 #moves buffer address to $a1

  li $t0, 0                                     #total char read counter
  li $a2, 1                                     #loads number of char to be read from file 

  findDim:
    li $v0, 14
    syscall

    bltz $v0, resetBuffer                 #reset buffer if read syscall wasn't successful

    lb $t4, 0($a1)                              #loads first byte from buffer

    li $t6, '1'                                 #check if char is between '1' and '9'
    blt $t4, $t6, checkDim                      #if not then, reset the buffer to zeros
    li $t6, '9'
    bgt $t4, $t6, resetBuffer

    addi $t4, $t4, -48                          #converts ASCII to decimal
    sb $t4, 0($a1)

    addi $a1, $a1, 4                            #move buffer pointer

    addi $t0, $t0, 1                            #increase char read counter

    li $t6, 2                   
    beq $t0, $t6, initialize_read               #start read after getting row and column

    j findDim

  checkDim:
    addi $t4, $t4, -48
    beqz $t4, resetBuffer
    addi $t4, $t4, 48

    li $t6, 13
    beq $t4, $t6, checkCR                 #branches to checkCR if byte is CR
    
    checkNL:
      lb $t4, 0($a1)                            #loads byte from buffer pointer
      li $t6, 10
      bne $t4, $t6, resetBuffer           #reset buffer to zeros if byte isn't NL
      j findDim

    checkCR:
      li $v0, 14
      syscall                                   #if byte is CR, read next byte
      j checkNL

  initialize_read:
    li $v0, 14                                  #reads next char from the file
    syscall

    beqz $v0, initialize_end                    #branch to initialize_end if at the end of the file

    lb $t4, 0($a1)                              #loads first byte of buffer

    li $t6, '0'                                 #checks if char is between '0' and '9'
    blt $t4, $t6, checkCRNL                #check if its carriage return (CR) or new line (NL)
    li $t6, '9'                       
    bgt $t4, $t6, resetBuffer             #if char is greater than '9', reset buffer to zeros

    addi $t4, $t4, -48                          #converts char from ASCII to decimal
    sb $t4, 0($a1)

    addi $a1, $a1, 4                            #move buffer pointer
    addi $t0, $t0, 1                            #increas char counter
    j initialize_read

  checkCRNL:
    li $t6, 13                                  
    beq $t4, $t6, checkCR2                      #branches to checkCR2 if byte is CR

    checkNL2:
      lb $t4, 0($a1)                            #loads byte from buffer pointer
      li $t6, 10
      bne $t4, $t6, resetBuffer           #if byte is not NL, reset buffer to zeros
      j initialize_read

    checkCR2:
      li $v0, 14  
      syscall                                   #if byte if CR, read next byte
      j checkNL2

    j initialize_read

  resetBuffer:
    bltz $t0, resetBufferExit                  #branch when char counter is 0

    sb $0, 0($a1)                               #set byte at buffer pointer to $0
    
    addi $a1, $a1, -4                           #move buffer pointer
    addi $t0, $t0, -1                           #decrease char counter
    
    j resetBuffer

  resetBufferExit:
    li $v0, 16                                  #closes the file to prevent memory leaks
    syscall

    li $v0, -1                                  # -1 if file was invalid
    jr $ra

  initialize_end:
    li $v0, 16                                  #closes the file to prevent memory leaks
    syscall

    sb $t8, 0($a1)                              #restores last byte of buffer

    li $v0, 1                                   # 1 if read was successful, and file was valid
 jr $ra

.globl write_file
write_file:
  move $t0, $a1                  #move buffer address to $t0

  li $a1, 1                      #load the file in write mode
  li $a2, 0                      # set to 0
  li $v0, 13                     #load file opcode
  syscall

  move $a0, $v0                  #file descriptor to $a0
  move $a1, $t0                  #buffer address to $a1

  li $t9, 10                     #t9 is newline char
  li $a2, 1                      #set to write 1 char to file during syscall

  lb $t0, 0($a1)                 #loads #rows from buffer
  addi $t0, $t0, 48              #converts from dec to ASCII
  sb $t0, 0($a1)                 #stores converted back into buffer
  li $v0, 15
  syscall                       
  sb $t9, 0($a1)
  li $v0, 15
  syscall                        #new line
  addi $a1, $a1, 4               #move buffer pointer

  lb $t1, 0($a1)                 #loads #columns from buffer
  addi $t1, $t1, 48              #converts from dec to ASCII
  sb $t1, 0($a1)                 #stores converted back into buffer
  li $v0, 15
  syscall                       
  sb $t9, 0($a1)
  li $v0, 15
  syscall                        #new line
  addi $a1, $a1, 4               #move buffer pointer

  addi $t0, $t0, -48             #rows from ASCII to dec
  addi $t1, $t1, -48             #columns from ASCII to dec
  add $t2, $0, $t0               #copy of rows
  add $t3, $0, $t1               #copy of columns

  write_loop:
    beqz $t3, write_increment                  

    lb $t7, 0($a1)                              #loads byte at buffer pointer into t7
    addi $t7, $t7, 48                           #converts byte from dec to ASCII
    sb $t7, 0($a1)                              #stores t7 back into buffer pointer

    li $v0, 15
    syscall                                     #writes first byte of buffer to file

    addi $a1, $a1, 4                            #move buffer pointer
    addi $t3, $t3, -1                           #decrease column counter

    j write_loop

  write_increment:
    addi $t2, $t2, -1                           #decrease row counter
    beqz $t2, write_end                        

    addi $a1, $a1, -4                           #decrements buffer pointer
    sb $t9, 0($a1)                              #loads new line to buffer pointer
    li $v0, 15
    syscall                                     #writes new line
    addi $a1, $a1, 4                            #move buffer pointer

    add $t3, $0, $t1                            #resets column counter

    j write_loop

  write_end:
    li $v0, 16
    syscall                                     #closes the files to prevent memory leaks
    jr $ra

.globl rotate_clkws_90
rotate_clkws_90:
move $t0, $a0                                 #moves buffer to $t0
move $a0, $a1                                   #move filename into a0
  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a0, $v0                                 #moves file descriptor to $a0
  move $a1, $t0                                 #moves buffer address to $a1

  li $t9, 10                                    #holds newline char
  li $a2, 1                                     #write 1 char to file during syscall

  lb $t0, 0($a1)                                #loads number of rows from buffer       t0 is row
  addi $t0, $t0, 48                             #converts rows from dec to ASCII
  
  addi $a1, $a1, 4                              #moves pointer to columns
  
  lb $t1, 0($a1)                                #loads number of columns from buffer    t1 is col
  addi $t1, $t1, 48                             #converts cols from dec to ASCII
  
  sb $t1, 0($a1)                                #stores converted row into col position back into buffer     
  li $v0, 15
  syscall                                       #writes first byte of buffer to file
  sb $t9, 0($a1)
  li $v0, 15
  syscall                                       #writes new line
  #addi $a1, $a1, -4                              #return buffer pointer to row section

  sb $t0, 0($a1)                                #stores converted number back into buffer    
  li $v0, 15
  syscall                                       #writes first byte of buffer to file
  sb $t9, 0($a1)
  li $v0, 15
  syscall                                       #writes new line

  addi $t0, $t0, -48                            #converts rows from ASCII to dec
  addi $t1, $t1, -48                            #converts columns from ASCII to dec
  add $t2, $0, $t0                              #makes copy of OG rows NEW columns
  add $t3, $0, $t1                              #makes copy of OG columns NEW rows
  add $t0, $a1, $0                              #make save of buffer pointer into t0
  li $t4, 1               #col counter
  li $t5, 1               #row counter
######
move_cols90:
bgt $t4, $t3, exit90
move_rows90:
bgt $t5, $t2, exitRows90
sub $t6, $t2, $t5                              # (cols( rows - row_counter)) + col_counter
mul $t6, $t6, $t3
add $t6, $t6, $t4
sll $t6, $t6, 2            #mult by 4
add $a1, $a1, $t6          #move buffer pointer

lb $t1, 0($a1)                                #loads number from buffer       
addi $t1, $t1, 48                             #converts number from dec to ASCII
sb $t1, 0($a1)                                #stores converted value back into buffer     
li $v0, 15
syscall                                       #writes first byte of buffer to file

add $a1, $0, $t0               #reset pointer to front
addi $t5, $t5, 1
j move_rows90
exitRows90:
li $t5, 1               #reset row counter
sb $t9, 0($a1)
li $v0, 15
syscall                                       #writes new line
addi $t4, $t4, 1      #increase col counter
j move_cols90
exit90:
li $v0, 16
    syscall                                     #closes the files to prevent memory leaks
    jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
move $t0, $a0                                 #moves buffer to $t0
move $a0, $a1                                   #move filename into a0

  li $a1, 1                      #load file in write mode
  li $a2, 0                      # set to 0
  li $v0, 13                     #load file opcode
  syscall

  move $a0, $v0                  #file descriptor to $a0
  move $a1, $t0                  #buffer address to $a1

  li $t9, 10                     #t9 is newline char
  li $a2, 1                      #set to write 1 char to file during syscall

  lb $t0, 0($a1)                 #loads #rows from buffer
  addi $t0, $t0, 48              #converts from dec to ASCII
  sb $t0, 0($a1)                 #stores converted back into buffer
  li $v0, 15
  syscall                       
  sb $t9, 0($a1)
  li $v0, 15
  syscall                        #new line
  addi $a1, $a1, 4               #move buffer pointer

  lb $t1, 0($a1)                 #loads #columns from buffer
  addi $t1, $t1, 48              #converts from dec to ASCII
  sb $t1, 0($a1)                 #stores converted back into buffer
  li $v0, 15
  syscall                       
  sb $t9, 0($a1)
  li $v0, 15
  syscall                        #new line

  addi $t0, $t0, -48             #rows from ASCII to dec
  addi $t1, $t1, -48             #columns from ASCII to dec
  add $t2, $0, $t0               #copy of rows
  add $t3, $0, $t1               #copy of columns
  add $t0, $a1, $0               #make save of buffer pointer into t0
  li $t4, 0               #col counter
  li $t5, 1               #row counter
###########
move_rows180:
bgt $t5, $t2, exit180
move_cols180:
beq $t4, $t3, exitCols180
sub $t6, $t2, $t5                              # (cols( rows - row_counter)) + (col - col_counter)
mul $t6, $t6, $t3
sub $t7, $t3, $t4
add $t6, $t6, $t7
sll $t6, $t6, 2            #mult by 4
add $a1, $a1, $t6          #move buffer pointer

lb $t1, 0($a1)                                #loads number from buffer       
addi $t1, $t1, 48                             #converts number from dec to ASCII
sb $t1, 0($a1)                                #stores converted value back into buffer     
li $v0, 15
syscall                                       #writes first byte of buffer to file

add $a1, $0, $t0               #reset pointer to front
addi $t4, $t4, 1        #increase col counter
j move_cols180
exitCols180:
li $t4, 0               #reset col counter
sb $t9, 0($a1)
li $v0, 15
syscall                                       #writes new line
addi $t5, $t5, 1      #increase row counter
j move_rows180
exit180:
li $v0, 16
    syscall                                     #closes the files to prevent memory leaks
    jr $ra


.globl rotate_clkws_270
rotate_clkws_270:
move $t0, $a0                                 #moves buffer to $t0
move $a0, $a1                                   #move filename into a0
  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a0, $v0                                 #moves file descriptor to $a0
  move $a1, $t0                                 #moves buffer address to $a1

  li $t9, 10                                    #holds newline char
  li $a2, 1                                     #write 1 char to file during syscall

  lb $t0, 0($a1)                                #loads number of rows from buffer       t0 is row
  addi $t0, $t0, 48                             #converts rows from dec to ASCII
  
  addi $a1, $a1, 4                              #moves pointer to columns
  
  lb $t1, 0($a1)                                #loads number of columns from buffer    t1 is col
  addi $t1, $t1, 48                             #converts cols from dec to ASCII
  
  sb $t1, 0($a1)                                #stores converted row into col position back into buffer     
  li $v0, 15
  syscall                                       #writes first byte of buffer to file
  sb $t9, 0($a1)
  li $v0, 15
  syscall                                       #writes new line
  #addi $a1, $a1, -4                              #return buffer pointer to row section

  sb $t0, 0($a1)                                #stores converted number back into buffer    
  li $v0, 15
  syscall                                       #writes first byte of buffer to file
  sb $t9, 0($a1)
  li $v0, 15
  syscall                                       #writes new line

  addi $t0, $t0, -48                            #converts rows from ASCII to dec
  addi $t1, $t1, -48                            #converts columns from ASCII to dec
  add $t2, $0, $t0                              #makes copy of OG rows NEW columns
  add $t3, $0, $t1                              #makes copy of OG columns NEW rows
  add $t0, $a1, $0                              #make save of buffer pointer into t0
  li $t4, 0               #col counter
  li $t5, 0               #row counter
######
move_cols270:
beq $t4, $t3, exit270
move_rows270:
beq $t5, $t2, exitRows270
mul $t6, $t5, $t3              # (cols(row_counter)) + (cols - col_counter)
sub $t7, $t3, $t4
add $t6, $t6, $t7
sll $t6, $t6, 2            #mult by 4
add $a1, $a1, $t6          #move buffer pointer

lb $t1, 0($a1)                                #loads number from buffer       
addi $t1, $t1, 48                             #converts number from dec to ASCII
sb $t1, 0($a1)                                #stores converted value back into buffer     
li $v0, 15
syscall                                       #writes first byte of buffer to file

add $a1, $0, $t0               #reset pointer to front
addi $t5, $t5, 1               #increase row counter
j move_rows270
exitRows270:
li $t5, 0               #reset row counter
sb $t9, 0($a1)
li $v0, 15
syscall                                       #writes new line
addi $t4, $t4, 1      #increase col counter
j move_cols270
exit270:
li $v0, 16
    syscall                                     #closes the files to prevent memory leaks
    jr $ra


.globl mirror
mirror:
move $t0, $a0                                 #moves buffer to $t0
move $a0, $a1                                   #move filename into a0

  li $a1, 1                      #load file in write mode
  li $a2, 0                      # set to 0
  li $v0, 13                     #load file opcode
  syscall

  move $a0, $v0                  #file descriptor to $a0
  move $a1, $t0                  #buffer address to $a1

  li $t9, 10                     #t9 is newline char
  li $a2, 1                      #set to write 1 char to file during syscall

  lb $t0, 0($a1)                 #loads #rows from buffer
  addi $t0, $t0, 48              #converts from dec to ASCII
  sb $t0, 0($a1)                 #stores converted back into buffer
  li $v0, 15
  syscall                       
  sb $t9, 0($a1)
  li $v0, 15
  syscall                        #new line
  addi $a1, $a1, 4               #move buffer pointer

  lb $t1, 0($a1)                 #loads #columns from buffer
  addi $t1, $t1, 48              #converts from dec to ASCII
  sb $t1, 0($a1)                 #stores converted back into buffer
  li $v0, 15
  syscall                       
  sb $t9, 0($a1)
  li $v0, 15
  syscall                        #new line

  addi $t0, $t0, -48             #rows from ASCII to dec
  addi $t1, $t1, -48             #columns from ASCII to dec
  add $t2, $0, $t0               #copy of rows
  add $t3, $0, $t1               #copy of columns
  add $t0, $a1, $0               #make save of buffer pointer into t0
  li $t4, 0               #col counter
  li $t5, 0               #row counter
###########
move_rowsM:
beq $t5, $t2, exitM
move_colsM:
beq $t4, $t3, exitColsM
mul $t6, $t5, $t3             # (cols(row_counter)) + (col - col_counter)
sub $t7, $t3, $t4
add $t6, $t6, $t7
sll $t6, $t6, 2            #mult by 4
add $a1, $a1, $t6          #move buffer pointer

lb $t1, 0($a1)                                #loads number from buffer       
addi $t1, $t1, 48                             #converts number from dec to ASCII
sb $t1, 0($a1)                                #stores converted value back into buffer     
li $v0, 15
syscall                                       #writes first byte of buffer to file

add $a1, $0, $t0               #reset pointer to front
addi $t4, $t4, 1        #increase col counter
j move_colsM
exitColsM:
li $t4, 0               #reset col counter
sb $t9, 0($a1)
li $v0, 15
syscall                                       #writes new line
addi $t5, $t5, 1      #increase row counter
j move_rowsM
exitM:
li $v0, 16
    syscall                                     #closes the files to prevent memory leaks
    jr $ra


.globl duplicate
duplicate:
  lb $t0, 0($a0)                                #loads num rows
  lb $t1, 4($a0)                                #loads num columns
  addi $a0, $a0, 8                              #move buffer pointer to start of array

  li $t2, 0                                     #column counter
  li $t3, 1                                     #row counter

  li $t4, 1                                     #holds exponent value
  li $t5, 0                                     #decimal value of row
  
  convBin:
    lb $t6, 0($a0)                              #loads byte at buffer pointer
    beqz $t6, calc_exp                          #branch to calculate_exp if byte is zero
    add $t5, $t5, $t4                           #adds exp to sum

    calc_exp: 
      sll $t4, $t4, 1                           #multiply exp by 2

      addi $t2, $t2, 1                          #increase column counter
      beq $t2, $t1, save_row_value              

      addi $a0, $a0, 4                          #move buffer pointer

      j convBin

    save_row_value:
      addi $t0, $t0, 1                          #increase number of rows
      beq $t0, $t3, diplicates_none          
      addi $t0, $t0, -1                         #decrease number of rows

      sb $t5, 0($a0)                            #stores row sum into last column of row

      addi $t7, $t3, -1                         #duplicate row counter
      addi $t3, $t3, 1                          #increase row counter

      lb $t8, 0($a0)                            #loads row sum into last column of row

      move $t9, $a0                             #moves buffer to $t9
      bnez $t7, duplicates_check_values         #if row counter - 1 != zero, branch duplicates_check_values

    convBin_increment:
      move $a0, $t9                             #moves buffer to back $a0

      li $t2, 0                                 #resets column counter
      li $t4, 1                                 #resets exp value
      li $t5, 0                                 #resets sum of row

      addi $a0, $a0, 4                          #move buffer pointer

      j convBin

    duplicates_check_values:
      sll $t6, $t1, 2                           #multiples num column by 4

      subu $a0, $a0, $t6                        #moves pointer to $start of row

      lb $t5, 0($a0)                            #loads byte at buffer pointer
      beq $t8, $t5, duplicates_found            #if row values equal, then duplicate is found, branch duplicates_found
      addi $t7, $t7, -1                         #decrement duplicate row counter

      beqz $t7, convBin_increment               #if duplicate row counter is zero

      j duplicates_check_values

  duplicates_found:
    addi $t3, $t3, -1                           #row counter - 1
    move $v1, $t3                               #moves second row to $v1
    li $v0, 1
    jr $ra

  diplicates_none:
    li $v0, -1
    li $v1, 0
 jr $ra
