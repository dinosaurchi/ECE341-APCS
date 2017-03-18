	.data
ques:	.asciiz "1)  strcpy(b,a)      2) strupper(a,a)      3) strlower(b,b)\n4)  strproper(a,a)   5) strcat(b,a)        6) strcmp(b,a)\n7)  stricmp(b,a)     8) strchr(a,c)        9) strrchr(a,c)\n10) strstr(b,a)\n"
ques1:	.asciiz "strcpy(b,a)    : "
ques2:	.asciiz "strupper(a,a)  : "
ques3:	.asciiz "strlower(b,b)  : "
ques4:	.asciiz "strproper(a,a) : "
ques5:	.asciiz "strcat(b,a)    : "
ques6:	.asciiz "strcmp(b,a)    : "
ques7:	.asciiz "stricmp(b,a)   : "
ques8:	.asciiz "strchr(a,c)    : "
ques9:	.asciiz "strrchr(a,c)   : "
ques10:	.asciiz "strstr(b,a)    : "
temp:	.asciiz "                                          "
str_a:	.asciiz "                                          "
des_a:	.asciiz "                                          "
str_b:	.asciiz "                                          "
des_b:	.asciiz "                                          "
str_c:	.asciiz "       \n"
input_a:.asciiz "String a : "
input_b:.asciiz "String b : "
input_c:.asciiz "Character c : "
choice:	.asciiz "Choice : "
check:	.word 
	.text 
	.globl main 
	
main:
# String a:
	la $a0, input_a
	addi $v0, $zero, 4
	syscall 

	# Set up for read string
	la $a0, str_a
	jal strlen
	addi $a1, $v0, 0 
	addi $v0, $zero, 8
	syscall 

# String b:	
	la $a0, input_b
	addi $v0, $zero, 4
	syscall 

	# Set up for read string
	la $a0, str_b
	jal strlen
	addi $a1, $v0, 0 
	addi $v0, $zero, 8
	syscall 

# Character c: 
	la $a0, input_c
	addi $v0, $zero, 4
	syscall 

	# Set up for read string
	la $a0, str_c
	jal strlen
	addi $a1, $v0, 0 
	addi $v0, $zero, 8
	syscall 

# Menu
	la $a0, ques
	addi $v0, $zero, 4
	syscall 
	la $a0, choice
	addi $v0, $zero, 4
	syscall 
	
	la $a0, check
	jal strlen
	addi $a1, $v0, 0 
	addi $v0, $zero, 5
	syscall 
	
	beq $v0, 1, cpy 
	beq $v0, 2, upper
	beq $v0, 3, lower
	beq $v0, 4, proper
	beq $v0, 5, cat
	beq $v0, 6, cmp
	beq $v0, 7, icmp
	beq $v0, 8, chr
	beq $v0, 9, rchr
	beq $v0, 10, str
	
	j Exit 

# strproper:	
proper:	
	la $a0, ques4
	addi $v0, $zero, 4
	syscall 
	
	la $a0, des_a
	la $a1, temp
	jal strcpy 
	
	la $a0, des_a
	la $a1, str_a
	jal strproper
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall 
	j Exit 

lower:		
	la $a0, ques3
	addi $v0, $zero, 4
	syscall 
	
	la $a0, des_b
	la $a1, str_b
	jal strlower
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall 
	j Exit

upper:		
	la $a0, ques2
	addi $v0, $zero, 4
	syscall 
	
	la $a0, des_a
	la $a1, str_a
	jal strupper
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall 
	j Exit

cat: 
	la $a0, ques5
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_b
	la $a1, str_a
	jal strcat 
	
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall 
	j Exit
	
cmp:
	la $a0, ques6
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_b
	la $a1, str_a
	jal strcmp 
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	j Exit
	
icmp:
	la $a0, ques7
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_b
	la $a1, str_a
	jal stricmp 
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	j Exit

chr:
	la $a0, ques8
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_a
	la $a1, str_c
	lb $a1, 0($a0) 
	
	jal strchr
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	j Exit

rchr:
	la $a0, ques9
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_a
	la $a1, str_c
	lb $a1, 0($a0) 
	
	jal strchr
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	j Exit

str:
	la $a0, ques10
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_b
	la $a1, str_a
	jal strstr 
	addi $a0, $v0, 0
	addi $v0, $zero, 1
	syscall 
	j Exit

cpy:		
	la $a0, ques1
	addi $v0, $zero, 4
	syscall 
	
	la $a0, str_b
	la $a1, str_a
	jal strcpy 
	addi $a0, $v0, 0
	addi $v0, $zero, 4
	syscall 
			
