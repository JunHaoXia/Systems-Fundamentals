############## JunHao Xia ##############
############## 113196003 #################
############## junxia ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:	
  lw $t2, 0($a0)					    #loads total_nodes
  lw $t0, 8($a0)                                            #loads size_of_node
  lw $t1, 16($a0)                                           #loads curr_num_of_nodes

  beq $t1, $t2, nodes_full                                  #if current nodes = max nodes, branch nodes_full
  addi $a0, $a0, 16                                         #move pointer to curr_num_of_nodes
  addi $t1, $t1, 1                                          #increase curr_num_of_nodes by 1
  sw $t1, 0($a0)                                            #store increase value into curr_num_of_nodes
  addi $a0, $a0, 8					    #moves pointer to start if nodes set
  
  mul $t2, $t0, $t1				            #t2 is starting position

  add $a0, $a0, $t2					    #moves array pointer to start of array
  move $v0, $a0                                             #store array pointer into v0
  li $t9, 0						    #byte counter
  
  initialize_person:
    beq, $t0, $t9, initialize_person_end                    #if byte counter = max length, branch person_initialize_end

    sb $0, 0($a0)                                           #stores 0 into byte

    addi $a0, $a0, 1                                        #increments byte
    addi $t9, $t9, 1                                        #increment byte counter
    j initialize_person
  initialize_person_end:
    jr $ra
  nodes_full:
    li $v0, -1
    jr $ra

.globl add_person_property
add_person_property:
addi $t4, $a0, 0                        #save beginning pointer of network
lw $t5, 16($a0)				#loads current amount of nodes in network
lw $t6, 8($a0)				#loads max node length
#Checks if a2 contains "NAME"
    lb $t0, 0($a2)
    li $t1, 'N'
    bne $t0, $t1, invalid
     
    lb $t0, 1($a2)
    li $t1, 'A'
    bne $t0, $t1, invalid
    
    lb $t0, 2($a2)
    li $t1, 'M'
    bne $t0, $t1, invalid
    
    lb $t0, 3($a2)
    li $t1, 'E'
    bne $t0, $t1, invalid
    
    lb $t0, 4($a2)
    bnez $t0, invalid                             #checks if $a2 is exactly equal to "NAME"
#Checks if person in a1 exists
is_person_exists:
  beqz $t5, invalid
  
  lw $t1, 8($a0)                                 #loads max length of persons name
  addi $a0, $a0, 24				#moves pointer to start of node array
  
  li $t2, 0					 #node counter
  
  person_iterate_set:
     beq $t5, $t2, invalid			 #if node counter = current nodes, branch invalid
     beq $a0, $a1, person_exists                 #if node in array = $a1, branch person_exists
  	
  person_iterate_set_incr:
    addi $t2, $t2, 1				#increment node counter
    add $a0, $a0, $t1				#moves array pointer to next node
    
    j person_iterate_set
#Checks a3 value size
check_val_size:
    li $t1, 0					#val char/byte counter
    
    val_size_loop:                              #loop to count val size
      lb $t2, 0($a3)				                #loads first byte of name
      addi $a3, $a3, 1						#increments to val pointer
      addi $t1, $t1, 1						#increments val char/byte counter
      
      beqz $t2, val_size_end					#branch val_size_end, when you reach null pointer
      
      j val_size_loop						                            
      
     val_size_end:
       subu $a3, $a3, $t1				 #resets val pointer
       bgt $t1, $t6, invalid				 #if val size is greater than max length, branch invalid_val_size
#Check if the value is unqiue in network
    move $a0, $t4                                        #reset poniter of network
check_val_unique:
  li $t0, 0                                                 #length counter

  name_get_length:
    lb $t9, 0($a3)                                          #loads first char of $a3
    beqz $t9, name_get_length_end                           #if char is null, branch name_get_length_end
    addi $t0, $t0, 1                                        #increment length counter
    addi $a3, $a3, 1                                        #increment name counter
    j name_get_length
  
  name_get_length_end:
    subu $a3, $a3, $t5                                      #reset name pointer
  
    addi $a0, $a0, 24					   #moves pointer to start of node array
    li $t2, 0						   #node counter
    li $t3, 0						   #holds total amount node array was incremented
  
  name_iterate_set:
     beq $t5, $t2, add_person_loop				      #if node counter = current nodes, branch add_person_loop
     li $t1, 0						      #holds total amount of bytes were incremented
     
     name_node_check:
        beq $t1, $t0, name_network_check                    #if total bytes incremented = length of name, branch name_network_check
        beq $t6, $t1, invalid			                      #if total amount nodes incremented = person max length, person exists
        
  	lb $t8, 0($a0)					                                #loads char at pointer of network
  	lb $t9, 0($a3)					                                #loads char at pointer of node person
  	
  	bne $t8, $t9, name_iterate_set_incr		                  #if both chars are not equal increment array
  	
  	addi $a0, $a0, 1				                                #increments network pointer
  	addi $a3, $a3, 1				                                #increments name pointer
  	addi $t1, $t1, 1				                                #increments amount nodes were incremented
  	
  	j name_node_check
  	
  name_iterate_set_incr:
    addi $t2, $t2, 1					                              #increment node counter
    subu $a0, $a0, $t1					                            #moves array pointer to back to start of current node
    add $a0, $a0, $t6					                              #moves array pointer to next node
    subu $a3, $a3, $t1					                            #resets name pointer
    
    add $t3, $t3, $t6					                              #adds node max length to total amount array was incremented
    
    j name_iterate_set
  
  name_network_check:
    lb $t7, 1($a0)                      
    bnez $t7, name_iterate_set_incr                         #if next byte is not null, branch name_iterate_set_incr
    j invalid

