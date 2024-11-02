.data
string: .space 20

.macro get_int(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.macro get_char(%ans)
	li $v0, 12
	syscall
	move %ans, $v0
.end_macro

.macro store_char(%c, %addr, %name)
	sb %c, %name(%addr)
.end_macro

.macro load_char(%c, %addr, %name)
	lb %c, %name(%addr)
.end_macro

.macro print_int(%ans)
	move $a0, %ans
	li $v0, 1
	syscall
.end_macro

.macro end
	li $v0, 10
	syscall
.end_macro

.text
	get_int($s0)		#s0 = n
	
	li $t0, 0
for_1_begin:
	beq $t0, $s0, for_1_end
	nop
	
	get_char($t1)
	store_char($t1, $t0, string)
	
	addi $t0, $t0, 1
	nop
	j for_1_begin
	
for_1_end:

	srl $s1, $s0, 1
	sub $s2, $s0, 1
	li $t0, 0
for_2_begin:
	beq $t0, $s1, for_2_end
	nop
	
	sub $t1, $s2, $t0
	load_char($t3, $t0, string)
	load_char($t4, $t1, string)
	bne $t3, $t4, fail
	
	addi $t0, $t0, 1
	nop
	j for_2_begin
	
for_2_end:
	li $s3, 1
	print_int($s3)
	end

fail:
	print_int($zero)
	end