.data 
# Data Buffers
fileName:	
	.ascii "                          " 
enter:	.asciiz "\n"
space:	.asciiz " "
matA:	.asciiz " - Matrix A : "
matB:	.asciiz " - Matrix B : "
mulMatA: .asciiz "Matrix A * const\n"
mulMatB: .asciiz "Matrix B * const\n"
plusMat: .asciiz "Plus matrices A and B \n"
line: 	.asciiz "-----------------------------\n"
subline: .asciiz "----------\n"
isIden:	.asciiz "Identity test : \n"
transA:	.asciiz "Transpose A \n"
transB:	.asciiz "Transpose B \n"

# Arrays
arr1:	.word 1:1000
arr2:	.word 1:1000

temp1:	.word 1:1000

const:	.word 0
m1:	.word 0 
n1:  	.word 0 
m2:	.word 0 
n2:  	.word 0 
buff:	.word 0  
	.text
	.globl main 
	
main: 
	# ENTER FILE NAME:
	#=================================================================================
	li $v0, 8 
	la $a0, fileName
	li $a1, 19
	syscall 
	
	addi $t1, $a1, 0
	subi $t1, $t1, 1
	add $t1, $t1, $a0 # # t1 = fileName[250 - 1]
	
	# Extrude the last '\n' character 
		j Start_CutString
	While_CutString:
		lb $t2, 0($t1) 
		bne $t2, 10, Skip_CutString
		addi $t0, $0, 0
		sb $t0, 0($t1) 
		j Exit_CutString
	Skip_CutString:
		beq $t2, 32, Skip_CutString2
		beq $t2, 0, Skip_CutString2
		j Exit_CutString
	Skip_CutString2:
		subi $t1, $t1, 1
	Start_CutString: 
		bge $t1, $a0, While_CutString
		
	Exit_CutString: 
	
	# ENTER CONSTANT:
	#=================================================================================
	li $v0, 5
	la $t0, const
	syscall 
	sw $v0, 0($t0) # save the constant to 'const' 
	
	# OPEN FILE:
	#=================================================================================
	li  $v0, 13           # system call for open file
	la  $a0, fileName     # input file name
	li  $a1, 0            # flags
	li  $a2, 0            # Open for reading (mode is 0: read, 1: write)
	syscall               # open a file (file descriptor returned in $a0)
	move $s0, $v0         # save the fd (syscall below will overwrite $a0)
	
	
	# MAIN CODES: 
	#=================================================================================
	
	la $a0, arr1 
	la $a1, m1
	la $a2, n1
	jal ReadMatrix 
	
	la $a0, arr2
	la $a1, m2
	la $a2, n2
	jal ReadMatrix 
	
	#-------------------------------------
	# Check Identity Matrix 
	
	li $v0, 4
	la $a0, isIden  
	syscall 

	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, matA  
	syscall 
	
	la $a0, arr1 
	lw $a1, m1
	lw $a2, n1
	jal checkMatrixIdentity
	
	addi $a0, $v0, 0 # Print result 
	li $v0, 1
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	li $v0, 4
	la $a0, matB
	syscall 
	
	la $a0, arr2
	lw $a1, m2
	lw $a2, n2
	jal checkMatrixIdentity
	
	addi $a0, $v0, 0 # Print result 
	li $v0, 1
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 

	
	#-------------------------------------
	# Transpose Matrix 
	
	li $v0, 4
	la $a0, transA  
	syscall 

	li $v0, 4
	la $a0, line  
	syscall 
	
	la $a0, arr1 
	lw $a1, m1
	lw $a2, n1
	jal transMatrix
	
	addi $a0, $v0, 0 
	lw $a1, n1
	lw $a2, m1
	jal PrintMatrix 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	
	li $v0, 4
	la $a0, transB
	syscall 

	li $v0, 4
	la $a0, line  
	syscall 
	
	la $a0, arr2
	lw $a1, m2
	lw $a2, n2
	jal transMatrix
	
	addi $a0, $v0, 0 
	lw $a1, n2
	lw $a2, m2
	jal PrintMatrix 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 	
	
	
	
	#-------------------------------------
	# Plus 2 Matrices 
	la $t0, arr1 
	lw $t1, m1
	lw $t2, n1
	la $t3, arr2
	lw $t4, m2
	lw $t5, n2
			
	li $v0, 4
	la $a0, plusMat  
	syscall 		
	
	li $v0, 4
	la $a0, line  
	syscall 
			
	addi $sp, $sp, -24
	addi $a0, $sp, 0
	# Store the args into stack 
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $t5, 20($sp)		
			
	jal plusMatrix
	addi $sp, $sp, 24

	# print resultant matrix 
	addi $a0, $v0, 0 
	lw $a1, m1
	lw $a2, n1
	jal PrintMatrix 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	
	#-------------------------------------
	# Multiply Matrix with a Constant 
	
	li $v0, 4
	la $a0, mulMatA  
	syscall 

	li $v0, 4
	la $a0, line  
	syscall 
	
	la $a0, arr1 
	lw $a1, m1
	lw $a2, n1
	lw $a3, const
	jal multiMatrixConst
	
	addi $a0, $v0, 0 
	lw $a1, m1
	lw $a2, n1
	jal PrintMatrix 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	
	li $v0, 4
	la $a0, mulMatB
	syscall 

	li $v0, 4
	la $a0, line  
	syscall 
	
	la $a0, arr2
	lw $a1, m2
	lw $a2, n2
	lw $a3, const
	jal multiMatrixConst
	
	addi $a0, $v0, 0 
	lw $a1, m2
	lw $a2, n2
	jal PrintMatrix 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	
	# CLOSE FILE: 
	#=================================================================================
	li  $v0, 16   # system call for close file
	move $a0, $s0 # Restore fd
	syscall       # close file
	
	### Exit program 
	addi $v0, $zero, 10
	syscall 
	

