	.data
src:	.asciiz "Xin Chao"
des:	.asciiz "        " 
	.text 
	.globl main 
	
main: 
	la $t0, src
	la $t2, des 
	addi $t4, $t2, 0  
	
	j Start
While:
	sb $t1, 0($t2)
	addi $t0, $t0, 1
	addi $t2, $t2, 1
Start: 
	lb $t1, 0($t0)
	bgt $t1, 122, Else
	blt $t1, 97, Else
	
	sub $t1, $t1, 32
Else:
	bnez $t1, While
	
	addi $a0, $t4, 0 
	addi $v0, $zero, 4
	syscall
	
	addi $v0, $zero, 10
	syscall
