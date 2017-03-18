	.data 
# Data Buffers
fileName:	
	.asciiz "Week 4/Input.dat" 
enter:	.asciiz "\n"
space:	.asciiz " "
# Arrays
arr:	.word 1:200
temp1:	.word 1:200
temp2:	.word 1:200
join_arr:
	.word 1:200
not_nega:
	.word 1:200
nega:	.word 1:200

n_join_arr:
	.word 0
n_not_nega:
	.word 0 
n_nega:	.word 0
n:	.word 0 
x:  	.word 0 
buff:	.word 0  
	.text
	.globl main 
	
main: 
	# OPEN FILE:
	#=================================================================================
	li  $v0, 13           # system call for open file
	la  $a0,fileName      # input file name
	li  $a1, 0            # flags
	li  $a2, 0            # Open for reading (mode is 0: read, 1: write)
	syscall               # open a file (file descriptor returned in $a0)
	move $s0, $v0         # save the fd (syscall below will overwrite $a0)
	
	# SEARCH CODES: 
	#=================================================================================
	
	# Linear search ----- 
	addi $a3, $0, 1 # If a3 == 1, then read with 3 args.
	jal ReadPortion
	
	la $a0, arr 
	lw $a1, n 
	lw $a2, x
	
	jal LinearSearch
	
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	la $a0, enter 
	addi $v0, $zero, 4
	syscall 

	# Binary search ----- 
	addi $a3, $0, 1 # If a3 == 1, then read with 3 args.
	jal ReadPortion
	
	la $a0, arr 
	lw $a1, n 
	lw $a2, x
	jal BinarySearch
	
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	la $a0, enter 
	addi $v0, $zero, 4
	syscall 
	
	# Bubble sort ----- 
	addi $a3, $0, 0 # If a3 == 0, then read with 2 args.
	jal ReadPortion
	la $a0, arr 
	lw $a1, n 
	addi $a2, $0, 1 

	jal BubbleSort
	
	la $a0, arr 
	lw $a1, n 
	addi $a2, $0, 1 # a2 = 1 => go to new line after print
	jal PrintArray 

	# Insertion sort ----- 
	addi $a3, $0, 0 # If a3 == 0, then read with 2 args.
	jal ReadPortion
	la $a0, arr 
	lw $a1, n 
	addi $a2, $0, 0
	jal InsertionSort
	
	la $a0, arr 
	lw $a1, n 
	addi $a2, $0, 1 # a2 = 1 => go to new line after print
	jal PrintArray 
	
	# Merge sort ----- 	
	addi $a3, $0, 0 # If a3 == 0, then read with 2 args.
	jal ReadPortion
	
	la $a0, arr 
	lw $a1, n 
	jal DividePositiveNegative # Merge the orginal array first.
	
	la $a0, nega 
	lw $a1, n_nega
	addi $a2, $0, 0
	jal MergeSort
	
	la $a0, nega 
	lw $a1, n_nega
	addi $a2, $0, 0 # a2 = 0 => Do not go to new line after print
	jal PrintArray 
	
	la $a0, not_nega 
	lw $a1, n_not_nega
	addi $a2, $0, 1
	jal MergeSort
	
	la $a0, not_nega 
	lw $a1, n_not_nega
	addi $a2, $0, 1 # a2 = 1 => go to new line after print
	jal PrintArray 
	
	
	# Quick sort ----- 
	addi $a3, $0, 0 # If a3 == 0, then read with 2 args.
	jal ReadPortion
	
	la $a0, arr 
	lw $a1, n 
	jal DividePositiveNegative # Merge the orginal array first.
	
	la $a0, nega 
	lw $a1, n_nega
	addi $a2, $0, 0
	jal QuickSort
	
	la $a0, not_nega 
	lw $a1, n_not_nega
	addi $a2, $0, 1
	jal QuickSort
	
	la $a0, nega 
	lw $a1, n_nega
	la $a2, not_nega 
	lw $a3, n_not_nega	
	jal JointArrayInterpose		
	
	la $a0, join_arr 
	lw $a1, n_join_arr
	addi $a2, $0, 1 # a2 = 1 => go to new line after print
	jal PrintArray 
	
													
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
ReadPortion:
	addi $sp, $sp, -16   # keep a 3 * 4 bytes free space  
	sw $s0, 12($sp)	
	sw $a1, 8($sp) 
	sw $a2, 4($sp)
	sw $ra, 0($sp)

	# Read n
	li  $v0, 14  # system call to read from file
	add $a0, $s0, $zero
	la  $a1, n   # address of buffer to store read data.
	li  $a2, 4   # read 4 bytes 
	syscall      # read from file
	
	# Read array
	lw $t0, n # t0 = n 
	sll $t0, $t0, 2 # t0 = (n-1) * 4
	la $t1, arr # t1 = arr (in the 1st element of arr)
	add $v0, $zero, $t1 # Save the arr return value 
	add $t0, $t0, $t1 # t0 = t0 + arr  (go to the end of the array)
	
		j Start_ReadFile
	WhileLoop_ReadFile:
		li  $v0, 14  # system call to read from file
		add $a0, $s0, $zero
		la  $a1, buff   # address of buffer to store read data.
		li  $a2, 4      # read 4 bytes 
		syscall         # read from file
		
		lw $t2, buff
		sw $t2, 0($t1) 
		
		addi $t1, $t1, 4		
	Start_ReadFile:
		bne $t1, $t0, WhileLoop_ReadFile
		
	beq $a3, $0, Exit_ReadPortion	
		
	# Read x 
	li  $v0, 14  # system call to read from file
	add $a0, $s0, $zero
	la  $a1, x   # address of buffer to store read data.
	li  $a2, 4      # read 4 bytes 
	syscall         # read from file