# PROCEDURE CODES:
#=================================================================================
#---------------
ReadMatrix: 
	addi $sp, $sp, -20   # keep a 3 * 4 bytes free space  
	sw $a0, 16($sp)
	sw $s0, 12($sp)	
	sw $a1, 8($sp) 
	sw $a2, 4($sp)
	sw $ra, 0($sp)
	
	addi $t0, $a0, 0 
	addi $t1, $a1, 0 
	addi $t2, $a2, 0 
	
	# Read m
	li  $v0, 14  # system call to read from file
	add $a0, $s0, $zero
	addi  $a1, $t1, 0   # address of buffer to store read data.
	li  $a2, 4   # read 4 bytes 
	syscall      # read from file

	# Read n
	li  $v0, 14  # system call to read from file
	add $a0, $s0, $zero
	addi  $a1, $t2, 0  # address of buffer to store read data.
	li  $a2, 4   # read 4 bytes 
	syscall      # read from file
			
	# Read array
	lw $t1, 0($t1) # t0 = m
	lw $t2, 0($t2) # t1 = n
	mul $t1, $t2, $t1 # t0 = m * n 
	
	sll $t1, $t1, 2 # t0 = n*m * 4
	# t0 = arr (in the 1st element of arr)
	add $v0, $zero, $t1 # Save the arr return value 
	add $t1, $t0, $t1 # t1 = arr + t1 (go to the end of the array)
	
		j Start_ReadMatrix
	WhileLoop_ReadMatrix:
		li  $v0, 14  # system call to read from file
		add $a0, $s0, $zero
		la  $a1, buff   # address of buffer to store read data.
		li  $a2, 4      # read 4 bytes 
		syscall         # read from file
		
		lw $t2, buff
		sw $t2, 0($t0) 
		
		addi $t0, $t0, 4		
	Start_ReadMatrix:
		bne $t1, $t0, WhileLoop_ReadMatrix

Exit_ReadMatrix:	
	lw $ra, 0($sp)
	lw $a2, 4($sp)
	lw $a1, 8($sp) 
	lw $s0, 12($sp)
	lw $a0, 16($sp)
	addi $sp, $sp, 20 # recover stack pointer for the previous procedure
	jr $ra


#---------------
PrintMatrix:
	
	add $t0, $zero, $a0 	
	la $t3, space
	la $t6, enter
	
	li $t1, 0 # t1 = 0
		j Start_PrintMatrix
	While_PrintMatrix:
			li $t2, 0 # t2 = 0
			j InnerStart_PrintMatrix
		InnerWhile_PrintMatrix:
			mul $t4, $t1, $a2 # t4 = n * t1 
			add $t4, $t4, $t2 # t4 = n * t1 + t2 
			sll $t4, $t4, 2 # t4  = 4 * (n * t1 + t2)
			add $t4, $t4, $t0 # t4 = arr + 4 * (n * t1 + t2)
			
			# Print arr[t1][t2] 
			lw $a0, 0($t4) 
			addi $v0, $zero, 1
			syscall 
			
			# Print space 
			addi $a0, $t3, 0
			addi $v0, $zero, 4
			syscall 
			
			addi $t2, $t2, 1
		InnerStart_PrintMatrix:
			bne $a2, $t2, InnerWhile_PrintMatrix
			
		# Print enter 
		addi $a0, $t6, 0
		addi $v0, $zero, 4
		syscall 
			
		addi $t1, $t1, 1
	Start_PrintMatrix:
		bne $a1, $t1, While_PrintMatrix
	
	jr $ra


