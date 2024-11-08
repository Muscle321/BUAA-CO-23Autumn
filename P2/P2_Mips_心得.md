# Mips
---
Mips作为一种汇编语言，是一种低级语言，不同于Java、C等高级语言有许多语法和定义好的函数和类，这门语言的各种语法几乎都要自己通过使用这些寄存器去实现。
本文将介绍作为一种基本编程语言的三种结构——顺序、选择、循环去了解Mips的使用，并且介绍Mips的函数使用、宏定义等等。

## Mips结构
---
### 顺序结构
---
顺序结构是最基本的结构，这里就不再过多描述，比较简单。

### 选择结构
---
选择结构最经典的就是if-elseif语句
下面看一段经典的C代码：
``` C
if (expression1) 
{
	statement1;
}
else if(expression2)
{
	statement2;
}
else
{
	statement3;
}
```
这段代码经翻译之后变为Mips汇编语言就比较复杂和抽象，需要一些跳转指令`beq`、`bne`等的实现
下面是一段示例代码：
``` mips
bne $t0, $0, else_if      # $t0 is expression1
	statement1
	j end
else_if:
bne $t1, $0, else        # $t1 is expression2
	statement2
	j end
else:
	statement3;
end:
```
我们将C语言中的`expression`作为布尔表达式的结果`0`或`1`存放在寄存器`$t0`、`$t1`中，这样通过判断将`$t0`、`$t1`与`0`做比较，并且通过`bne`指令即可达到需求。
需要特别注意的是，如果仅仅执行一条语句，那么一定要再==每一块结束==后加上`j end`这条语句。

### 循环结构
---
我在此仅列出最经典的for循环
```
li $t0, 0
li $s0, 10
for_1_begin:
beq $t0, $s0, for_1_end
nop

	statement;

addi $t0, $t0, 1     ##容易忘记！！！
nop
j for_1_begin        ##容易忘记！！！

for_1_end:
```

## Mips函数
---
- Mips中的函数还是比较好用，但是对于函数来说，我们需要使用`jal function_name`和`jr $ra`这两个配套指令来进行函数的调用和返回，前者调用的时候使用，后者需要在函数的最后返回的时候使用。
- 对于较难理解的递归函数，需要在函数开始之前把该函数需要使用到的寄存器的压栈，并且在函数结束的时候把父函数使用的寄存器重新出栈即可。但是需要注意的是压栈和出栈需要一一对应。
- 对于需要传递参数的函数，例如`function(index+1)`，需要在函数调用之前将储存`index`的寄存器的值`+1`，并且在函数调用之后立马`-1`回归的原来函数中的值。

## Mips宏定义
---
我再次列出一些我比较喜欢的宏定义
- 结束程序
	```
	.macro end
	li $v0, 10
	syscall
	.end_macro
	```
- 得到整数
	```
	.macro get_int(%d)
	li $v0, 5
	syscall
	move %d, $v0      ##容易搞错位置
	.end_macro
	```
- 得到字符
	```
	.macro get_char(%c)
	li $v0, 12
	syscall
	move %c, $v0      ##容易搞错位置
	.end_macro
	```
- 打印整数
	```
	.macro print_int(%d)
	move $a0, %d      ##容易搞错位置
	li $v0, 1
	syscall
	.end_macro
	```
- 打印字符
	```
	.macro print_char(%c)
	move $a0, %c      ##容易搞错位置
	li $v0, 11
	syscall
	.end_macro
	```
- 打印空格、换行符、输出等字符串（常用来输出的时候使用）（%s为在`.data`中定义的`.asciiz`类型以`\0`结尾的字符串）
	```
	.macro print_str(%s)
	la $a0, %s
	li $v0, 4
	syscall
	.end_macro
	```
- 函数压栈
	```
	.macro push(%d)
	addi $sp, $sp, -4
	sw %d, 0($sp)
	.end_macro
	```
- 函数出栈
	```
	.macro pop(%d)
	lw %d, 0($sp)
	addi $sp, $sp, 4
	end_macro
	```
