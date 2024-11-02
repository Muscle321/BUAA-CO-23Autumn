.data
matrix: 		.space 10000
str_enter:		 .asciiz	"\n"
str_space:	 .asciiz 	" "

.text
	li  $v0, 5
	syscall
	move $s0, $v0			#行数n
	li $v0, 5
	syscall
	move $s1, $v0			#列数m
	mult  $s0, $s1			#m * n
	mflo 	$t0				#$t0为元素总个数
	li $t1, 0			#use $t1 as i
	
	for_1_begin:
	slt $t2,$t1,$t0			#$t2 == ($t1 < $t0) ? 1 : 0
	beq $t2, $zero, for_1_end			#$t2 = 0 ,  即 $t1 = $t0 时转移
	nop
	
	li $v0, 5
	syscall
	sll $t3, $t1, 2			#$t3 = $t1 * 4
	sw $v0, matrix($t3)		#将数字存入数组下一个地址当中
	
	addi $t1 , $t1, 1		#i++
	j for_1_begin
	nop
	
for_1_end:					#完成矩阵数组的输入
	addi $t0, $t0, -1		#$t0减1
for_2_begin:				#开始输出
	bltz $t0,  for_2_end		#$t0小于0时退出循环
	nop
	
	sll $t1, $t0, 2			#$t1 = $t0 * 4
	lw  $t2, matrix($t1)				#$t2 取当前的数
	beq $t2, $zero, if_1_end			#$t2为0则直接跳过，$t2大于0则执行输出指令
	nop
	addi $t3, $t0, 1			#$t3为当前第几个整数
	div $t3, $s1
	mflo	$t4						#$t4商值为行数减1
	mfhi	$t5						#$t5余数为列数
	bgtz $t5, if_2_else			#$t5为0时为最后一列，不转移
	nop
	addi $a0, $t4, 0			#$a0为行数
	li $v0, 1							#输出行数
	syscall	
	la $a0, str_space		
	li $v0, 4
	syscall							#输出空格
	add $a0, $s1, $zero					#$a0为最后一列
	j if_2_end
	nop
	
if_2_else:
	addi $a0, $t4, 	1		#$a0为行数
	li $v0, 1							#输出行数
	syscall	
	la $a0, str_space		
	li $v0, 4
	syscall							#输出空格
	add $a0, $t5, $zero
if_2_end:
	li $v0, 1							#输出列数
	syscall	
	la $a0, str_space		
	li $v0, 4
	syscall							#输出空格
	add $a0, $t2, $zero
	li $v0, 1
	syscall							#输出当前整数
	la $a0, str_enter		
	li $v0, 4
	syscall							#输出换行符
	
if_1_end:
	addi $t0, $t0, -1		#i--
	j for_2_begin
	nop
	
for_2_end:
	li $v0, 10
	syscall
