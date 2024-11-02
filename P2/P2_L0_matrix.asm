.data
matrix1: .space 256
matrix2: .space 256
space: .asciiz " "
nextline: .asciiz "\n"

.macro end
	li $v0, 10
	syscall
.end_macro

.macro get_int(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.macro print_int(%ans)
	move $a0, %ans
	li $v0, 1
	syscall
.end_macro

.macro print_str(%ans)
	la $a0, %ans
	li $v0, 4
	syscall
.end_macro

.macro get_index(%ans, %i, %j, %column)
	mult %column, %i
	mflo %ans
	add %ans, %ans, %j
.end_macro

.macro store_int(%ans, %num, %name)
	sll %num, %num, 2
	sw %ans, %name(%num)
	srl %num, %num, 2
.end_macro

.macro load_int(%ans, %num, %name)
	sll %num, %num, 2
	lw %ans, %name(%num)
	srl %num, %num, 2
.end_macro

.macro push(%src)
	subi $sp, $sp, 4
	sw	%src, 0($sp)
.end_macro

.macro pop(%src)
	lw	%src, 0($sp)
	addi $sp, $sp, 4
.end_macro

.text
	get_int($s0)		#s0 = n
	
	li $t1, 0	
for_1_begin:
	beq $t1, $s0, for_1_end
	nop
	
	li $t2, 0
	for_2_begin:
		beq $t2, $s0, for_2_end
		nop
		
		get_index($t3, $t1, $t2, $s0)
		get_int($t4)
		store_int($t4, $t3, matrix1)
		
		addi $t2, $t2, 1
		nop
		j for_2_begin
		
	for_2_end:
	addi $t1, $t1, 1
	nop
	j for_1_begin
for_1_end:

li $t1, 0	
for_3_begin:
	beq $t1, $s0, for_3_end
	nop
	
	li $t2, 0
	for_4_begin:
		beq $t2, $s0, for_4_end
		nop
		
		get_index($t3, $t1, $t2, $s0)
		get_int($t4)
		store_int($t4, $t3, matrix2)
		
		addi $t2, $t2, 1
		nop
		j for_4_begin
	for_4_end:
	addi $t1, $t1, 1
	nop
	j for_3_begin
for_3_end:

li $t1, 0	
for_5_begin:
	beq $t1, $s0, for_5_end
	nop
	
	li $t2, 0
	for_6_begin:
		beq $t2, $s0, for_6_end
		nop
		
		li $t0, 0
		li $s1, 0
		for_7_begin:
		beq $t0, $s0, for_7_end
		nop
		
		get_index($t3, $t1, $t0, $s0)
		load_int($t4,$t3,matrix1)
		get_index($t3, $t0, $t2, $s0)
		load_int($t5,$t3,matrix2)
		mult $t4, $t5
		mflo $t3
		add $s1, $s1, $t3
		
		addi $t0, $t0, 1
		nop
		j for_7_begin
		
		for_7_end:
		print_int($s1)
		print_str(space)
		addi $t2, $t2, 1
		nop
		
	j for_6_begin	#这句话忘记加了
	
	for_6_end:
	
	print_str(nextline)
	
	addi $t1, $t1, 1
	nop
	j for_5_begin
for_5_end:
end

