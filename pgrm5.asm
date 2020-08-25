# File Name: pgrm5.asm 
# Author: Mushfiq A Rashid - University of Texas at Dallas
# Modification History: This code was written on November 17, 2019 by Mushfiq Rashid
# Procedures: 
#   main: Prompts user to enter file name, opens that file, reads the contents in the file, and convert them
#   hexaConversion: Takes in a hexadecimal value and converts it into a decimal
#   loopNewLine: Finds the new line and keeps looping till that point 
#   calc: Uses the operands and operator from the memory to perform mathematical operations on them in the correct precedence

.include	"macros.asm"							#include the file containing macros

.data	
	userFileName: 	.space 200						# User file name in the directory format
	hex_content: 	.space 1024 						# Contents of the file 
	promptMessage: 	.asciiz "Please input file name in directory: "		# Prompt message for inputting file name in directory format
	m1:		.asciiz "Input: "					# Message saying input
	m2:		.asciiz "Result: "					# Message saying Result
	m3:		.asciiz "Save: "					# Message saying Save
	m4:		.asciiz "Read: "					# Message saying Read
	m5:		.asciiz "Memory cleared"				# Message saying memory cleared
	o1:		.word 0							# First operand
	o2:		.word 0							# First operand
	op:		.word 0							# operator
	op_add:		.word 43						# addition operator
	op_sub:		.word 45						# subtraction operator
	op_mul:		.word 42						# multiplication operator
	op_div:		.word 47						# division operator
	op_mod:		.word 37						# modulus operator
	op_eq:		.word 61						# assignment operator
	op_s:		.word 115						# memory save
	op_r:		.word 114						# memory recall
	op_z:		.word 122						# memory clear
	saved:		.word 0							# saved
	

.text
#   main:
# Author: Mushfiq A Rashid - University of Texas at Dallas
# Modification History: This code was first written on November 1, 2019 by Mushfiq Rashid and then modified on November 16, 2019 by Mushfiq Rashid
# Description: Prompts user to enter file name in directory format, opens that file, reads the contents in the file, and convert them
# Arguments: None
	main:
	# Prompts the user for input
	li $v0, 4 			# specify Print String service 
	la $a0, promptMessage	 	# load address of prompt message
	syscall 			# print prompt message
	
	#Read string from user
	li $v0, 8 			# specify Input String service
	la $a0, userFileName 		# load address of userFileName
	li $a1, 200 			# specify maximum length of the name t 200 bytes
	
	add $s3, $a0, $zero 		# stores a0 in s3
	syscall 			# read user's string input
	jal loopNewLine 		# call the loopNewLine procedure
	
	# Open file
	li $v0, 13 			# specify open file service with appropriate syscall code
	move $a0, $s3 			# store file name
	li $a1, 0 			# for file opening
	li $a2, 0 			
	syscall				# open file
	move $s1, $v0 			# save in s1
	
	# Reads the content in the user file
	li $v0, 14 			# specify read file service with appropriate syscall code
	move $a0, $s1 			# move to s1
	la $a1, hex_content 		# load address of content
	li $a2 200 			# max size set to 200
	syscall 			# read file contents
	
	# Close file
	li $v0, 16 			# Specify close file service with the appropriate syscall code
	move $a0, $s1 			# File descriptor for closing
	syscall 			# Close the file
	
	la $a0, hex_content 		# store address of content
	jal hexaConversion		# go to hexaconversion function
	
	# End program
	li $v0, 10 			# specify end of main procedure
	syscall				# end program
	
#   loopNewLine:
# Author: Mushfiq A Rashid - University of Texas at Dallas
# Modification History: This code was written on November 1, 2019 by Mushfiq Rashid
# Description:  Finds the new line and keeps looping till that point 
# Arguments: None
	loopNewLine:			# calls the loopNewLine method
	li $t0, 0 			# initializes counter
	li $t1, 75 			# point of stop

	loop:				# loop
	beq $t0, $t1, e			# calls exit upon branch condition
	lb $t2, userFileName($t0) 	# store to t2
	bne $t2, 0x0a, incrementCounter # keep looping
	sb $zero, userFileName($t0) 	# put a 0 at the end

	incrementCounter:		# increment counter
	addi $t0, $t0, 1 		# increaese counter by 1
	j loop 				# jump to start of loop

	e:				# exit loop
	jr $ra				# return to main


#   hexaConversion:
# Author: Mushfiq A Rashid - University of Texas at Dallas
# Modification History: This code was first written on November 1, 2019 by Mushfiq Rashid and modified on November 15, 2019 by Mushfiq Rashid
# Description:  Takes in a hexadecimal value and converts it into a decimal, and calls the calc method to perform calculations on the hex numbers and operators
# Arguments: $a0 -> file content character
	hexaConversion:			
	add $s7, $a0, $zero 		# move a0 value to s1
	add $s2, $zero, $zero 		# store zero in s2
	add $t9, $zero, $zero 		# t9 -- flag to check if operator has been read
	
	loopConverter:
	lb $t0, 0($s7) 			# stores value
	beq $t0, $zero, end 		# call end
	li $t8, 13 			# store cr character
	beq $t0, $t8, loopDisplayer	# check for newline
	
	
	# Validity check
	li $t3, 48 			# store 0 ascii value
	bltu $t0, $t3, symbol	 	# encounter operator symbol
	li $t3, 57			# store 9 ascii value 			
	bgtu $t0, $t3, notAnInteger 	# go to notinteger
	
	# when integer value:  	
	addi $t1, $t0, -48 		
	j incrementer 			# go to incrementer
	
	notAnInteger:			# not an integer
	li $t3, 70			# check to see ifgreater than 'F' ascii code
	bltu $t3, $t0, letter	 	# -- s, r, z
	li $t3, 65			# check to see if lesser than A ascii code
	bgtu $t3, $t0, eq		# -- =
	
	addi $t1, $t0, -55 		
	j incrementer 			# go to incrementer
	
	letter:
