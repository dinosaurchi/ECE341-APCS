.data 
# Data Buffers
fileName:	
	.ascii "                          " 
enter:	.asciiz "\n"
space:	.asciiz " "
matA:	.asciiz " - Matrix A : "
error:	.asciiz "Error : Illegal size of 2 matrices \n"
dotMat: .asciiz "\n ** Dot product of matrices A and B \n"
mulMat:	.asciiz "\n ** Multiply 2 matrices A and B \n"
line: 	.asciiz "-----------------------------\n"
subline: .asciiz "----------\n"


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
	# Inverse Matrix 
	la $a0, arr1 
	lw $a1, m1
	jal Determinant
	
	#-------------------------------------
	# Dot Product of 2 Matrices A and B  
	la $t0, arr1 
	lw $t1, m1
	lw $t2, n1
	la $t3, arr2
	lw $t4, m2
	lw $t5, n2
			
	li $v0, 4
	la $a0, dotMat  
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
			
	jal elMatrix
	addi $sp, $sp, 24
	
	
	#-------------------------------------
	# Multiply 2 Matrices A and B  
	la $t0, arr1 
	lw $t1, m1
	lw $t2, n1
	la $t3, arr2
	lw $t4, m2
	lw $t5, n2
			
	li $v0, 4
	la $a0, mulMat  
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
			
	jal multiMatrix
	addi $sp, $sp, 24




	
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
elMatrix:
 	# Load back the args 
	lw $t5, 20($a0) # n2
	lw $t4, 16($a0) # m2
	lw $t3, 12($a0) # arr2
	lw $t2, 8($a0) # n1
	lw $t1, 4($a0) # m1 
	lw $t0, 0($a0) # arr1 
	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	addi $v0, $0, 0 # default is return 0
	
	bne $t1, $t4, Error_elMatrix # If m1 != m2  => game over 
	bne $t2, $t5, Error_elMatrix # If n1 != n2  => game over 
	
	la $t7, temp1 # load array temp1
	addi $v0, $t7, 0 # return value = temp1 address
	
	mul $t6, $t1, $t2 # t6 = n1 * m1 = n2 * m2 
	sll $t6, $t6, 2 # t6 = 4 * (n1 * m1) 
	add $t6, $t0, $t6 # t6 = arr + 4 * (n1 * m1) 
	
	j Start_elMatrix
While_elMatrix:
	
	lw $t1, 0($t0)
	lw $t2, 0($t3) 
	mul $t1, $t1, $t2 # Calculate the Dot product
	sw $t1, 0($t7)    

	addi $t3,$t3, 4
	addi $t7,$t7, 4
	addi $t0 $t0, 4
Start_elMatrix:
	bne $t0, $t6, While_elMatrix
	
	
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
	
	j Exit_elMatrix
	
Error_elMatrix:
	li $v0, 4
	la $a0, line  
	syscall 

	li $v0, 4
	la $a0, error  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 

Exit_elMatrix:
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra 
	
	
	
#---------------
multiMatrix: 
	# Load back the args 
	lw $t5, 20($a0) # n2
	lw $t4, 16($a0) # m2
	lw $t3, 12($a0) # arr2
	lw $t2, 8($a0) # n1
	lw $t1, 4($a0) # m1 
	lw $t0, 0($a0) # arr1 
	
	addi $sp, $sp, -12
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	
	bne $t2, $t4, Error_multiMatrix # If n1 != m2 => game over 
	
	# Because at this time, t2 = t4, so t2 is redundant (or vice versa), so we can use it for another purpose
	la $t2, temp1 # the resultant array 
	
	li $t6, 0 # t6 = 0  -> respect to i 
	j StartOuter_multiMatrix