Exit_ReadPortion:	
	lw $ra, 0($sp)
	lw $a2, 4($sp)
	lw $a1, 8($sp) 
	lw $s0, 12($sp)
	addi $sp, $sp, 16 # recover stack pointer for the previous procedure
	jr $ra

#---------------
PrintArray:
	
	add $t0, $zero, $a0 
	sll $t1, $a1, 2
	add $t1, $t1, $t0 
	
	la $t2, space
	
		j Start_PrintArray
	While_PrintArray:
		lw $a0, 0($t0) 
		addi $v0, $zero, 1
		syscall 
		
		addi $a0, $t2, 0
		addi $v0, $zero, 4
		syscall 
						
		addi $t0, $t0, 4
	Start_PrintArray:
		bne $t0, $t1, While_PrintArray
	
	bne $a2, 1, Not_Enter_Print
	
	la $a0, enter
	addi $v0, $zero, 4
	syscall 
	
Not_Enter_Print:	
	
	jr $ra


#---------------
LinearSearch:	
	# Do not need to use stack 

	sll $t0, $a1, 2 # t0 = 4 * n
	add $t0, $t0, $a0 # t0 = 4 * n + arr 
	addi $t2, $a0, 0 # t2 = arr 
	
	addi $v0, $0, -1 # default return value = -1 
	
	j Start_LinearSearch
While_LinearSearch: 
	lw $t1, 0($t2) 
	bne $t1, $a2, Continue_LinearSearch # if (t1 != x) then continue the loop 
	
	sub $t1, $t2, $a0 # t1 = current_arr - arr
	srl $v0, $t1, 2 # v0 = t1 / 4
	j Exit_LinearSearch
	
Continue_LinearSearch:
	addi $t2, $t2, 4 
Start_LinearSearch:
	bne $t2, $t0, While_LinearSearch

Exit_LinearSearch: 
	jr $ra


#---------------
Swap: # Swap (adress1, address2) 
	
	#Swapping
	lw $t0, 0($a0)
	lw $t1, 0($a1)
	sw $t1, 0($a0) 
	sw $t0, 0($a1) 
	
	jr $ra 
	
#---------------
BinarySearch:
	# This is the interface procedure. We just use it to set up the args for the core procedure ImplementBinarySearch

	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# Push args to stack
	addi $sp, $sp, -20
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	
	addi $a3, $zero, 0
	sw $a3, 12($sp) # low = 0 
	
	subi $t0, $a1, 4
	sw $t0, 16($sp) # high = n - 1
	
	addi $a0, $sp, 0 # a0 = the start position of the stack that has been allocated, we will use it as the place for changing args
	
	jal ImplementBinarySearch
	addi $sp, $sp, 20 # Pop out the stack for args

	lw $ra, 0($sp)	
	addi $sp, $sp, 4
	
	jr $ra 
	
