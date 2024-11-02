.data

 matrix:  .space  256
 book:  .space  32

  .macro getindex(%ans, %i, %j)				#%ans = (%i * 8 + %j) * 4, 即matrix[i][j]
  		sll %ans, %i, 3			 # %ans = %i *8
  		add %ans, %ans, %j		# %ans = %ans + %j
  		sll %ans, %ans, 2			 # %ans = %ans * 4
.end_macro			

.text
	li  $v0, 5
	syscall
	move  $s0, $v0			#总点数n储存在s0
	li  $v0, 5
	syscall
	move  $t1, $v0			#边数m储存在t1, t1 as m
	
	li $s4, 0 						# ans初始值为0
	#开始输入无向图的边
	li $t2, 0	#use $t2 as i
	li $t6, 1
	
for_1_begin:
	slt $t3,$t2,$t1			#i<m时，t3 = 1
	beq $t3,$zero,for_1_end
	nop
	
	##每次循环输入无向图这条边的两个顶点
	li  $v0, 5
	syscall
	move  $t4, $v0			#第一个顶点存在t4
	addi $t4, $t4, -1
	li  $v0, 5
	syscall
	move  $t5, $v0			#第二个顶点存在t5
	addi $t5, $t5, -1
	getindex($t0, $t4, $t5)
	sw $t6, matrix($t0)
	getindex($t0, $t5, $t4)
	sw $t6, matrix($t0)			#G[i-1][j-1] = G[j-1][i-1] = 1
	
	addi $t2,$t2,1		#i++
	j for_1_begin
	nop
	
for_1_end:

## 初始化一些变量参数, 函数传递参数x为0, flag为1,
	addi $s1, $0, 0 		##初始化x为0
	addi $s3, $0, 0 		##初始化i为0
	li $t0, 1
	jal  dfs
	
	addi $a0, $s4, 0			##将ans的值传给$a0
	li $v0, 1							
	syscall							##输出$a0
	li $v0, 10
	syscall							##结束程序

dfs:
## 开始dfs深度学习
## 栈空间需要存放一个返回地址$ra, 还需存放参数x, 局部变量flag与i, 共16个字节
## 输入参数保存在$s1中, 无输出参数, flag保存在$s2中, i保存在$s3

	addi $sp, $sp, -16
	sw $s1, 0($sp)			##将x压入栈中
	sw $ra, 4($sp)				##将函数返回地址压入栈中
	sw $s2, 8($sp) 			##将flag压入栈中
	sw $s3, 12($sp)				##将i压入栈
	##将父函数所保存的值压入栈中
	##进行接下来子函数的运行
	
	addi $s1, $s3, 0							##令x = i
	sll $t1, $s1, 2								##$t1 = x * 4
	sw $t0, book($t1)						##book[x] = 1
	addi $s2, $0, 1							##初始化flag为1
	
## 判断是否经过了所有的点，函数中第一个for循环

	addi $t1, $s0, 0			##令$t1为n
	li $t2, 0					 		##令$t2为i=0
	
for_2_begin:
	slt $t3, $t2, $t1			##i<n
	beq $t3, $0, for_2_end
	nop
	
	sll $t5, $t2, 2								##$t5= i * 4
	lw $t4, book($t5)						##$t4 = book[i]
	and $s2, $s2, $t4						##flag &= book[i]
	
	addi $t2, $t2, 1				##i++
	j for_2_begin
	nop
	
for_2_end:
	
## 判断是否形成一条哈密顿回路	
	getindex($t1, $s1, $0)				
	lw $t2, matrix($t1)					## $t2 = matrix[x][0]
	and $t3, $s2, $t2						## $t3 = flag && G[x][0]
	beq $t3, $t0, suc						## 成功形成回路后转移
	
## 搜索与之相邻且为经过的边，函数中第二个for循环

	addi $t1, $s0, 0			##令$t1为n
	li $t2, 0					 		##令$t2为i=0
	
for_3_begin:
	slt $t3, $t2, $t1			##i<n
	beq $t3, $0, for_3_end
	nop
	
	sll $t5, $t2, 2								##$t5= i * 4
	lw $t4, book($t5)						##$t4 = book[i]
	nor $t4, $t4, $0							##将$t4取反
	getindex($t5, $s1, $t2)			
	lw $t6, matrix($t5)					##$t6 = matrix[x][i]
	and $t4, $t4, $t6						##$t4 = !book[i] && G[x][i]
	beq $t4, $0, skip
	addi $s3, $t2, 0							##将i保存在$s3中
	jal dfs												##进行子函数dfs(x)
	addi $t2, $s3, 0							##将i的值重新返回for循环中的i
	addi $t1, $s0, 0							##令$t1为n
	
skip:
	addi $t2, $t2, 1				##i++
	j for_3_begin
	nop
	
for_3_end:
	sll $t1, $s1, 2								##$t1= x * 4
	sw $0, book($t1)						##book[x] = 0
	j exit
	
suc:
	li $s4, 1						#ans = 1
	j exit
	
exit:
	lw $s1, 0($sp)
	lw $ra, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	addi $sp, $sp, 16
	##将父函数压入栈中的值返回到寄存器中，并且返回父函数
	jr $ra
	
	
