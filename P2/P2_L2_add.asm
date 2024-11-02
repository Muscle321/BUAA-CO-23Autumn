.data
matrix: .space  512
result: .space 256
space: .asciiz  " "
nextline: .asciiz "\n"
output: .asciiz "The result is:\n"

.macro get_int(%ans)
	li $v0, 5
	syscall
	move %ans, $v0
.end_macro

.macro get_index(%ans, %i, %j, %m)
	mult %m, %i
	mflo %ans
	add %ans, %ans, %j
	sll %ans, %ans, 2
.end_macro

.macro print_int(%ans)
	move  $a0, %ans
	li $v0, 1
	syscall
.end_macro

.macro print_str(%ans)
	la  $a0, %ans
	li $v0, 4
	syscall
.end_macro

.macro end
	li $v0, 10
	syscall
.end_macro

.text
get_int($s0)     #n row
get_int($s1)		#m column

mult $s0, $s1
mflo $t0		#t0 = n*m
sll $t0, $t0, 1
li $t1, 0			#set i = 0

for_1_begin:
	beq $t1, $t0, for_1_end
	nop
	
	get_int($t2)
	sll $t3, $t1, 2
	sw $t2, matrix($t3)
	
	addi $t1, $t1, 1
	nop
	j for_1_begin
	
for_1_end:

li $t0, 0			#set i = 0
li $t1, 0 			#set j = 0
mult $s0, $s1
mflo $s2
sll $s2, $s2, 2

for_2_begin:
	beq $t0, $s0, for_2_end
	nop
		li $t1, 0
		for_3_begin:
			beq $t1, $s1,  for_3_end
			nop
			
			get_index($t2, $t0, $t1, $s1)
			get_index($t3, $t1, $t0, $s0)
			lw $t4, matrix($t2)
			add $t2, $t2, $s2
			lw $t5, matrix($t2)
			add $t6, $t4, $t5
			sw $t6, result($t3)
			
			addi $t1, $t1, 1
			nop
			j for_3_begin
			
		for_3_end:
	addi $t0, $t0, 1
	nop
	j for_2_begin
	
for_2_end:

li $t0, 0			#set i = 0
li $t1, 0 			#set j = 0
print_str(output)

for_4_begin:
	beq $t0, $s1, for_4_end
	nop
	li $t1, 0
	for_5_begin:
		beq $t1, $s0, for_5_end
		nop
			
			get_index($t2, $t0, $t1, $s0)
			lw $t3, result($t2)
			print_int($t3)
			print_str(space)
			
		addi $t1, $t1, 1
		nop
		j for_5_begin
		
		for_5_end:
		print_str(nextline)

	addi $t0, $t0, 1
	nop
	j for_4_begin
	
for_4_end:
end
