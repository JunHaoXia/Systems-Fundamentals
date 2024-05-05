######### Elven Li ##########
######### 113187290 ##########
######### elvli ##########

.text
.globl initialize
initialize:
  lb $t8, 332($a1)                              #saves last byte of buffer
  move $t0, $a1                                 #moves buffer location to $t0

  li $a1, 0                                     #load file in read mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a0, $v0                                 #moves file discriptor to $a0
  move $a1, $t0                                 #moves buffer address to $a1

  li $t0, 0                                     #total char read counter
  li $a2, 1                                     #loads number of char to be read from file 

  initialize_get_dim:
    li $v0, 14
    syscall

    bltz $v0, reset_buffer_loop                 #if read syscall wasn't successful, reset buffer

    lb $t1, 0($a1)                              #loads first byte from buffer

    li $t9, '1'                                 #check if char is in range ('1', '9')
    blt $t1, $t9, init_check_valid_dim          #if not then, reset buffer to zeros
    li $t9, '9'
    bgt $t1, $t9, reset_buffer_loop

    addi $t1, $t1, -48                          #converts char to dec by subtracting 48
    sb $t1, 0($a1)

    addi $a1, $a1, 4                            #increment buffer pointer

    addi $t0, $t0, 1                            #increment char read counter

    li $t9, 2                   
    beq $t0, $t9, initialize_read               #if char counter is 2, start read

    j initialize_get_dim

  init_check_valid_dim:
    addi $t1, $t1, -48
    beqz $t1, reset_buffer_loop
    addi $t1, $t1, 48

    li $t9, 13
    beq $t1, $t9, init_check_CR                 #branches to check_CR if byte is CR
    
    init_check_NL:
      lb $t1, 0($a1)                            #loads byte from buffer pointer
      li $t9, 10
      bne $t1, $t9, reset_buffer_loop           #if byte is not NL, then reset buffer to zeros
      j initialize_get_dim

    init_check_CR:
      li $v0, 14
      syscall                                   #if byte if CR, read next byte
      j init_check_NL

  initialize_read:
    li $v0, 14                                  #reads next char from file
    syscall

    beqz $v0, initialize_end                    #if at the end of the file, branch to initialize_end

    lb $t1, 0($a1)                              #loads first byte of buffer

    li $t9, '0'                                 #checks if char is in range ('0', '9')
    blt $t1, $t9, check_CR_or_NL                #if char is less than '0', then check if its carriage return (CR) or new line (NL)
    li $t9, '9'                       
    bgt $t1, $t9, reset_buffer_loop             #if char is greater than '9', then reset buffer to zeros

    addi $t1, $t1, -48                          #converts char from ASCII to decimal
    sb $t1, 0($a1)

    addi $a1, $a1, 4                            #increment buffer pointer
    addi $t0, $t0, 1                            #increment char counter
    j initialize_read

  check_CR_or_NL:
    li $t9, 13                                  
    beq $t1, $t9, check_CR                      #branches to check_CR if byte is CR

    check_NL:
      lb $t1, 0($a1)                            #loads byte from buffer pointer
      li $t9, 10
      bne $t1, $t9, reset_buffer_loop           #if byte is not NL, then reset buffer to zeros
      j initialize_read

    check_CR:
      li $v0, 14  
      syscall                                   #if byte if CR, read next byte
      j check_NL

    j initialize_read

  reset_buffer_loop:
    bltz $t0, reset_buffer_end                  #branch when char counter is 0

    sb $0, 0($a1)                               #set byte at buffer pointer to $0
    
    addi $a1, $a1, -4                           #decrement buffer pointer
    addi $t0, $t0, -1                           #decrement char counter
    
    j reset_buffer_loop

  reset_buffer_end:
    li $v0, 16                                  #closes the file to prevent memory leaks
    syscall

    li $v0, -1                                  #sets $v0 to -1 if file was invalid
    jr $ra

  initialize_end:
    li $v0, 16                                  #closes the file to prevent memory leaks
    syscall

    sb $t8, 0($a1)                              #restores last byte of buffer

    li $v0, 1                                   #sets $v0 to 1 if read was successful, and file was valid
    jr $ra