ImplementBinarySearch: #args : arr, n, x, low, high 
	
	# Push $ra and $v0 to the stack
	addi $sp, $sp, -12
	sw $ra, 0($sp) # save $ra
	sw $v0, 4($sp)
	sw $s0, 8($sp)
	
	# Load back the arr, n, x 
	lw $s0, 0($a0)
	lw $a1, 4($a0)
	lw $a2, 8($a0)
	lw $t0, 12($a0)
	lw $t1, 16($a0)
	
	ble $t0, $t1, Else1_ImplementBinarySearch
	addi $v0, $zero, -1
	j Exit_ImplementBinarySearch
	
Else1_ImplementBinarySearch:

	sub $t2, $t1, $t0
	srl $t2, $t2, 2
	srl $t2, $t2, 1
	sll $t2, $t2, 2
	add $t2, $t2, $s0 # calculate mid = t2 = (t0 + t1)/2
	lw $t3, 0($t2) 
	
	blt $t3, $a2, Mid_less_X
	bgt $t3, $a2, Mid_greater_X
	
	sub $t2, $t2, $s0 
	srl $t2, $t2, 2
	addi $v0, $t2, 0
	j Exit_ImplementBinarySearch
	
Mid_less_X:
	# Push args to the given stack before
	sw $s0, 0($a0)
	sw $a1, 4($a0)
	sw $a2, 8($a0)
	
	addi $a3, $t2, 4
	sw $a3, 12($a0)
	
	sw $t1, 16($a0)
	
	jal ImplementBinarySearch
	
	j Exit_ImplementBinarySearch
	
Mid_greater_X:
	# Push args to the given stack before
	sw $s0, 0($a0)
	sw $a1, 4($a0)
	sw $a2, 8($a0)
	sw $a3, 12($a0)
	
	addi $t2, $t2, -4
	sw $t2, 16($a0)
	
	jal ImplementBinarySearch
	
Exit_ImplementBinarySearch:

	lw $s0, 8($sp)
	lw $v0, 4($sp)
	lw $ra, 0($sp) 	
	addi $sp, $sp, 12
	jr $ra 
	
	
#---------------
BubbleSort: 
	addi $sp, $sp, -36
	sw $s0, 0($sp) # push s0 to stack 
	sw $s1, 4($sp) # push s1 to stack
	sw $s2, 8($sp) # push s2 to stack 
	sw $s3, 12($sp) # push s3 to stack
	sw $s4, 16($sp) # push s4 to stack 
	sw $s5, 20($sp) # push s5 to stack 
	sw $ra, 24($sp) # push $ra to stack
	sw $a0, 28($sp) # push a0 to stack 
	sw $a1, 32($sp) # push a1 to stack

	addi $s0, $a0, 4 # t0 = arr + 4
	sll $s2, $a1, 2
	add $s2, $s2, $a0 # t2 = arr + 4 * n
	subi $s3, $s2, 4 # t3 = arr + 4 * (n-1)
	
	beq $a2, $0, Descending_BubbleSort # if (asc == 0) then jump to Descending portion
	
Ascending_BubbleSort:

	j Start1_BubbleSort
While1_BubbleSort:
		addi $s1, $s3, 0
		j InnerStart1_BubbleSort
	InnerWhile1_BubbleSort:
		lw $s4, 0($s1)
		lw $s5, -4($s1) 
		bge $s4, $s5, InnerContinue1_BubbleSort
		
		addi $a0, $s1, 0
		addi $a1, $s1, -4
		jal Swap 
	InnerContinue1_BubbleSort:
		subi $s1, $s1, 4
	InnerStart1_BubbleSort:
		bge $s1, $s0, InnerWhile1_BubbleSort
		
	addi $s0, $s0, 4
Start1_BubbleSort:
	bne $s0, $s2, While1_BubbleSort

	j Exit_BubbleSort


Descending_BubbleSort:

	j Start2_BubbleSort
While2_BubbleSort:
		addi $s1, $s3, 0
		j InnerStart2_BubbleSort
	InnerWhile2_BubbleSort:
		lw $s4, 0($s1)
		lw $s5, -4($s1) 
		ble $s4, $s5, InnerContinue2_BubbleSort
		
		addi $a0, $s1, 0
		addi $a1, $s1, -4
		jal Swap 
		
	InnerContinue2_BubbleSort:
		subi $s1, $s1, 4
	InnerStart2_BubbleSort:
		bge $s1, $s0, InnerWhile2_BubbleSort
		
	addi $s0, $s0, 4
