.data
matrix: .space 200

.macro end
	li $v0, 10
	syscall
.end_macro

.macro get_int(%reg)
	li $v0, 5
	syscall
	move %reg, $v0
.end_macro

.macro print_int(%reg)
	move $a0, %reg
	li $v0, 1
	syscall
.end_macro

.macro print_str(%addr)
	la $a0, %addr
	li $v0, 4
	syscall
.end_macro

.macro push(%reg)
	addi $sp, $sp, -4
	sw %reg, 0($sp)
.end_macro

.macro pop(%reg)
	lw %reg, 0($sp)
	addi $sp, $sp, 4
.end_macro

.macro store_int(%data, %num)
	sll %num, %num, 2
	sw %data, matrix(%num)
	srl %num, %num, 2
.end_macro

.macro load_int(%data, %num)
	sll %num, %num, 2
	lw %data, matrix(%num)
	srl %num, %num, 2
.end_macro

.macro get_index(%num, %i, %j, %column)
	mult %i, %column
	mflo %num
	add %num, %num, %j
.end_macro

.macro get_data(%data, %i, %j, %column)
	get_index($t9, %i, %j, %column)
	load_int(%data, $t9)
.end_macro

.macro get_up(%data, %i, %j, %column)
	addi %i, %i, -1
	get_data(%data, %i, %j, %column)
	addi %i, %i, 1
.end_macro

.macro get_down(%data, %i, %j, %column)
	addi %i, %i, 1
	get_data(%data, %i, %j, %column)
	addi %i, %i, -1
.end_macro

.macro get_left(%data, %i, %j, %column)
	addi %j, %j, -1
	get_data(%data, %i, %j, %column)
	addi %j, %j, 1
.end_macro

.macro get_right(%data, %i, %j, %column)
	addi %j, %j, 1
	get_data(%data, %i, %j, %column)
	addi %j, %j, -1
.end_macro


.text
	get_int($s0)
	get_int($s1)
	mult $s0, $s1
	mflo $t0
	li $t1, 0
for_1_begin:
	beq $t1, $t0, for_1_end
	nop

	get_int($t2)
	store_int($t2, $t1)

	addi $t1, $t1, 1
	nop
	j for_1_begin
	
for_1_end:
	get_int($s2)
	addi $s2, $s2, -1
	get_int($s3)
	addi $s3, $s3, -1
	get_int($s4)
	addi $s4, $s4, -1
	get_int($s5)
	addi $s5, $s5, -1
	addi $t4, $s0, -1
	addi $t5, $s1, -1
	li $s6, 0
	
	move $t6, $s2			#不要动a0
	move $t7, $s3
	jal dfs
	
	print_int($s6)
	end
	
dfs:
	push($ra)
	push($t6)
	push($t7)
	
	mult $t6, $s1
	mflo $t0
	add $t0, $t0, $t7
	li $t1, 1
	store_int($t1, $t0)
	bne $t6, $s4, begin			#跳转地址搞错了
	bne $t7, $s5, begin
	addi $s6, $s6, 1
	j end_function

begin:
	
up:
	beq $t6, $zero, down
	get_up($t0, $t6, $t7, $s1)
	bne $t0, $zero, down
	addi $t6, $t6, -1
	jal dfs
	addi $t6, $t6, 1
	
down:
	beq $t6, $t4, left
	get_down($t0, $t6, $t7, $s1)
	bne $t0, $zero, left
	addi $t6, $t6, 1
	jal dfs
	addi $t6, $t6, -1
	
left:
	beq $t7, $zero, right
	get_left($t0, $t6, $t7, $s1)
	bne $t0, $zero, right
	addi $t7, $t7, -1
	jal dfs
	addi $t7, $t7, 1
	
right:
	beq $t7, $t5, end_function
	get_right($t0, $t6, $t7, $s1)
	bne $t0, $zero, end_function
	addi $t7, $t7, 1
	jal dfs
	addi $t7, $t7, -1
	
	
end_function:
	mult $t6, $s1
	mflo $t0
	add $t0, $t0, $t7
	store_int($zero, $t0)			#注意走的时候返回0
	pop($t7)
	pop($t6)
	pop($ra)
	
	jr $ra