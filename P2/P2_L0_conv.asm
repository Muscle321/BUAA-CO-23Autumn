.data
matrix_f: .space 484
matrix_g: .space 484
space: .asciiz " "
nextline: .asciiz "\n"

.macro end
	li $v0, 10
	syscall
.end_macro

.macro get_int(%data)
	li $v0, 5
	syscall
	move %data, $v0
.end_macro

.macro print_int(%data)
	move $a0, %data
	li $v0, 1
	syscall
.end_macro

.macro	print_str(%s)
	la $a0, %s
	li $v0, 4
	syscall
.end_macro

.macro get_index(%num, %i, %j, %column)
	mult %i, %column
	mflo %num
	add %num, %num, %j
.end_macro

.macro store_int(%data, %num, %name)
	sll %num, %num, 2
	sw %data, %name(%num)
	srl %num, %num, 2
.end_macro

.macro load_int(%data, %num, %name)
	sll %num, %num, 2
	lw %data, %name(%num)
	srl %num, %num, 2
.end_macro

.text
	get_int($s0)
	get_int($s1)
	get_int($s2)
	get_int($s3)
	
	li $t0, 0
for_1_begin:
	beq $s0, $t0, for_1_end
	nop
	
	li $t1, 0
	for_2_begin:
		beq $t1, $s1, for_2_end
		nop
		
		get_int($t3)
		get_index($t4, $t0, $t1, $s1)
		store_int($t3, $t4, matrix_f)
		
		addi $t1, $t1, 1
		nop
		j for_2_begin
		
	for_2_end:
	
	addi $t0, $t0, 1
	nop
	j for_1_begin
	
for_1_end:

	li $t0, 0
for_3_begin:
	beq $s2, $t0, for_3_end
	nop
	
	li $t1, 0
	for_4_begin:
		beq $t1, $s3, for_4_end
		nop
		
		get_int($t3)
		get_index($t4, $t0, $t1, $s3)
		store_int($t3, $t4, matrix_g)
		
		addi $t1, $t1, 1
		nop
		j for_4_begin
		
	for_4_end:
	
	addi $t0, $t0, 1
	nop
	j for_3_begin
	
for_3_end:

	sub $s4, $s0, $s2
	addi $s4, $s4, 1
	sub $s5, $s1, $s3
	addi $s5, $s5, 1

	li $t0, 0
for_5_begin:
	beq $s4, $t0, for_5_end
	nop
	
	li $t1, 0
	for_6_begin:
		beq $t1, $s5, for_6_end
		nop
		
				li $t2, 0
				li $s6, 0
				for_7_begin:
				beq $t2, $s2, for_7_end
				nop
	
				li $t3, 0
				for_8_begin:
					beq $t3, $s3, for_8_end
					nop
					
					get_index($t4, $t2, $t3, $s3)
					load_int($t5,$t4,matrix_g)
					add $t7, $t0, $t2
					add $t8, $t1, $t3
					get_index($t4, $t7, $t8, $s1)
					load_int($t6, $t4, matrix_f)
					mult $t5, $t6
					mflo $t9
					add $s6, $s6, $t9
					
					addi $t3, $t3, 1
					nop
					j for_8_begin
		
				for_8_end:
	
				addi $t2, $t2, 1
				nop
				j for_7_begin
	
				for_7_end:
				print_int($s6)
				print_str(space)
				
		addi $t1, $t1, 1
		nop
		j for_6_begin
		
	for_6_end:
	print_str(nextline)
	
	addi $t0, $t0, 1
	nop
	j for_5_begin
	
for_5_end:
end