Start2_BubbleSort:
	bne $s0, $s2, While2_BubbleSort

Exit_BubbleSort:
	lw $a1, 32($sp) # pop a1 from stack
	lw $a0, 28($sp) # pop a0 from stack 
	lw $ra, 24($sp) # pop $ra from stack
	lw $s5, 20($sp) # pop s5 from stack
	lw $s4, 16($sp) # pop s4 from stack 
	lw $s3, 12($sp) # pop s3 from stack
	lw $s2, 8($sp) # pop s2 from stack 
	lw $s1, 4($sp) # pop s1 from stack
	lw $s0, 0($sp) # pop s0 from stack 
	addi $sp, $sp, 36

	addi $v0, $a0, 0
	jr $ra 
		

#---------------
InsertionSort: 
	addi $sp, $sp, -36
	sw $s0, 0($sp) # push s0 to stack 
	sw $s1, 4($sp) # push s1 to stack
	sw $s2, 8($sp) # push s2 to stack 
	sw $s3, 12($sp) # push s3 to stack
	sw $s4, 16($sp) # push s4 to stack 
	sw $s5, 20($sp) # push s5 to stack 
	sw $ra, 24($sp) # push $ra to stack
	sw $a0, 28($sp) # push a0 to stack 
	sw $a1, 32($sp) # push a1 to stack

	addi $s0, $a0, 4 # t0 = arr + 4
	sll $s2, $a1, 2
	add $s2, $s2, $a0 # t2 = arr + 4 * n
	
	beq $a2, $0, Descending_InsertionSort # if (asc == 0) then jump to Descending portion
	
Ascending_InsertionSort:

	j Start1_InsertionSort
While1_InsertionSort:
		subi $s1, $s0, 4
		lw $s3, 0($s0) # s3 = arr + 4 * i
		
		j InnerStart1_InsertionSort
	InnerWhile1_InsertionSort:
		sw $s4, 4($s1) 
		subi $s1, $s1, 4
	InnerStart1_InsertionSort:
		lw $s4, 0($s1)
		blt $s1, $a0, Continue1_InsertionSort # j < 0 => break 
		bge $s3, $s4, Continue1_InsertionSort # s3 >= arr[j]  => break 
		j InnerWhile1_InsertionSort

Continue1_InsertionSort:
	addi $s0, $s0, 4
	sw $s3, 4($s1) 
Start1_InsertionSort:
	bne $s0, $s2, While1_InsertionSort

	j Exit_InsertionSort


Descending_InsertionSort:
	
	j Start2_InsertionSort
While2_InsertionSort:
		subi $s1, $s0, 4
		lw $s3, 0($s0) # s3 = arr + 4 * i
		
		j InnerStart2_InsertionSort
	InnerWhile2_InsertionSort:
		sw $s4, 4($s1) 
		subi $s1, $s1, 4
	InnerStart2_InsertionSort:
		lw $s4, 0($s1)
		blt $s1, $a0, Continue2_InsertionSort # j < 0 => break 
		ble $s3, $s4, Continue2_InsertionSort # s3 <= arr[j]  => break 
		j InnerWhile2_InsertionSort

Continue2_InsertionSort:
	addi $s0, $s0, 4
	sw $s3, 4($s1) 
Start2_InsertionSort:
	bne $s0, $s2, While2_InsertionSort
	

Exit_InsertionSort:
	lw $a1, 32($sp) # pop a1 from stack
	lw $a0, 28($sp) # pop a0 from stack 
	lw $ra, 24($sp) # pop $ra from stack
	lw $s5, 20($sp) # pop s5 from stack
	lw $s4, 16($sp) # pop s4 from stack 
	lw $s3, 12($sp) # pop s3 from stack
	lw $s2, 8($sp) # pop s2 from stack 
	lw $s1, 4($sp) # pop s1 from stack
	lw $s0, 0($sp) # pop s0 from stack 
	addi $sp, $sp, 36

	addi $v0, $a0, 0
	jr $ra 
	
#---------------
DividePositiveNegative:
	la $t0, nega
	la $t1, not_nega
	sll $a1, $a1, 2 
	add $a1, $a1, $a0 
	
	j Start_DividePositiveNegative
While_DividePositiveNegative:
	lw $t3, 0($a0)
	
	bge $t3, $0, Else_DividePositiveNegative
	
	sw $t3, 0($t0) # if Mem[arr] >= 0, then Mem[notnega] = Mem[arr]
	addi $t0, $t0, 4 # notnega += 4
	j Continue_DividePositiveNegative