Exit:
	addi $v0, $zero, 10
	syscall 
			
#=========================================	
# IMPLEMENTATION FOR FUNCTIONS  
#=========================================	

#========== strcpy ==========	
strcpy:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) # Push the registers that you want to use in this procedure in to stack
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $s0, $a1, 0 # Set the state registers for argument registers, because we want to preserve arguments
	addi $s1, $a0, 0

	j While_Cpy # Just go though and copy one by one from src to des
Loop_Cpy:
	addi $s0, $s0, 1
	addi $s1, $s1, 1
While_Cpy: 
	lb $t1, 0($s0)
	sb $t1, 0($s1)
	bnez $t1, Loop_Cpy
	
	
	addi $v0, $a0, 0 # Return des
	lw $ra, 0($sp) # Recovery the used registers in the stack (we have saved before)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12 # recover stack pointer for the previous procedure
	jr $ra

	
#========== strupper ==========
strupper:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $s0, $a1, 0
	addi $s1, $a0, 0

	j While_Upper
Loop_Upper:
	sb $t0, 0($s1)    
	addi $s0, $s0, 1
	addi $s1, $s1, 1
While_Upper: 
	lb $t0, 0($s0)
	
	# Check whether  97 <= Mem[$s0] <= 122 
	bgt $t0, 122, Else_Upper 
	blt $t0, 97, Else_Upper
	sub $t0, $t0, 32 # If Mem[$s0] is in [97, 122], we substract by 32 (convert to uppercase)
Else_Upper:	
	bnez $t0, Loop_Upper
	
	addi $v0, $a0, 0 #Return des
	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12     # recover stack pointer for the previous procedure
	jr $ra
	
	
#========== strlower ==========	
strlower:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $s0, $a1, 0
	addi $s1, $a0, 0

	j While_Lower
Loop_Lower:
	sb $t0, 0($s1)    
	addi $s0, $s0, 1
	addi $s1, $s1, 1
While_Lower: 
	lb $t0, 0($s0)
	
	# Check whether  65 <= Mem[$s0] <= 90
	bgt $t0, 90, Else_Lower
	blt $t0, 65, Else_Lower
	addi $t0, $t0, 32 # If Mem[$s0] is in [65, 90], we add by 32 (convert to lowercase)
Else_Lower:	
	bnez $t0, Loop_Lower
	
	addi $v0, $a0, 0 #Return des
	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12     # recover stack pointer for the previous procedure
	jr $ra
	
	
#========== strproper ==========
strproper:
	addi $sp, $sp, -16   # keep a 4 * 4 bytes free space  
	sw $s0, 12($sp) 
	sw $s1, 8($sp) 
	sw $t0, 4($sp)
	sw $ra, 0($sp)

	addi, $s0, $a1, 0
	addi, $s1, $a0, 0 
	
	j While_Proper 
Loop_Proper:
		j InnerWhile_Proper # InnerWhile  loop is used to exclude the 'space', then find out the head character of a word
	InnerLoop_Proper:
		sb $t0, 0($s1) 
		addi $s0, $s0, 1
		addi $s1, $s1, 1
	InnerWhile_Proper:
		lb $t0, 0($s0)
		beq $t0, 32, InnerLoop_Proper # If Mem[$s0] is a ' ', continue to loop until encounter another character
	
	beqz $t0, Exit_Proper # If we went to the end of the string, then have nothing to check. 
	# Otherwise .... We have found a head character of a word
	# We just have to change the lower case to upper case, otherwise, just copy them into destination directly.
	# Check whether  97 <= Mem[$s0] <= 122 
	bgt $t0, 122, Else_Proper 
	blt $t0, 97, Else_Proper
	
	# If Mem[$s0] is in [97, 122], we substract by 32 (convert to uppercase)
	sub $t0, $t0, 32 
	sb $t0, 0($s1) 
	
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	j InnerWhile2_Proper # To avoid the case that duplicate the character (for the case strproper (a,a))
	# Otherwise, just continue the process
Else_Proper:	
	sb $t0, 0($s1) 
	
	j InnerWhile2_Proper # InnerWhile2  loop is used to traverse the current word after edit the head character. 
	InnerLoop2_Proper:
		sb $t0, 0($s1) 
		addi $s0, $s0, 1
		addi $s1, $s1, 1
	InnerWhile2_Proper:
		lb $t0, 0($s0)
		beqz $t0, Exit_Proper # If this is the end of the string, we just exit
		# Otherwsie, we now find a new ' ', that may appear another word.
		bne $t0, 32, InnerLoop2_Proper # Because 2 words may have long 'space' between them (or the 1st word may have no space before them)
