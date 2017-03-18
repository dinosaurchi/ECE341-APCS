	.data
str:	.asciiz "Testing Strlen"
	.text 
	.globl main 
	
main: 
	la $t0, str
	addi $t3, $t0, 0 
	j Start
While:
	addi $t0, $t0, 1
	
Start: 
	lb $t1, 0($t0) 
	bnez $t1, While 
	
	sub $t0, $t0, $t3
	addi $a0, $t0, 0 
	addi $v0, $zero, 1 
	syscall 