Else_DividePositiveNegative:
	sw $t3, 0($t1) # if Mem[arr] < 0, then Mem[nega] = Mem[arr]
	addi $t1, $t1, 4 # nega += 4
Continue_DividePositiveNegative:
	addi $a0, $a0, 4 # arr += 4
	
Start_DividePositiveNegative:
	bne $a0, $a1, While_DividePositiveNegative # if have not gone through the original array, then continue
	
	la $t2, nega
	la $t3, not_nega
	sub $t0, $t0, $t2
	sub $t1, $t1, $t3
	srl $t0, $t0, 2 # Get the length of the 1st array (respect to words) 
	srl $t1, $t1, 2 # Get the length of the 2nd array (respect to words) 
	
	# Store values to labels
	la $t2, n_nega 
	la $t3, n_not_nega
	sw $t0, 0($t2) 
	sw $t1, 0($t3) 
	
	jr $ra
	
#---------------
MergeSort: 
	
	addi $sp, $sp, -44
	sw $s0, 0($sp)
	sw $ra, 4($sp) 
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	sw $ra, 24($sp)
	sw $s5, 28($sp)
	sw $a0, 32($sp)
	sw $a1, 36($sp)
	sw $s6, 40($sp)
	
	# ==========RECURSIVE PART==============
	
	ble $a1, 1, Exit_MergeSort
	
	srl $s3, $a1, 1 # s3 = n / 2 
	sll $s3, $s3, 2 # s3 = (n/2) * 4 
	add $s0, $s3, $a0 # s0 = arr + (n/2) * 4 
	addi $s2, $a1, 0 # s2 = n 
	
	# Setup args for recursive call : MergeSort(a, n / 2);
	addi $s1, $a0, 0 # s1 = arr  (just backup arr)

			 # a0 = arr   (by default)
	srl $a1, $a1, 1  # a1 = n / 2
	jal MergeSort # MergeSort(a, n / 2);
	
	addi $t0, $s0, 0 # t0 = address of arr[(n/2) * 4]
	addi $t1, $s1, 0 # t1 = arr
	
	
	# Backup arr with length n/2 to array 'temp1' 
	addi $s6, $sp, 0 # save the base of the stack given for saving temp1's content
	sub $sp, $sp, $s3 # give stack for saving temp1 
	addi $t4, $sp, 0 # t4 = head of stack 
	
	
	la $t2, temp1
	j Start1_MergeSort
While1_MergeSort:
	lw $t3, 0($t1)
	sw $t3, 0($t2)
	sw $t3, 0($t4)
	addi $t1, $t1, 4
	addi $t2, $t2, 4
	addi $t4, $t4, 4 # save to stack
Start1_MergeSort:
	bne $t1, $t0, While1_MergeSort
	
	# Setup args for recursive call : MergeSort(b, n - n / 2);
	addi $s5, $a0, 0 # s5 = a0 (for backup a0)
	
	addi $a0, $s0, 0 # a0 = arr + (n/2)*4
	srl $s4, $s2, 1 # t0 = n / 2
	sub $a1, $s2, $s4 # a1 = n - n / 2
	jal MergeSort # MergeSort(b, n - n / 2);
	
	
	
	# ==========NON-RECURSIVE PART==============
	
	# Get back temp1 
	la $t0, temp1
	add $t1, $t0, $s3
	sub $t2, $s6, $s3 # get the head of stack
	
	j StartStack_MergeSort
WhileStack_MergeSort:
	lw $t3, 0($t2)
	sw $t3, 0($t0) # Get temp1[i] = stack[i]
	addi $t2, $t2, 4
	addi $t0, $t0, 4
StartStack_MergeSort:	
	bne $t0, $t1, WhileStack_MergeSort
	add $sp, $sp, $s3 # get back stack for saving temp1 to OS
	# Finished getting back temp1
	
	
	addi $a0, $s5, 0  # a0 = s5  (s5 keeps the value of a0 before recursive call)
	sub $s4, $s2, $s4
	sll $s4, $s4, 2 # s4 = (n - n / 2)*4
	add $t0, $s4, $s0 # t0 = (arr + (n/2)*4) + (n - n / 2)*4
	addi $t1, $s0, 0 # t1 = arr + (n/2)*4
	
	# Backup (arr + (n/2)*4) with length (n - n/2) to array 'temp2' 
	la $t2, temp2
	j Start2_MergeSort
