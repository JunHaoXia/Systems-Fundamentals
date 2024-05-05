# This is a test file. Use this file to run the functions in hw3.asm
#
# Change data section as you deem fit.
# Change filepath if necessary.
.data
Filename: .asciiz "inputs/outputs.txt"
OutFile: .asciiz "out.txt"
Buffer:
    .word 2	# num rows
    .word 3	# num columns
    # matrix
    .word 1 2 3 4 5 6 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0


.text
main:
 #la $a0, Filename
 #la $a1, Buffer
 #jal initialize
 la $a1, Filename
 la $a0, Buffer
 jal rotate_clkws_270

 # write additional test code as you deem fit.

 li $v0, 10
 syscall

.include "hw3.asm"
