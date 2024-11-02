.data
array: .space 4000
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

.macro store_num(%ans, %addr, %name)
	sll %addr, %addr, 2
	sw %ans, %name(%addr)
	srl %addr, %addr, 2  			##attention! 注意要移动回来！！！
.end_macro

.macro get_num(%ans, %addr, %name)
	sll %addr, %addr, 2
	lw %ans, %name(%addr)
	srl %addr, %addr, 2
.end_macro

.text
	get_int($s0)			#s0 = n
	li $t0, 0
	
for_1_begin:
	beq $t0, $s0, for_1_end
	nop
	
		get_int($t1)
		store_num($t1, $t0, array)
	
	addi $t0, $t0, 1
	nop
	j for_1_begin
	
for_1_end:

	get_int($s1)		#查找的数字
	li $t0, 0			# i = 0

for_2_begin:
	beq $t0, $s1, for_2_end
	nop
	
		get_int($s2)
		jal binary_search
	
	addi $t0, $t0, 1
	nop
	j for_2_begin

for_2_end:
end

binary_search:
	li $t1, 0								#low = 0
	addi $t2, $s0, -1				#high = n - 1
	li $t3, 0								#find_flag = 0
	
while_1_begin:
	sub $t4, $t1, $t2				#t4 = t1 - t2
	bgtz $t4, while_1_end
	nop
	
		li $t6, 2
		add $t5, $t1, $t2
		divu $t5, $t6
		mflo $t5											#t5 = mid
		get_num($t6, $t5, array)			#array[mid] = t6
		sub $t7, $t6, $s2							#t7 = array[mid] - key
		beq $t7, $0, equal
		nop
		bgtz $t7, greater
		nop
		
		addi $t1, $t5, 1        #low= mid + 1 
		j while_1_begin
		
		greater:
			addi $t2, $t5, -1        #high = mid - 1 
			j while_1_begin
			
		equal:
			li, $t3, 1
			j while_1_end
			
while_1_end:
	print_int($t3)
	print_str(nextline)
jr $ra
	