While2_MergeSort:
	lw $t3, 0($t1)
	sw $t3, 0($t2)
	addi $t1, $t1, 4
	addi $t2, $t2, 4
Start2_MergeSort:
	bne $t1, $t0, While2_MergeSort
	
	addi $t0, $a0, 0  # t0 = arr 
	la $t1, temp1     # t1 = temp1
	la $t2, temp2     # t2 = temp2
	sll $t3, $s2, 2   # t3 = n * 4
	add $t3, $t3, $a0 # t3 = arr + n*4
	add $t4, $t1, $s3 # t4 = temp1 + (n/2)*4
	add $t5, $t2, $s4 # t5 = temp2 + (n-n/2)*4
	
	j Start3_MergeSort
While3_MergeSort:
	bge $t1, $t4, Break3_MergeSort
	bge $t2, $t5, Break3_MergeSort
	
	lw $t6, 0($t1)
	lw $t7, 0($t2) 
	
	bne $a2, $zero, Ascending_MergeSort
	ble $t6, $t7, Else3_MergeSort 
	j Continue_Descending_MergeSort
	
Ascending_MergeSort:
	bge $t6, $t7, Else3_MergeSort 
	
Continue_Descending_MergeSort:	
	
	sw $t6, 0($t0)
	addi $t1, $t1, 4
	j Continue3_MergeSort
	
Else3_MergeSort:
	sw $t7, 0($t0)
	addi $t2, $t2, 4
Continue3_MergeSort:

	addi $t0, $t0, 4
Start3_MergeSort:
	blt $t0, $t3, While3_MergeSort
	
	
Break3_MergeSort:	

	blt $t1, $t4, Else1_MergeSort
	la $t6, temp1
	la $t7, temp2
	sub $t6, $t1, $t6  # t6 = currTemp1 - temp1
	sub $t7, $t2, $t7 # t7 = currTemp2 - temp2
	ble $t7, $t6, InnerElse1_MergeSort
	
	add $t0, $a0, $t7 # t0 = arr + (n/2)*4
	
InnerElse1_MergeSort:
	
	j Start4_MergeSort
While4_MergeSort:
	lw $t6, 0($t2) 
	sw $t6, 0($t0)
	addi $t0, $t0, 4
	addi $t2, $t2, 4
Start4_MergeSort:
	bne $t0, $t3, While4_MergeSort
	
	j Exit_MergeSort
	
Else1_MergeSort:	
	
	blt $t2, $t5, Exit_MergeSort
	la $t6, temp1
	la $t7, temp2
	sub $t6, $t1, $t6  # t6 = currTemp1 - temp1
	sub $t7, $t2, $t7 # t7 = currTemp2 - temp2
	ble $t6, $t7, InnerElse2_MergeSort
	
	add $t0, $a0, $t6 # t0 = arr + t6
InnerElse2_MergeSort:
	
	j Start5_MergeSort
While5_MergeSort:
	lw $t6, 0($t1) 
	sw $t6, 0($t0) 
	addi $t0, $t0, 4
	addi $t1, $t1, 4
Start5_MergeSort:
	bne $t0, $t3, While5_MergeSort
	
Exit_MergeSort:
	
	lw $s6, 40($sp)
	lw $a1, 36($sp)
	lw $a0, 32($sp)
	lw $s5, 28($sp)
	lw $ra, 24($sp)
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $ra, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 44
	
	jr $ra


#---------------
QuickSort: 	
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# a0 = arr (by default)
	subi $a2, $a1, 1 # a2 = n - 1
	addi $a1, $zero, 0
	jal ImplementQuickSort
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
	
ImplementQuickSort:  # ImplementQuickSort(int * arr, int start, int end)
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp) 
	sw $a2, 12($sp)
	sw $s0, 16($sp)	
	sw $s1, 20($sp)
	
	bge $a1, $a2, Exit_ImplementQuickSort
	
	add $t0, $a1, $a2
	srl $t0, $t0, 1
	sll $t0, $t0, 2 # t0 = [(start + end)/2] * 4
	add $t0, $a0, $t0 # t0 = arr + [(start + end)/2] * 4
	
	lw $t3, 0($t0) # t3 = pivot 
	
	addi $t1, $a1, 0 # t1 = start
	sll $t1, $t1, 2
	add $t1, $a0, $t1 # t1 = arr + start * 4
	
	addi $t2, $a2, 0 # t2 = end
	sll $t2, $t2, 2
	add $t2, $a0, $t2 # t2 = arr + end * 4
	