#	sw $t0,op
#	li $t9,0			# set flag to true
	printS(m1)			# call print
	li $v0, 11
	move $a0, $t0			#move the argument to t0 register
	syscall
	printNL				# call print
	
	addi $sp,$sp,-4 		# move stack pointer 
	sw $ra,($sp)
	jal calc			# jump to calc method
	lw $ra,($sp)
	addi $sp,$sp,4			# move stack pointer back
	
	addi $s7, $s7, 3		# increment s7
	j loopConverter			# jump to loopconverter	
	
	#when equals
	eq:
	li $t9,0			# set flag to true
	printS(m1)			# call print
	li $v0, 11
	move $a0, $t0			# move value of first argument to t0 register
	syscall
	printNL				# call print
	
	addi $sp,$sp,-4			# move stack pointer 
	sw $ra,($sp)
	jal calc			# jump to calc method
	lw $ra,($sp)
	addi $sp,$sp,4			# move stack pointer back
	
	addi $s7,$s7, 3			# increment s7
	j loopConverter			# jump to loopconverter	

	#if it is a symbol
	symbol:				# symbol
	beqz $t9,f

	addi $sp,$sp,-4			# move stack pointer
	sw $ra,($sp)			# store pointer address
	jal calc			# jump to calc method
	lw $ra,($sp)
	addi $sp,$sp,4			# move stack pointer back
	
	f:
	addi $t9,$t9,1			# set flag to true
	printS(m1)			# call print string
	li $v0, 11
	move $a0, $t0			# move value of first argument to t0 register
	syscall
	printNL				# call print new line
	sw $t0,op
	
	addi $s7, $s7, 3		# increment s7
	j loopConverter			# jump to loopconverter	
	
	incrementer:			# incrementer 
	sll $s2, $s2, 4 		# shift by 4
	add $s2, $s2, $t1 		# add t1 to s2
	addi $s7, $s7, 1 		# increment s1
	j loopConverter 		# jump to loop converter
	
	loopDisplayer:			# for printing values
	printS(m1)			# call print string
	
	li $v0, 1 			# specify print integer service
	la $a0, 0($s2) 			# load address of s2 into a0
	syscall 			# print value

	printNL				# call print new line
	
	beqz $t9,f1
	sw $s2,o2
	j rep				# jump to rep 
	f1:				# f1 function
	sw $s2,o1
	rep:				# rep function
	add $s2, $zero, $zero 		# initialize s2 to 0
	addi $s7, $s7, 2 		# increment by 2
	j loopConverter			# jump unconditionally to loopconverter 				

	end:				# end program				
	jr $ra				# return
	

#   calc:
# Author: Mushfiq A Rashid - University of Texas at Dallas
# Modification History: This code was first written on November 16, 2019 by Mushfiq Rashid 
# Description:  Uses the operands and operator from the memory to perform mathematical operations on them in the correct precedence
# Arguments: none
calc:
	
#Switch cases 
#c0 calls memory save operation
c0:	lw $t1,op_s			# load save memory operation 
	bne $t0,$t1,c1
	printS(m3)			# call print string
	lw $t1,o1
	printInt($t1)			# call print for integer
	sw $t1,saved
	j exit2				#jumps to exit2
	
#c1 calls memory recall operation	
c1:	lw $t1,op_r			# load memory recall operation 
	bne $t0,$t1,c2
	printS(m4)			# call print string 
	lw $t1,saved
	printInt($t1)			# call print for integer
	beqz $t9,f2
	sw $t1,o2
	j exit2				#jumps to exit2
	f2:				#f2 function 
	sw $t1,o1
	j exit				#jumps to exit
	
#c2 calls memory clear operation
c2:	lw $t1,op_z			# load memory cleaer operation 
	bne $t0,$t1,c3
	printS(m5)			# call print for string
	sw $zero,saved
	j exit2				#jumps to exit2
	
#c3 executes add operation
c3:	addi $sp,$sp,-4			# move stack pointer
	sw $t0,($sp)			# store the stack pointer address
	lw $t0,op
	printS(m2)			# call print for string
	lw $t1,op_add
	bne $t0,$t1,c4
	_add(o1,o2)			#carry out the operation
	sw $s1,o1
	j exit				#jumps to exit

#c4 executes subtraction operation
c4:	lw $t1,op_sub			# load subtract operation 
	bne $t0,$t1,c5
	_sub(o1,o2)			#carry out the operation
	sw $s1,o1
	j exit				#jumps to exit
	
#c5 executes multiplication operation
c5:	lw $t1,op_mul			# load multiply operation 
	bne $t0,$t1,c6
	_mul(o1,o2)			#carry out the operation
	sw $s1,o1
	j exit				#jumps to exit
	
#c6 executes division operation	
c6:	lw $t1,op_div			# load divide operation 
	bne $t0,$t1,c7
	_div(o1,o2)			#carry out the operation
	sw $s1,o1
	j exit				#jumps to exit
	
#c7 executes modulus operation	
c7:	lw $t1,op_mod			# load modulus operation 
	bne $t0,$t1,exit
	_mod(o1,o2)			#carry out the operation
	sw $s1,o1
	
	# exit case working as a break statement
	exit:
	lw $t0,($sp)			#load to t0
	addi $sp,$sp,4			# move stack pointer
	
	# exit2 case working as a second break statement
	exit2:
	printNL				# call print new line
	jr $ra				#jumps to return address
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
