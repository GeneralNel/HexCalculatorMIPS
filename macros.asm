# File containing macros

.macro printS(%label)
	li $v0,4
	la $a0,%label
	syscall
.end_macro

.macro printNL
	li $v0, 11
	li $a0,10
	syscall
.end_macro

.macro printSpace
	li $v0, 11
	li $a0,32
	syscall
.end_macro

.macro printInt(%x)
	li $v0, 1
	add $a0,$zero,%x
	syscall
.end_macro

.macro printChar(%x)
	li $v0, 11
	addi $a0,$zero,%x
	syscall
.end_macro

.macro _add(%x, %y)
	
	lw $t1,%x
	lw $t2,%y
	add $s1, $t1, $t2
	
	printInt($t1)
	printSpace
	printChar(43)
	printSpace
	printInt($t2)
	printSpace
	printChar(61)
	printSpace
	printInt($s1)
.end_macro

.macro _sub(%x, %y)
	
	lw $t1,%x
	lw $t2,%y
	sub $s1, $t1, $t2
	
	printInt($t1)
	printSpace
	printChar(45)
	printSpace
	printInt($t2)
	printSpace
	printChar(61)
	printSpace
	printInt($s1)
.end_macro

.macro _mul(%x, %y)
	
	lw $t1,%x
	lw $t2,%y
	mul $s1, $t1, $t2
	
	printInt($t1)
	printSpace
	printChar(42)
	printSpace
	printInt($t2)
	printSpace
	printChar(61)
	printSpace
	printInt($s1)
.end_macro

.macro _div(%x, %y)
	
	lw $t1,%x
	lw $t2,%y
	div $t1, $t2
	mflo $s1
	
	printInt($t1)
	printSpace
	printChar(47)
	printSpace
	printInt($t2)
	printSpace
	printChar(61)
	printSpace
	printInt($s1)
.end_macro

.macro _mod(%x, %y)
	
	lw $t1,%x
	lw $t2,%y
	div $t1, $t2
	mfhi $s1
	
	printInt($t1)
	printSpace
	printChar(37)
	printSpace
	printInt($t2)
	printSpace
	printChar(61)
	printSpace
	printInt($s1)
.end_macro