add_person_loop:
      lb $t2, 0($a3)                                       #loads byte at name pointer
      sb $t2, 0($a1)                                       #loads byte at node address pointer
       
      addi $a1, $a1, 1                                     #increments node pointer
      addi $a3, $a3, 1                                     #increments name pointer
       
      beqz $t2, add_person_end                             #if name byte = null, branch add_person_end
       
      j add_person_loop
       
    add_person_end:                                        #sets $v0 to 1
     	li $v0, 1
     	jr $ra
  
  invalid:                                                  #if name_prop doesnt exactly = "NAME" or person node address does not exist in network
    li $v0, 0                                               #or name length is greater than max length or name already exists in network set $v0 to 0
    jr $ra

.globl get_person
get_person:
  lw $t0, 16($a0)					                                  #loads current amount of nodes in network
  
  beqz $t0, person_not_found                                        #if there are no nodes in the network, branch person_not_found
  
  li $t5, 0                                                 #length counter

  name_get_length1:
    lb $t9, 0($a1)                                          #loads first char of $a1
    beqz $t9, name_get_length_end1                           #if char is null, branch name_get_length_end
    addi $t5, $t5, 1                                        #increment length counter
    addi $a1, $a1, 1                                        #increment name counter
    j name_get_length1
  
  name_get_length_end1:
    subu $a1, $a1, $t5                                      #reset name pointer
  
    lw $t1, 8($a0)                                          #loads max length of persons name
    addi $a0, $a0, 24					                              #moves pointer to start of node array
  
    li $t2, 0						                                    #node counter
    li $t3, 0						                                    #holds total amount node array was incremented
  
  name_iterate_set:
     beq $t0, $t2, person_not_found1				                          #if node counter = current nodes, branch person_not_found
     li $t4, 0						                                  #holds total amount of bytes were incremented
     
     name_node_check1:
        beq $t4, $t5, name_network_check1                    #if total bytes incremented = length of name, branch name_network_check
        beq $t1, $t4, person_found1			                      #if total amount nodes incremented = person max length, person exists
        
  	lb $t8, 0($a0)					                                #loads char at pointer of network
  	lb $t9, 0($a1)					                                #loads char at pointer of node person
  	
  	bne $t8, $t9, name_iterate_set_incr1		                  #if both chars are not equal increment array
  	
  	addi $a0, $a0, 1				                                #increments network pointer
  	addi $a1, $a1, 1				                                #increments name pointer
  	addi $t4, $t4, 1				                                #increments amount nodes were incremented
  	
  	j name_node_check1
  	
  name_iterate_set_incr1:
    addi $t2, $t2, 1					                              #increment node counter
    subu $a0, $a0, $t4					                            #moves array pointer to back to start of current node
    add $a0, $a0, $t1					                              #moves array pointer to next node
    subu $a1, $a1, $t4					                            #resets name pointer
    
    add $t3, $t3, $t1					                              #adds node max length to total amount array was incremented
    
    j name_iterate_set1
  
  name_network_check1:
    lb $t6, 1($a0)                      
    bnez $t6, name_iterate_set_incr1                         #if next byte is not null, branch name_iterate_set_incr
  
  person_found:
    subu $a0, $a0, $t4					                            #moves array pointer to back to start of current node
    move $v0, $a0                                           #moves address of node in array to $v0
    jr $ra
  
  person_not_found:
    li $v0, 0
    jr $ra


.globl add_relation
add_relation:
#check if person1 exits
addi $sp, $sp, -32                                      #allocates 32 bytes in stack pointer
    sw $ra, 0($sp)					#saves return address to stack pointer
    sw $a0, 8($sp)                                          #saves network address to stack pointer
    sw $a1, 16($sp)                                         #saves name1 address to stack pointer
    sw $a2, 24($sp)                                         #saves name2 address to stack pointer
    
    jal get_person                                         #checks if address is in the network
    beqz $v0, invalid
    
    lw $ra, 0($sp)                                          #loads return address from stack pointer
    lw $a0, 8($sp)                                          #loads network address from stack pointer
    lw $a1, 16($sp)                                         #loads name1 address from stack pointer
    lw $a2, 24($sp)                                         #loads name2 address from stack pointer
#check if person2 exits
    move $a1, $a2                                          #move person2 into a1
    jal get_person                                         #checks if address is in the network
    beqz $v0, invalid
    
    lw $ra, 0($sp)                                          #loads return address from stack pointer
    lw $a0, 8($sp)                                          #loads network address from stack pointer
    lw $a1, 16($sp)                                         #loads name1 address from stack pointer
    lw $a2, 24($sp)                                         #loads name2 address from stack pointer
    addi $sp, $sp, 32                                       #deallocates 32 bytes in stack pointer
#check if edges is maxxed
lw $t0, 4($a0)                                              #get max num of edges
lw $t1, 20($20)                                             #get curr num of edges
beq $t0, $t1, invalid
#check if 
  jr $ra

.globl add_relation_property
add_relation_property:
  jr $ra

.globl is_a_distant_friend
is_a_distant_friend:
  jr $ra