DoWhile_ImplementQuickSort:
		lw $t4, 0($t1) # t4 = Mem[arr + start * 4]
		j Start1_ImplementQuickSort
	While1_ImplementQuickSort:
		addi $t1, $t1, 4 
		lw $t4, 0($t1) # t4 = Mem[t1]
	Start1_ImplementQuickSort:
		blt $t4, $t3, While1_ImplementQuickSort  # Branch if (t4 < pivot)
		
		
		lw $t4, 0($t2) # t4 = Mem[arr + start * 4]
		j Start2_ImplementQuickSort
	While2_ImplementQuickSort:
		subi $t2, $t2, 4 
		lw $t4, 0($t2) # t4 = Mem[t1]
	Start2_ImplementQuickSort:
		bgt $t4, $t3, While2_ImplementQuickSort  # Branch if (t4 < pivot)
		
		
	bgt $t1, $t2, Else_ImplementQuickSort
		bge $t1, $t2, InnerElse_ImplementQuickSort
		
		addi $sp, $sp, -16
		sw $a0, 0($sp)
		sw $a1, 4($sp)
		sw $t0, 8($sp)
		sw $t1, 12($sp)
		
		addi $a0, $t1, 0
		addi $a1, $t2, 0
		jal Swap
		
		lw $t1, 12($sp)
		lw $t0, 8($sp)
		lw $a1, 4($sp)
		lw $a0, 0($sp)
		addi $sp, $sp, 16
		
	InnerElse_ImplementQuickSort:	
		addi $t1, $t1, 4
		subi $t2, $t2, 4
		
Else_ImplementQuickSort:	
	ble $t1, $t2, DoWhile_ImplementQuickSort
	
	sub $s0, $t1, $a0 # backup t1 
	
	addi $s1, $a2, 0 # backup a2 
	
	# a0 = a
	# a1 = start
	sub $a2, $t2, $a0
	srl $a2, $a2, 2 # a2 = (t2 - arr) / 4
	jal ImplementQuickSort
	
	# a0 = a 
	srl $s0, $s0, 2 # s0 = (t1 - arr) / 4 
	addi $a1, $s0, 0 # a1 = (t1 - arr) / 4
	addi $a2, $s1, 0 # a2 = end
	jal ImplementQuickSort
	
Exit_ImplementQuickSort:
	lw $s1, 20($sp)
	lw $s0, 16($sp)		
	lw $a2, 12($sp)
	lw $a1, 8($sp)
	lw $a0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24
			
	jr $ra
	

JointArrayInterpose:
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	la $t0, n_join_arr
	add $t1, $a1, $a3
	sw $t1, 0($t0) # n_join_arr = n1 + n2

	addi $t0, $a0, 0 # t0 = arr1
	addi $t1, $a2, 0 # t1 = arr2
	
	sll $t3, $a1, 2 # t3 = n1 * 4
	addi $t6, $t3, 0 # t6 = t3
	add $t3, $t3, $a0 # t3 = arr1 + n1 * 4
	
	sll $t4, $a3, 2 # t4 = n2 * 4
	add $t6, $t6, $t4 # t6 = (n1 + n2) * 4
	add $t4, $t4, $a2 # t4 = arr2 + n2 * 4
	
	la $t5, join_arr # t5 = join_arr
	add $t6, $t6, $t5 # t6 = join_arr + (n1 + n2) * 4
	
	j Start_JointArrayInterpose
While_JointArrayInterpose:
	bge $a0, $t3, Else1_JointArrayInterpose
	lw $t7, 0($a0)
	sw $t7, 0($t5)
	addi $a0, $a0, 4
	addi $t5, $t5, 4
	
Else1_JointArrayInterpose:
	bge $t5, $t6, Start_JointArrayInterpose
	bge $a2, $t4, Start_JointArrayInterpose
	lw $t7, 0($a2)
	sw $t7, 0($t5)
	addi $a2, $a2, 4
	addi $t5, $t5, 4
	
Start_JointArrayInterpose:
	bne $t5, $t6, While_JointArrayInterpose
	
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	
	jr $ra
	
