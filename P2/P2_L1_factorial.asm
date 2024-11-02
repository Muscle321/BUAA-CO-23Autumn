.data
array: .space 100000

.macro get_int(%d)
	li $v0, 5
	syscall
	move %d, $v0
.end_macro

.macro	end
	li $v0, 10
	syscall
.end_macro

.macro	print_int(%d)
	move $a0, %d			# 注意move的使用， 是 前者等于后者
	li $v0, 1
	syscall
.end_macro

.macro	store(%d, %num)
	sll %num, %num, 1
	sh %d, array(%num)
	srl %num, %num, 1
.end_macro

.macro	load(%d, %num)
	sll %num, %num, 1
	lhu %d, array(%num)
	srl %num, %num, 1
.end_macro

.text
	get_int($s0)
	li $s1, 1				#count = 1
	li $t0, 1
	li $s2, 10
	store($s1, $zero)
for_1_begin:
	sub $t1, $s0, $t0
	bltz $t1, for_1_end
	nop
	
	jal Mult
	
	addi $t0, $t0, 1
	nop
	j for_1_begin

for_1_end:
	
	addi $t0, $s1, -1
for_2_begin:
	bltz $t0, for_2_end
	nop
	
	load($t1, $t0)
	print_int($t1)
	
	addi $t0, $t0, -1
	nop
	j for_2_begin

for_2_end:
end
	
			
Mult:
	li $t2, 0				# i = 0
	li $s3, 0				# 进位为0
for_begin:
	beq $t2, $s1, for_end
	nop
	
	load($t3, $t2)				# array[i] is t3
	mult $t3, $t0				# array[i] * n is t4
	mflo $t4
	add $t4, $t4, $s3		# t4 加上进位
	divu $t4, $s2
	mfhi $t3						#	余数在t3，储存，进位保留在s3
	mflo $s3
	store($t3, $t2)			#	t3重新储存
	beq $s3, $0, jump
	addi $t5, $s1, -1
	bne $t5, $t2, jump
	addi $s1, $s1, 1
	
jump:
	addi $t2, $t2, 1
	nop
	j for_begin

for_end:
	jr $ra