.globl write_file
write_file:
  move $t0, $a1                                 #moves buffer to $t0

  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a0, $v0                                 #moves file descriptor to $a0
  move $a1, $t0                                 #moves buffer address to $a1

  li $t9, 10                                    #holds newline char
  li $a2, 1                                     #write 1 char to file during syscall

  lb $t0, 0($a1)                                #loads number of rows from buffer
  addi $t0, $t0, 48                             #converts rows from dec to ASCII
  sb $t0, 0($a1)                                #stores converted number back into buffer
  li $v0, 15
  syscall                                       #writes first byte of buffer to file
  sb $t9, 0($a1)
  li $v0, 15
  syscall                                       #writes new line
  addi $a1, $a1, 4                              #increments buffer pointer

  lb $t1, 0($a1)                                #loads number of columns from buffer
  addi $t1, $t1, 48                             #converts rows from dec to ASCII
  sb $t1, 0($a1)                                #stores converted number back into buffer
  li $v0, 15
  syscall                                       #writes first byte of buffer to file
  sb $t9, 0($a1)
  li $v0, 15
  syscall                                       #writes new line
  addi $a1, $a1, 4                              #increments buffer pointer

  addi $t0, $t0, -48                            #converts rows from ASCII to dec
  addi $t1, $t1, -48                            #converts columns from ASCII to dec
  add $t2, $0, $t0                              #makes copy of rows
  add $t3, $0, $t1                              #makes copy of columns

  write_loop:
    beqz $t3, write_increment                   #if column counter is zero, this row as been iterated through

    lb $t8, 0($a1)                              #loads byte at buffer pointer
    addi $t8, $t8, 48                           #converts byte from dec to ASCII
    sb $t8, 0($a1)                              #stores converted byte back into buffer pointer

    li $v0, 15
    syscall                                     #writes first byte of buffer to file

    addi $a1, $a1, 4                            #increment buffer pointer
    addi $t3, $t3, -1                           #decrements column counter

    j write_loop

  write_increment:
    addi $t2, $t2, -1                           #decrements row counter
    beqz $t2, write_end                         #if row counter is zero, the entire array has been iterated through

    addi $a1, $a1, -4                           #decrements buffer pointer
    sb $t9, 0($a1)                              #loads new line to buffer pointer
    li $v0, 15
    syscall                                     #writes new line
    addi $a1, $a1, 4                            #increments buffer pointer

    add $t3, $0, $t1                            #resets column counter

    j write_loop

  write_end:
    li $v0, 16
    syscall                                     #closes the files to prevent memory leaks
    jr $ra

