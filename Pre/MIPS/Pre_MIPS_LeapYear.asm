	.text
	li $v0, 5
	syscall			#输入年份
	move $s0,$v0			#令$s0是年份
	li $t1,4
	div $s0,$t1			#年份/4
	mfhi $t2		#余数给$t2
	beq $t2,$zero, if_1_else
	nop
	 li $a0, 0		#设置$a0为0
	j if_1_end
	nop 
	
	if_1_else:
		li $t1,100
	 	div $s0,$t1			#年份/100
		mfhi $t2		#余数给$t2
	 	beq $t2,$zero, if_2_else
	 	nop
	 	li $a0, 1		#设置$a0为1
	 	j if_1_end
		nop 
	 	
	 if_2_else:
	 	 li $t1,400
	 	div $s0,$t1			#年份/400
		mfhi $t2		#余数给$t2
		beq $t2,$zero, if_3_else
		nop
		li $a0, 0		#设置$a0为0
	 	j if_1_end
		nop 
		
	if_3_else:
	li $a0, 1	#设置$a0为1
	 j if_1_end
	nop 
	
	 if_1_end:
	 li $v0, 1			#输出$a0=0
	 syscall
	  li $v0, 10
	 syscall