WhileOuter_multiMatrix:
		li $t7, 0 # t7 = 0  -> respect to j 
		j StartInner1_multiMatrix
	WhileInner1_multiMatrix:
			mul $t9, $t6, $t5
			add $t9, $t9, $t7 # t9 = n2 * t6 + t7 
			sll $t9, $t9, 2 # t9 = 4 * (n2 * t6 + t7)
			add $t9, $t9, $t2 # t9 = temp1 + 4 * (n2 * t6 + t7)  => temp1[i][j]
			li $s0, 0 # s0 = 0
			sw $s0, 0($t9) # Mem[temp1 + 4 * (n2 * i + j)] = 0
			
			li $t8, 0 # t8 = 0  -> respect to k
			j StartInner2_multiMatrix
		WhileInner2_multiMatrix:
			#---Load arr1[i][k]
			mul $s1, $t6, $t4 
			add $s1, $s1, $t8 # s1 = n1 * t6 + t8
			sll $s1, $s1, 2 # s1 = 4 * (n1 * t6 + t8)
			add $s1, $s1, $t0 # s1 = arr1 + 4 * (n1 * t6 + t8)  
			lw  $s1, 0($s1) # s1 = Mem [arr1 + 4 * (n1 * t6 + t8)]  => arr1[i][k]
			
			#---Load arr2[k][j]
			mul $s2, $t8, $t5 
			add $s2, $s2, $t7 # s2 = n2 * t8 + t7
			sll $s2, $s2, 2 # s2 = 4 * (n2 * t8 + t7)
			add $s2, $s2, $t3 # s2 = arr2 + 4 * (n2 * t8 + t7)
			lw  $s2, 0($s2) # s2 = Mem [arr2 + 4 * (n2 * t8 + t7)]  => arr2[k][j]
			
			mul $s1, $s1, $s2 # s1 = arr1[i][k] * arr2[k][j]
			add $s0, $s0, $s1 # s0 += arr1[i][k] * arr2[k][j]
			sw $s0, 0($t9) # Mem[temp1 + 4 * (n2 * i + j)] += arr1[i][k] * arr2[k][j]
			
			addi $t8, $t8, 1
		StartInner2_multiMatrix:
			bne $t8, $t4, WhileInner2_multiMatrix
		addi $t7, $t7, 1
	StartInner1_multiMatrix:
		bne $t7, $t5, WhileInner1_multiMatrix
	addi $t6, $t6, 1
StartOuter_multiMatrix:
	bne $t6, $t1, WhileOuter_multiMatrix

	
	# print resultant matrix 
	addi $a0, $t2, 0 
	lw $a1, m1
	lw $a2, n2
	jal PrintMatrix 
	
	li $v0, 4
	la $a0, line  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 
	
	j Exit_multiMatrix
	
Error_multiMatrix:
	li $v0, 4
	la $a0, line  
	syscall 

	li $v0, 4
	la $a0, error  
	syscall 
	
	li $v0, 4
	la $a0, enter  # Print newline 
	syscall 

Exit_multiMatrix:
	lw $s1, 8($sp)	
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 12
	jr $ra 
	
	
#---------------
inverseMatrix:
	
	



	

Determinant:
	addi $sp, $sp, -60
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $a0, 8($sp)
	sw $a1, 12($sp) 
	swc1 $f1, 16($sp)
	swc1 $f2, 20($sp)
	swc1 $f3, 24($sp)
	swc1 $f4, 28($sp)
	sw $t0, 32($sp)
	sw $t1, 36($sp)
	sw $t2, 40($sp)
	sw $t3, 44($sp)
	sw $t4, 48($sp)
	sw $t5, 52($sp)
	sw $t6, 56($sp)
	
	lwc1 $f0, 0 # default return 0
	# t0,  t1, t2,   t3 are ...
	# i,  j,  j1,   j2  in the C++ code respectively 
	
	# s0 = allocated 2D array 
	
	blt $a1, 1, Exit_Determinant  # if n < 1 -> error 
	beq $a1, 1, Exit_Determinant_det_1  # if n == 1 ->  return arr[0][0]
	
	
	li $t2, 0 # j1 = 0
	j Start1_Determinant