#---------------
checkMatrixIdentity:
	addi $v0, $0, 0
	bne $a1, $a2, Exit_checkMatrixIdentity
	
	addi $t0, $0, 0
	j Start_checkMatrixIdentity
While_checkMatrixIdentity:
		addi $t1, $0, 0
		j InnerStart_checkMatrixIdentity
	InnerWhile_checkMatrixIdentity:
		mul $t2, $a2, $t0 # t2 = t0 * n  
		add $t2, $t2, $t1 # t2 = t0 * n + t1
		add $t2, $t2, $a0 # t2 = arr + t0 * n + t1 
		lw $t2, 0($t2) 
		
		beq $t0, $t1, t1_diff_t0
		beq $t2, 1, Continue_checkMatrixIdentity
		
		addi $v0, $0, 0
		j Exit_checkMatrixIdentity
		
	t1_diff_t0:	
		beq $t2, 0, Continue_checkMatrixIdentity
		
		addi $v0, $0, 0
		j Exit_checkMatrixIdentity
		
	Continue_checkMatrixIdentity:	
		addi $t1, $t1, 4
		
	InnerStart_checkMatrixIdentity:
		blt $t0, $a1, While_checkMatrixIdentity
	
	addi $t0, $t0, 4
Start_checkMatrixIdentity:
	blt $t0, $a1, While_checkMatrixIdentity
	
	addi $v0, $0, 1 # return 1
	
Exit_checkMatrixIdentity:
	jr $ra 


#---------------
multiMatrixConst:
	
	mul $t1, $a1, $a2 
	sll $t1, $t1, 2
	add $t1, $t1, $a0 # t1 = arr + n * m * 4
	
	la $t2, temp1 
	addi $v0, $t2, 0 # the return address for us
	
	j Start_multiMatrixConst
While_multiMatrixConst:
	lw $t0, ($a0)
	mul $t0, $t0, $a3 
	sw $t0, ($t2)
	addi $a0, $a0, 4
	addi $t2, $t2, 4
Start_multiMatrixConst:
	bne $a0, $t1, While_multiMatrixConst
	
	jr $ra 
	

#---------------
plusMatrix:
 	# Load back the args 
	lw $t5, 20($a0) # n2
	lw $t4, 16($a0) # m2
	lw $t3, 12($a0) # arr2
	lw $t2, 8($a0) # n1
	lw $t1, 4($a0) # m1 
	lw $t0, 0($a0) # arr1 
	
	addi $v0, $0, 0 # default is return 0
	
	bne $t1, $t4, Exit_plusMatrix # If m1 != m2 
	bne $t2, $t5, Exit_plusMatrix # If n1 != n2
	
	la $t7, temp1 # load array temp1
	addi $v0, $t7, 0 # return value = temp1 address
	
	mul $t6, $t1, $t2 # t6 = n1 * m1 = n2 * m2 
	sll $t6, $t6, 2 # t6 = 4 * (n1 * m1) 
	add $t6, $t0, $t6 # t6 = arr + 4 * (n1 * m1) 
	
	j Start_plusMatrix
While_plusMatrix:
	
	lw $t1, 0($t0)
	lw $t2, 0($t3) 
	add $t1, $t1, $t2 
	sw $t1, 0($t7)    
	
	addi $t3,$t3, 4
	addi $t7,$t7, 4
	addi $t0 $t0, 4
Start_plusMatrix:
	bne $t0, $t6, While_plusMatrix

Exit_plusMatrix:
	jr $ra 
	
	
#---------------
transMatrix:
	
	la $t3, temp1
	addi $v0, $t3, 0 # return address
	
	li $t0, 0
	j Start_transMatrix
While_transMatrix:
	li $t1, 0
		j InnerStart_transMatrix
	InnerWhile_transMatrix:
		mul $t4, $t0, $a2 # t4 = t0 * n
		add $t4, $t4, $t1 
		sll $t4, $t4, 2 # t4 = 4 * (t0 * n + t1)
		add $t4, $t4, $a0 # t2 = arr + 4 * (t0 * n + t1)
		lw $t4, 0($t4) 
	
		mul $t2, $t1, $a1 # t2 = t1 * m
		add $t2, $t2, $t0 # t2 = t1 * m + t0
		sll $t2, $t2, 2	 # t2 = 4 * (t1 * m + t0)
		add $t2, $t2, $t3 # t2 = temp1 + 4 * (t1 * m + t0)
		sw $t4, 0($t2) # t2 = temp1[t1 * m + t0]
		
		addi $t1, $t1, 1
	InnerStart_transMatrix:
		bne $t1, $a2, InnerWhile_transMatrix 
	
	addi $t0, $t0, 1
Start_transMatrix:
	bne $t0, $a1, While_transMatrix  

	jr $ra 