While_Proper: 
	lb $t0, 0($s0)
	bnez $t0, Loop_Proper 

Exit_Proper:	
	addi $v0, $a0, 0
	
	lw $ra, 0($sp)
	lw $t0, 4($sp)
	lw $s1, 8($sp) 
	lw $s0, 12($sp) 
	addi $sp, $sp, 16     # recover stack pointer for the previous procedure
	jr $ra
	
	
#========== strcat ==========
strcat:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $s0, $a0, 0
	addi $s1, $a1, 0

	j While1_Cat # We traverse the 'des' string first in order to find out the end of its. 
Loop1_Cat:
	addi $s0, $s0, 1
While1_Cat: 
	lb $t1, 0($s0)
	beqz $t1, Else_Cat
	beq $t1, 10, Else_Cat # Avoid the '\n'
	j Loop1_Cat 	
	
Else_Cat:	
	
	j While2_Cat # At this time, we found out the end of 'des'. Now we start to copy the 'src', begin from this end point 
Loop2_Cat:
	sb $t1, 0($s0) 
	addi $s0, $s0, 1
	addi $s1, $s1, 1
While2_Cat: 
	lb $t1, 0($s1)
	bnez $t1, Loop2_Cat
	
	addi $v0, $a0, 0 #Return des
	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12     # recover stack pointer for the previous procedure
	jr $ra  
	
	 
#========== strcmp ==========
strcmp:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $v0, $zero, 0 # Default return value is 0
	addi $s0, $a0, 0
	addi $s1, $a1, 0

	j While_Cmp
Loop_Cmp:
	addi $s0, $s0, 1
	addi $s1, $s1, 1
While_Cmp: 
	lb $t1, 0($s0)
	lb $t2, 0($s1)
	
	# with lexicographic order, A > B, but in ASCII, B > A so we have to do the reverse thing 
	blt $t1, $t2, str1_greater_cmp
	bgt $t1, $t2, str2_greater_cmp
	beqz $t1, Exit_Cmp #At this time, str1[i] == str2[i], so if str1[i] == 0, we just exit
	j Loop_Cmp

str1_greater_cmp:
	addi $v0, $zero, 1 # Set the related return value 
	j Exit_Cmp
str2_greater_cmp:
	addi $v0, $zero, -1
Exit_Cmp:	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12     # recover stack pointer for the previous procedure
	jr $ra
	
	
#========== stricmp ==========
stricmp:
	addi $sp, $sp, -20   # keep a 5 * 4 bytes free space
	sw $a0, 16($sp)
	sw $a1, 12($sp)
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	# Arguments are a0 (des), a1(src)
	la $a1, 16($sp) # call strupper in order to normalize a clone version of str1 into Upper case 
	la $a0, des_a 
	jal strupper  
	addi $s0, $v0, 0
	
	la $a1, 12($sp) # call strupper in order to normalize a clone version of str2 into Upper case 
	la $a0, des_b
	jal strupper  
	addi $s1, $v0, 0

	addi $v0, $zero, 0 # Default return value is 0

	j While_Icmp
Loop_Icmp:
	addi $s0, $s0, 1
	addi $s1, $s1, 1
While_Icmp: 
	lb $t1, 0($s0)
	lb $t2, 0($s1)
	
	blt $t1, $t2, str1_greater_icmp
	bgt $t1, $t2, str2_greater_icmp
	beqz $t1, Exit_Icmp #At this time, str1[i] == str2[i], so if str1[i] == 0, we just exit
	j Loop_Icmp

str1_greater_icmp:
	addi $v0, $zero, 1
	j Exit_Icmp
str2_greater_icmp:
	addi $v0, $zero, -1
Exit_Icmp:	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	lw $a1, 12($sp) 
	lw $a0, 16($sp)
	addi $sp, $sp, 20     # recover stack pointer for the previous procedure
	jr $ra
	

#========== strchr ==========
strchr:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $v0, $zero, -1 # Default return value is -1
	addi $s0, $a0, 0
	addi $s1, $a1, 0

	j While_Chr
Loop_Chr:
	bne $t0, $s1, Else_Chr # Check whether Mem[$s0] == $s1 (the chr)
 	sub $t1, $s0, $a0 
	addi $v0, $t1, 0 # If Mem[$s0] == $s1 , just finish the procedure
	j Exit_Chr
Else_Chr:	
	addi $s0, $s0, 1