While1_Determinant:
	addi $t4, $a0, 0 # backup $a0 
	
	li $v0, 9 #sbrk
	subi $a0, $a1, 1  
	sll $t5, $a0, 2 
	mul $a0, $t5, $a0 # malloc(((n-1)*4) * (n-1))  
	syscall 
	addi $s0, $v0, 0 # s0 = address of allocated pointer array with size (n-1)*4 -> array m 
	
	addi $a0, $t4, 0 # restore $a0
		
		li $t0,1 # i = 1
		j Start3_Determinant
	While3_Determinant:
		li $t3, 0 # j2 = 0
		
			li $t1, 0 # j = 0
			j Start4_Determinant
		While4_Determinant:
			beq $t2, $t1, Continue4_Determinant # If j == j1
			# Otherwise
			subi $t5, $t0, 1 # t5 = i - 1
			mul $t5, $t5, $a1 # t5 = (i-1)*n
			add $t5, $t5, $t3 # t5 = (i-1)*n + j2
			sll $t5, $t5, 2
			add $t5, $t5, $s0 # t5 = array m + (i-1)*n + j2
			
			mul $t6, $t0, $a1 # t6 = n * i
			add $t6, $t6, $t1 # t6 = n * i + j
			sll $t6, $t6, 2
			add $t6, $t6, $a0 # t6 = arr + n * i + j
			lwc1 $f3, 0($t6) # t6 = arr[i][j]
			swc1 $f3, 0($t5) # m[i-1][j2] = arr[i][j]
			
			addi $t3, $t3, 1 # j2 += 1
			
		Continue4_Determinant:
			addi $t1, $t1, 1
		Start4_Determinant:
			bne $t1, $a1, While4_Determinant
		
		addi $t0, $t0, 1
	Start3_Determinant:
		bne $t0, $a1, While3_Determinant
	
	# Calculate   f2 = pow(-1.0,j1+2.0)
	addi $t5, $t2, 2 # t5 = j1 + 2
	li $t6, 0 #t6 = 0
	s.s $f2, -1
		j Start5_Determinant
	While5_Determinant:
		s.s $f3, -1	
		mul.s $f2, $f2, $f3
		addi $t6, $t6, 1
	Start5_Determinant:
		blt $t6, $t5, While5_Determinant
		
	s.s $f3, 0
	add.s $f3, $f0, $f3 #backup $f0
	addi $t5, $a0, 0 #backup $a0
	addi $t6, $a1, 0 #backup $a1
	
	addi $a0, $s0, 0 # a0 = m
	subi $a1, $a1, 1 # a1 = n - 1
	jal Determinant
	
	addi $a0, $t5, 0 #restore $a0
	addi $a1, $t6, 0 #restore $a1
	mul.s $f0, $f0, $f2 # $f0 = Determinant(m, n-1) * pow(-1.0,j1+2.0)
	
	addi $t2, $t2, 1
Start1_Determinant:
	bne $t2, $a1, While1_Determinant
	
	j Exit_Determinant


Exit_Determinant_det_1: 
	lwc1 $f0, 0($a0)  # v0 = a[0][0] 
	j Exit_Determinant
	
Exit_Determinant_det_2: 
	lwc1 $f0, 0($a0) # t0 = a[0][0] 
	lwc1 $f1, 12($a0) # t1 = a[1][1] 
	mul.s $f0, $f0, $f1 # t0 = a[1][1] * a[0][0]
	
	lwc1 $f1, 4($a0) 
	lwc1 $f2, 8($a0) 
	mul.s $f1, $f1, $f2 # t1 = a[1][0] * a[0][1]
	
	sub.s $f0, $f0, $f1 # return a[1][1] * a[0][0] - t1 = a[1][0] * a[0][1]

Exit_Determinant:
	lw $t0, 32($sp)
	lw $t1, 36($sp)
	lw $t2, 40($sp)
	lw $t3, 44($sp)
	lw $t4, 48($sp)
	lw $t5, 52($sp)
	lw $t6, 56($sp)
	lwc1 $f4, 28($sp)
	lwc1 $f3, 24($sp)
	lwc1 $f2, 20($sp)
	lwc1 $f1, 16($sp)
	lw $a1, 12($sp) 
	lw $a0, 8($sp)
	lw $s0, 4($sp) 
	lw $ra, 0($sp) 
	addi $sp, $sp, 60
	jr $ra 
	
	
