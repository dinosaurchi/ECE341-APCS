	.data
src:	.asciiz " hello My gaMe worlD  "
des:	.asciiz "                      "
	.text 
	.globl main 
	
main:
	la, $s0, src
	la, $s1, src 
	addi, $s2, $s1, 0 
	
	j While 
Loop:
		j InnerWhile
	InnerLoop:
		addi $s0, $s0, 1
		addi $s1, $s1, 1
	InnerWhile:
		lb $t0, 0($s0)
		beq $t0, 32, InnerLoop  
	
	beqz $t0, Exit 
	bgt $t0, 122, Else
	blt $t0, 97, Else 
	
	sub $t0, $t0, 32 
	sb $t0, 0($s1) 
	
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j InnerWhile2
Else:	
	sb $t0, 0($s1) 
	
	j InnerWhile2
	InnerLoop2:
		sb $t0, 0($s1) 
		addi $s0, $s0, 1
		addi $s1, $s1, 1
	InnerWhile2:
		lb $t0, 0($s0)
		beqz $t0, Exit 
		bne $t0, 32, InnerLoop2
While: 
	lb $t0, 0($s0)
	bnez $t0, Loop 

Exit:	
	
	addi $a0, $s2, 0
	addi $v0, $zero, 4
	syscall 
	
	addi $v0, $zero, 10
	syscall 
	  

	
	  
	
	 
	