- 得到在数组中的位置（常和矩阵联系使用）
	```
	.macro get_index(%num, %i, %j, %column)
	mult %i, %column
	mflo %num
	add %num, %num, %j
	.end_macro
	```
- 储存整数（注意`%num`左移后重新右移回去）
	```
	.macro store_int(%d, %num, %name)
	sll %num, %num, 2
	sw %d, %name(%num)
	srl %num, %num, 2      ##容易忘记
	.end_macro
	```
- 加载整数（注意`%num`左移后重新右移回去）
	```
	.macro load_int(%d, %num, %name)
	sll %num, %num, 2
	lw %d, %name(%num)
	srl %num, %num, 2      ##容易忘记
	.end_macro
	```
剩下的宏定义可以在具体的场景中具体实现，比如我们可以把`load_int`和`get_index`在一些矩阵之类的题目中合并等等灵活操作。

## Mips题目心得
---
### P2_L0_matrix
---
这道题目不难，细心就可以，别忘了在每个`for`循环后加上`j for_begin`.

### P2_L0_judge
---
这个题目我是按字节存的字母，所以在找地址的时候就不需要移位了，直接得到的偏移数字`offset`即为地址。

### P2_L0_conv
---
这道题也是细心翻译就可以了

### P2_L0_full_1
---
这道题是一道经典的递归压栈出栈的题目，我第一次写的时候把`beq`和`bne`的关系弄反了，耽误了一些时间；其次，对于每个函数传入的参数，在传入前需要改变为传入的值，返回后重新改变为本身的值。参考见`FullArray(index+1)`.

### P2_L1_puzzle
---
这道题是经典回溯法深度查找算法，我一开始忘记了在查找完之后重新将该点标记为`0`；其次，我中间还把跳转地址搞错了；然后，不要使用`$a0`、`$v0`等在宏定义中常使用的寄存器。其余就没有什么难度了。

### P2_L1_factorial
---
这道题目非常有意思，我刚开始写的算法有问题，于是出现了差错。
- 首先，注意`move`的使用；
- 其次，我一开始用的是两个字节存两个位，但是最后打印的时候如果为`0`只能打印一个`0`，而不是`00`,并且如果为一位数字，那么不是`0x`而是`x`导致错误；之后使用一个字储存也是这样的错误，需要调整打印的时候的代码；
- 最后，我还是采用了两个字节存一位，方便打印，关键在于最后代码的逻辑有一点小问题；并且我发现了`.space`可以开到十万甚至还多。

### P2_L2_add
---
这道题很简单

### P2_L1_bsearch
---
这道题注意的就是对于宏定义`.macro`使用到的寄存器进行左移右移，一定要在最后移回去，否则容易造成不可预料的错误。

### P2_L1_flower
---
这道题需要注意`move`的使用啊！

### P2_L1_calculate
---
这道题目很简单，但是我获得了很多经验：
- 首先，一定要申请题目要求；
- 其次，对于输入整数后输入字符，输入整数后的下一个换行符不会被计入字符中；
- 然后，Mips中的字符储存方式和普通编程语言一样的，都是按`ascii`值进行存储的；
- 最后，要注意检测平台不会检测到字符中的换行符。

## Mips踩雷点总结
---
1. 一定要审题审清楚，不要因为逻辑错误而debug半天；
2. 对于`move`，一定要搞清楚是前者等于后者；
3. 对于`.macro`，在其中我们尽量不要改变传入寄存器的值，如果改变了尽量在结束之前重新变回原来的值；如果一定要用到中间寄存器，那么选用几乎不会在`.text`中出现的`$t9`、`$t8`等寄存器；
4. 对于`.text`，一定不要使用`$v0`、`$a0`等在宏定义中经常改变值的寄存器；对于每个寄存器的使用一定要记清楚，不要混淆；
5. 对于跳转地址，一定要记得在`for`循环的最后跳转回`for`循环的开始；
6. 对于选择结构的跳转，一定要搞清楚==何时==跳转到==何步奏==，这个逻辑一定不要搞错！
7. 最后，加油！相信你一定可以的！！