CoFactor:
	addi $sp, $sp, -76
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $a0, 8($sp)
	sw $a1, 12($sp) 
	swc1 $f1, 16($sp)
	swc1 $f2, 20($sp)
	swc1 $f3, 24($sp)
	swc1 $f4, 28($sp)
	sw $t0, 32($sp)
	sw $t1, 36($sp)
	sw $t2, 40($sp)
	sw $t3, 44($sp)
	sw $t4, 48($sp)
	sw $t5, 52($sp)
	sw $t6, 56($sp)
	sw $t7, 60($sp)
	sw $s3, 72($sp)
	sw $s2, 68($sp)
	sw $s1, 64($sp)
	
	# i,   j,   ii,   jj,   i1,   j1  are ....
	#t0   t1   t2    t3    t4    t5   respectively 
	
	li $v0, 9 #sbrk
	subi $a0, $a1, 1  
	sll $a0, $a0, 2 
	mul $a0, $a0, $a0 # malloc(((n-1)*4) * (n-1))  
	syscall 
	addi $s0, $v0, 0 # s0 = address of allocated pointer array with size (n-1)*4 -> array c
	
	li $t1, 0 # j = 0
	j Start1_CoFactor
While1_CoFactor:
		li $t0, 0 # i = 0
		j Start2_CoFactor
	While2_CoFactor:
		# Form the adjoint a_ij 
		li $t4, 0 # i1 = 0
			li $t2, 0 # ii = 0
			j Start3_CoFactor
		While3_CoFactor:
			beq $t2, $t0, Continue3_CoFactor # if (ii == i)
				
				li $t5, 0 # j1 = 0
				li $t3, 0 # jj = 0
				j Start4_CoFactor
			While4_CoFactor:
				beq $t3, $t1, Continue4_CoFactor # if (jj == j)
				
				mul $t6, $t4, $a1 
				add $t6, $t6, $t5
				sll $t6, $t6, 2
				add $t6, $t6, $s0 # t6 = c + i1 * n + j1
				
				mul $t7, $t2, $a1 
				add $t7, $t7, $t3
				sll $t7, $t7, 2
				add $t7, $t7, $a0 # t7 = c + ii * n + jj
				lw $t7, 0($t7)
				
				sw $t7, 0($t6) # c[i1][j1] = a[ii][jj]
				
				addi $t5, $t5, 1
			Continue4_CoFactor:
				addi $t3, $t3, 1
			Start4_CoFactor:
				bne $t3, $a1, While4_CoFactor
		addi $t4, $t4, 1
		Continue3_CoFactor:
			addi $t2, $t2, 1
		Start3_CoFactor:
			bne $t2, $a1, While3_CoFactor

		addi $t8, $a0, 0
		addi $t9, $a1, 0

		addi $a0, $s0, 0 # a0 = c
		subi $a1, $a1, 1 # a1 = n - 1
		jal Determinant

		addi $a0, $t8, 0
		addi $a1, $t9, 0
		
		la $t8, temp1 
		# Calculate   f2 = pow(-1.0,j + i +2.0)
		add $s1, $t1, $t0  # s1 = i + j
		addi $s1, $s1, 2 # s1 = i + j + 2
		
		li $s2, 0 #s2 = 0
		s.s $f2, -1
			j Start5_Cofactor
		While5_Cofactor:
			s.s $f3, -1	
			mul.s $f2, $f2, $f3
			addi $s2, $s2, 1
		Start5_Cofactor:
			blt $s2, $s1, While5_Cofactor
			
		mul.s $f2, $f2, $f0 # f2 = pow(-1.0,j + i +2.0) * Determinant(c,n-1)
		
		mul $s1, $t0, $a1 
		add $s1, $s1, $t1
		sll $s1, $s1, 2
		add $s1, $s1, $t8 
		swc1 $f2, 0($s1) # b[i][j] = pow(-1.0,i+j+2.0) * det;

		addi $t0, $t0, 1
	Start2_CoFactor:
		bne $t0, $a1, While2_CoFactor
		
	addi $t1, $t1, 1
Start1_CoFactor:
	bne $t1, $a1, While1_CoFactor
	
	lw $s3, 72($sp)
	lw $s2, 68($sp)
	lw $s1, 64($sp)
	lw $t0, 32($sp)
	lw $t1, 36($sp)
	lw $t2, 40($sp)
	lw $t3, 44($sp)
	lw $t4, 48($sp)
	lw $t5, 52($sp)
	lw $t6, 56($sp)
	lw $t7, 60($sp)
	lwc1 $f4, 28($sp)
	lwc1 $f3, 24($sp)
	lwc1 $f2, 20($sp)
	lwc1 $f1, 16($sp)
	lw $a1, 12($sp) 
	lw $a0, 8($sp)
	lw $s0, 4($sp) 
	lw $ra, 0($sp) 
	addi $sp, $sp, 76
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
	