.globl rotate_clkws_90  
rotate_clkws_90:
  move $t9, $a0                                 #moves buffer to $t9
  move $a0, $a1                                 #moves filename to $a0
  
  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a1, $t9                                 #moves buffer to $a1
  li $a2, 1                                     #write one char at a time
  li $t7, 10                                    #loads NL to $t7

  lb $t0, 0($a1)                                #loads row int from buffer
  lb $t1, 4($a1)                                #loads column int from buffer
  sb $t0, 4($a1)                                #swaps their positions because of the rotation
  sb $t1, 0($a1)

  li $v0, 15                         
  syscall                                       #writes the new row to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  li $v0, 15                         
  syscall                                       #writes the new column to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  add $t2, $0, $t0                              #original rows counter
                          
  sll $t4, $t1, 4                                 #column * 4 = num bits to increment
  
  addi $t9, $t0, -1                             #row - 1
  mult $t4, $t9                                 #(row - 1) * num bits to increment
  mflo $t5                                      #where to start

  add $a1, $a1, $t5                             #move pointer to where to start

  rotate_90_loop:
    beqz $t2, rotate_90_increment               #if row counter is zero, branch rotate_90_increment
    li $v0, 15
    syscall                                     #writes byte at buffer pointer to file

    subu $a1, $a1, $t4                          #moves pointer to next
    addi $t2, $t2 -1                            #decrement row counter

    j rotate_90_loop

  rotate_90_increment:
    add $a1, $a1, $t5				                    #moves pointer back to where it was before last rotate_90_loop
    sb $t7, 0($a1)                              #saves NL to buffer
    li $v0, 15
    syscall                                     #write NL to file

    addi $a1, $a1, 4   
    add $a1, $a1, $t5				                  
    add $t2, $0, $t0                            #reset original rows counter
    addi $t1, $t1, -1                           #decrements row counter
    beqz $t1, rotate_90_end                     #if column counter is zero, writing is down

    j rotate_90_loop

  rotate_90_end:
    li $v0, 16
    syscall                                     #closes the file to prevent memory leaks
    jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
  move $t9, $a0                                 #moves buffer to $t9
  move $a0, $a1                                 #moves filename to $a0
  
  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a1, $t9                                 #moves buffer to $a1
  li $a2, 1                                     #write one char at a time
  li $t7, 10                                    #loads NL to $t7

  lb $t0, 0($a1)                                #loads row int from buffer
  lb $t1, 4($a1)                                #loads column int from buffer

  li $v0, 15                         
  syscall                                       #writes the new row to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  li $v0, 15                         
  syscall                                       #writes the new column to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  add $t2, $0, $t0                              #original rows counter

  mult $t0, $t1                                 #row * column
  mflo $t4                                      #total bytes
  addi $t4, $t4, -4                             #where to start
  
  add $a1, $a1, $t4                             #moves buffer to where to start

  rotate_180_loop:
    beqz $t2, rotate_180_increment              #if row counter is zero, branch rotate_90_increment
    li $v0, 15
    syscall                                     #writes byte at buffer pointer to file

    addi $a1, $a1, -4                            #moves pointer to next
    addi $t2, $t2 -1                            #decrement row counter

    j rotate_180_loop

  rotate_180_increment:
    addi $a1, $a1, 4				                    #moves pointer back to where it was before last rotate_90_loop
    sb $t7, 0($a1)                              #saves NL to buffer
    li $v0, 15
    syscall                                     #write NL to file

    addi $a1, $a1, -4   		                  
    add $t2, $0, $t0                            #reset original rows counter
    addi $t1, $t1, -1                           #decrements row counter
    beqz $t1, rotate_180_end                    #if column counter is zero, writing is down

    j rotate_180_loop

  rotate_180_end:
    li $v0, 16
    syscall                                     #closes the file to prevent memory leaks
    jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
  move $t9, $a0                                 #moves buffer to $t9
  move $a0, $a1                                 #moves filename to $a0
  
  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a1, $t9                                 #moves buffer to $a1
  li $a2, 1                                     #write one char at a time
  li $t7, 10                                    #loads NL to $t7

  lb $t0, 0($a1)                                #loads row int from buffer
  lb $t1, 4($a1)                                #loads column int from buffer
  sb $t0, 4($a1)                                #swaps their positions because of the rotation
  sb $t1, 0($a1)

  li $v0, 15                         
  syscall                                       #writes the new row to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer
  
  li $v0, 15                         
  syscall                                       #writes the new column to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  add $t2, $0, $t0                              #original rows counter
 
  addi $t8, $t1, -1                           
  sll $t4 $t8, 2                                 #(column - 1) * 4 = num bits to increment

  addi $t5, $t4, 4                              #how much to increment

  addi $t9, $t0, -1                             #row - 1
  mult $t4, $t0                                 #(row - 1) * num bits to increment
  mflo $t6                                      #byte to reset during after a loop

  add $a1, $a1, $t4                             #move pointer to where to start

  rotate_270_loop:
    beqz $t2, rotate_270_increment              #if row counter is zero, branch rotate_90_increment
    li $v0, 15
    syscall                                     #writes byte at buffer pointer to file

    add $a1, $a1, $t5                           #moves pointer to next
    addi $t2, $t2 -1                            #decrement row counter

    j rotate_270_loop

  rotate_270_increment:
    add $a1, $a1, $t6				                    #moves pointer back to where it was before last rotate_90_loop
    sb $t7, 0($a1)                              #saves NL to buffer
    li $v0, 15
    syscall                                     #write NL to file

    addi $a1, $a1, -4   
    add $a1, $a1, $t6				                  
    add $t2, $0, $t0                            #reset original rows counter
    addi $t1, $t1, -1                           #decrements row counter
    beqz $t1, rotate_270_end                    #if column counter is zero, writing is down

    j rotate_270_loop

  rotate_270_end:
    li $v0, 16
    syscall                                     #closes the file to prevent memory leaks
    jr $ra

