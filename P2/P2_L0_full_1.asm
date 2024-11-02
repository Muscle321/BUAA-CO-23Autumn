.data
symbol: .space 24
array: .space 24
space: .asciiz " "
nextline: .asciiz "\n"

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
	get_int($s0)			# s0 = n
	li $s1, 0
	li $s2, 1
	jal FullArray
	end


FullArray:
	push($ra)
	push($s1)
	push($t0)
		
		li $t0, 0
		bne $s1, $s0, for_2_begin		#ben 和 beq搞错了
		
		for_1_begin:
		beq $t0, $s0, for_1_end
		nop
		
			load_int($t1, $t0, array)
			print_int($t1)
			print_str(space)
		
		addi $t0, $t0, 1
		nop
		j for_1_begin
		
		for_1_end:
		print_str(nextline)
		j for_2_end
		
		for_2_begin:
		beq $t0, $s0, for_2_end
		nop
			
			load_int($t1, $t0, symbol)
			bne	 $t1, $zero, jump
				addi $t2, $t0, 1
				store_int($t2, $s1, array)
				store_int($s2, $t0, symbol)
				addi $s1, $s1, 1
				jal FullArray
				addi $s1, $s1, -1
				store_int($zero, $t0, symbol)
		
		jump:
		addi $t0, $t0, 1
		nop
		j for_2_begin
		
		for_2_end:
		
	pop($t0)
	pop($s1)
	pop($ra)
	jr $ra
	
	