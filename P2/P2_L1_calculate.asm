.data
array: .space 26
order: .space 26
space: .asciiz " "
nextline: .asciiz "\n"

.macro print_space
	la $a0, space
	li $v0, 4
	syscall
.end_macro

.macro println
	la $a0, nextline
	li $v0, 4
	syscall
.end_macro

.macro print_int(%d)
	move $a0, %d
	li $v0, 1
	syscall
.end_macro

.macro get_int(%d)			#读取int之后的换行符不计入char中
	li $v0, 5
	syscall 
	move %d, $v0
.end_macro

.macro print_char(%c)
	move $a0, %c
	li $v0, 11
	syscall
.end_macro

.macro get_char(%c)
	li $v0, 12
	syscall
	move %c, $v0
.end_macro

.macro char_plus(%c)
	addi $t9, %c, -97
	lb	$t8, array($t9)
	bne $t8, $0, jump1
	sb %c, order($s1)
	addi $s1, $s1, 1
jump1:
	addi $t8, $t8, 1
	sb $t8, array($t9)
.end_macro

.macro	end
	li $v0, 10
	syscall
.end_macro

.text
	get_int($s0)
	li $t0, 0
	li $s1, 0
for_1_begin:
	beq $t0, $s0, for_1_end
	nop
	
	get_char($t1)
	char_plus($t1)
	
	addi $t0, $t0, 1
	nop
	j for_1_begin
	
for_1_end:

	li $t0, 0
for_2_begin:
	beq $t0, $s1, for_2_end
	nop
	
	lb $t1, order($t0)
	addi $t3, $t1, -97
	lb $t2, array($t3)
	print_char($t1)
	print_space
	print_int($t2)
	println
	
	addi $t0, $t0, 1
	nop
	j for_2_begin
	
for_2_end:
end