.globl mirror
mirror:
  move $t9, $a0                                 #moves buffer to $t9
  move $a0, $a1                                 #moves filename to $a0
  
  li $a1, 1                                     #load file in write mode
  li $a2, 0                                     #to be ignored, set to 0
  li $v0, 13                                    #load file opcode
  syscall

  move $a1, $t9                                 #moves buffer to $a1
  li $a2, 1                                     #write one char at a time
  li $t7, 10                                    #loads NL to $t7

  lb $t0, 0($a1)                                #loads row int from buffer
  lb $t1, 4($a1)                                #loads column int from buffer

  li $v0, 15                         
  syscall                                       #writes the new row to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  li $v0, 15                         
  syscall                                       #writes the new column to the file
  sb $t7, 0($a1)
  li $v0, 15
  syscall                                       #write a NL to the file
  addi $a1, $a1, 4                              #increments buffer pointer

  add $t2, $0, $t0                              #original rows counter

  sll $t4, $t1, 2                               #multiplies column by 4 to get bit count
  addi $t4, $t4, -4                             #where to start
  
  add $a1, $a1, $t4                             #moves buffer to where to start

  mirror_loop:
    beqz $t3, mirror_increment                  #if row counter is zero, branch rotate_90_increment
    li $v0, 15
    syscall                                     #writes byte at buffer pointer to file

    addi $a1, $a1, -4                           #moves pointer to next
    addi $t3, $t3 -1                            #decrement column counter

    j mirror_loop

  mirror_increment:
    addi $a1, $a1, 4				                    #moves pointer back to where it was before last rotate_90_loop
    sb $t7, 0($a1)                              #saves NL to buffer
    li $v0, 15
    syscall                                     #write NL to file

    addi $a1, $a1, -4   		                  
    add $t3, $0, $t1                            #reset original column counter
    addi $t0, $t0, -1                           #decrements row counter
    beqz $t0, mirror_end                        #if column counter is zero, writing is down

    j mirror_loop

  mirror_end:
    li $v0, 16
    syscall                                     #closes the file to prevent memory leaks
    jr $ra

.globl duplicate
duplicate:
  lb $t0, 0($a0)                                #loads num rows
  lb $t1, 4($a0)                                #loads num columns
  addi $a0, $a0, 8                              #increment buffer pointer to start of array

  li $t2, 0                                     #column counter
  li $t3, 1                                     #row counter

  li $t4, 1                                     #holds exponent (exp) value
  li $t5, 0                                     #decimal value of row
  
  to_bin:
    lb $t6, 0($a0)                              #loads byte at buffer pointer
    beqz $t6, calc_exp                          #if byte is zero, branch to calculate_exp
    add $t5, $t5, $t4                           #adds exp to sum

    calc_exp: 
      sll $t4, $t4, 1                           #multiplies exp by 2

      addi $t2, $t2, 1                          #increment column counter
      beq $t2, $t1, save_row_value              #if column counter = num columns, branch save_row_value

      addi $a0, $a0, 4                          #increments buffer pointer

      j to_bin

    save_row_value:
      addi $t0, $t0, 1                          #increment number of rows
      beq $t0, $t3, diplicates_none             #if num rows = rows counter, branch no duplicates
      addi $t0, $t0, -1                         #decrements number of rows

      sb $t5, 0($a0)                            #stores row sum into last column of row

      addi $t7, $t3, -1                         #$t7 = row counter - 1 (duplicate row counter)
      addi $t3, $t3, 1                          #increment row counter

      lb $t8, 0($a0)                            #loads row sum into last column of row

      move $t9, $a0                             #moves buffer to $t9
      bnez $t7, duplicates_check_values         #if row counter - 1 != zero, branch duplicates_check_values

    to_bin_increment:
      move $a0, $t9                             #moves buffer to back $a0

      li $t2, 0                                 #resets column counter
      li $t4, 1                                 #resets exp value
      li $t5, 0                                 #resets sum of row

      addi $a0, $a0, 4                          #increments buffer pointer

      j to_bin

    duplicates_check_values:
      sll $t6, $t1, 2                           #multiples num column by 4 for num bits to increment

      subu $a0, $a0, $t6                        #moves pointer to $start of row

      lb $t5, 0($a0)                            #loads byte at buffer pointer
      beq $t8, $t5, duplicates_found            #if row values equal, then duplicate is found, branch duplicates_found
      addi $t7, $t7, -1                         #decrement duplicate row counter

      beqz $t7, to_bin_increment                #if duplicate row counter is zero

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