While_Chr: 
	lb $t0, 0($s0)
	bnez $t0, Loop_Chr
	
Exit_Chr:
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12     # recover stack pointer for the previous procedure
	jr $ra
	
	
#========== strrchr ==========
strrchr:
	addi $sp, $sp, -12   # keep a 3 * 4 bytes free space  
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $v0, $zero, -1 # Default return value is -1
	addi $s0, $a0, 0
	addi $s1, $a1, 0

	j While_Rchr
Loop_Rchr:
	# Check whether Mem[$s0] == $s1 (the chr)
	bne $t0, $s1, Else_Rchr 
	sub $t1, $s0, $a0 
	addi $v0, $t1, 0 # If Mem[$s0] == $s1 , save the current position and continue the process
Else_Rchr:	
	addi $s0, $s0, 1
While_Rchr: 
	lb $t0, 0($s0)
	bnez $t0, Loop_Rchr
	
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	addi $sp, $sp, 12     # recover stack pointer for the previous procedure
	jr $ra	
	

#========== strstr ==========
strstr:
	addi $sp, $sp, -16   # keep a 3 * 4 bytes free space  
	sw $s2, 12($sp)
	sw $s0, 8($sp) 
	sw $s1, 4($sp)
	sw $ra, 0($sp)
	
	addi $s0, $a0, 0
	addi $v0, $0, -1 # Default return value is -1
	
	# First, we need to extrude the '\n' character for str2
	addi $a0, $a1, 0
	jal extrude_new_line
	addi $s1, $v0, 0 
	
	addi $a0, $s0, 0
	
	j While_Strstr # We have to check the str2 for each character of str1 (it means check with each str1 as a head character)
Loop_Strstr:
	addi $s1, $a1, 0
	addi $s2, $s0, 0 # We use $s2 instead of using $s0 directly because we have to keep the process: go one by one character for str1
		j InnerWhile_Strstr
	InnerLoop_Strstr:
		addi $s2, $s2, 1 
		addi $s1, $s1, 1 
	InnerWhile_Strstr:
		lb $t1, 0($s1)
		lb $t0, 0($s2)
		beqz $t1, Break_Strstr # If Mem[$s1] == 0 then break out the loop 
		bne $t1, $t0, Break_Strstr # If Mem[$s1] == Mem[$s2] then break out the loop 
		j InnerLoop_Strstr
		
	Break_Strstr:
		bnez $t1, Else_Strstr # If Mem[$s1] == NULL, it means $s1 has gone though str2, means existing a substring of str1 in str2
		sub $v0, $s0, $a0 # Save return value 
		j Exit_Strstr
		
	Else_Strstr: 
	
	addi $s0, $s0, 1 
While_Strstr: 
	lb $t0, 0($s0) 
	bnez $t0, Loop_Strstr
	
Exit_Strstr:
	lw $ra, 0($sp)
	lw $s1, 4($sp)
	lw $s0, 8($sp) 
	lw $s2, 12($sp)
	addi $sp, $sp, 16     # recover stack pointer for the previous procedure
	jr $ra	
	

#========== strlen ==========
strlen:
	addi $sp, $sp, -8   # keep a 2 * 4 bytes free space  
	sw $s0, 4($sp) 
	sw $ra, 0($sp)
	
	addi $s0, $a0, 0

	# In this procedure, we just have to go though the string, and then ..
	# ... substract the current position (at the end) to the initial position (original position) 
	j While_Len
Loop_Len:
	addi $s0, $s0, 1
While_Len: 
	lb $t1, 0($s0)
	bnez $t1, Loop_Len
	
	sub $v0, $s0, $a0 # Return string length 
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8    # recover stack pointer for the previous procedure
	jr $ra
	

#========== extrude_new_line ==========	
extrude_new_line:
	addi $sp, $sp, -8   # keep a 2 * 4 bytes free space  
	sw $s0, 4($sp) 
	sw $ra, 0($sp)
	
	addi $s0, $a0, 0
	
	j While_Extrude
Loop_Extrude:
	addi $s0, $s0, 1
While_Extrude:
	lb $t0, 0($s0) 
	beqz $t0, Else_Extrude
	beq $t0, 10, Else_Extrude  #Find the '\n' and then replace it by NULL
	j Loop_Extrude 
	
Else_Extrude:	
	addi $t0, $zero, 0
	sb $t0, 0($s0)
	
	addi $v0, $a0, 0
	
	lw $ra, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8    # recover stack pointer for the previous procedure
	jr $ra
	
	
	
