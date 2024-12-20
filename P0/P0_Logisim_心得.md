# Logisim
---
鄙人认为Logisim也算是一种编程语言，只不过他重视的显示数据，所以看起来更加直观一些。但是作为一种语言，离不开的都是语法和结构。但是Logisim语法没有什么难度，就是识别一些器件及其作用、认识电路图即可，只是有一些器件有特殊用途可以简化很多步奏。所以本文先从结构层面写，再总结一下Pre和P0的经验，总结一些技巧。

## Logisim结构
---
提到语言结构离不开的都是顺序、选择和循环。

### 顺序
---
因为Logisim在写之前已经定义好了IO口，所以电路的逻辑顺序基本上通过题目都可以写出来，所以顺序结构相对比较简单，就是从前往后搭电路即可；只要把电路的底层逻辑写清楚，用相关语法表示即可。


![[Pasted image 20231008173538.png]]
在正式开始搭电路之前，尽量先把这个表格列出来，也不需要太过详细，只需要了解该电路有哪几个部件，需要几个临时变量即可；

### 选择
---
对于编程语言，选择结构比较简单，直接if-else语句、switch语句等选择语句即可；但是在Logisim中需要用各个器件把这种选择关系表示出来，还是有一定难度的。

下面先看一段C语言选择语句代码：
```cs  {.line-numbers}
if (judgement1)
{
	statement1;
}
else if (judgement2)
{
	statement2;
}
else
{
	statement3;
}
```

下面我们要用Logisim的元器件把这一块逻辑完全表示出来:
- 我们知道对于每个==judgement==都相当于一个布尔表达式，一般都是通过==比较器==来得到他的值(0 or 1)，所以我们可以通过比较器得到每个==judgement==的值，然后通过MUX选择一路执行我们的statement；
- 对于statement，如果这个statement是在电路之初，那么statement要可能要一直执行到Output，导致每个statement过长，使得电路复杂度大大提高，所以建议statement是一个赋值的语句，并且都是同时给一个变量赋值，最好直接对应结束的Output，这样每个statement就没有那么复杂，只需要MUX就可以解决。

下面为解决方法：

- ![[Pasted image 20231008205414.png]]我们可以通过两个MUX将三个statement得到的值分开

### 循环
---
鄙人认为Logisim中的循环就是将组合电路通过时序逻辑计数器，不断进行即可达到循环目的；

### 函数
---
Logisim中的函数就可以认为是子电路，只需要认真设计子电路即可；

## 组合逻辑
---
Logisim的组合逻辑就是将题目描述先转化为C语言代码，然后再翻译为Logisim语言即可，下面总结Pre和P0中常见的组合逻辑方法。
对于组合逻辑，写出比较简洁的算法，即程序设计，是关键。

### 真值表生成
---
对于一般组合逻辑电路，首要考虑的办法就是真值表生成，尤其是在有限状态机中应用比较广泛。尽管Input可能有2位或者3位，可以用分离器将他们分为1位的，然后通过真值表生成子电路，能够节约很多时间。

### 独热编码
---
对于投票等需要统计1的个数或者每一个状态0和1有明显的不一样时，可以通过独热编码的方式，将每个数通过分离器合并在一起，然后统计合并后数字的0和1即可。

## 时序逻辑
---
时序逻辑的设计离不开两类有限状态机，一般来说时序逻辑比较简单，只要把状态找对即可。
基本包括三大块：
- 状态转移
- 状态储存
- 输出
除了状态储存设计时序逻辑，其余两部分都是组合逻辑电路，大都可以通过真值表生成直接生成目标电路，但是一定要把有限状态机的状态及对应转移关系（==有几个状态==、==输入什么时会转移==）搞清楚。

根据输出是否与输入有关可以把状态机分为两类，一类为Moore类，一类为Mealy类：
### Moore类
---
![[Pasted image 20231008212410.png]]
### Mealy类
---
![[Pasted image 20231008212425.png]]

### 同步复位和异步复位
---
- 异步复位，无论时钟沿是否到来，只要复位信号有效，就对系统进行复位，即与register的clear信号效果相同；
- 同步复位，只有时钟上升沿到来时，复位信号有效，才能进行复位。需要在状态转移与状态储存之间加一个MUX选择器。如果信号无效，则正常选择；如果信号有效，即选择0即可。如下图示
![[Pasted image 20231008213003.png]]

### 寄存器赋初值*
---
寄存器初值默认为0，如果想要赋值给寄存器，可以采用下面的方法：
- 关于给寄存器赋初值这个问题，可以采用计数器和多路选择器共用的方式![[Pasted image 20231008215254.png]]可以给寄存器赋初值，计数器Counter一定要选择Stay at value.

## 题目心得
---
### Logisim_Pre_mod5
---
初次写这种题，我的错误犯了很多。
- 首先，我应该根据有限状态机的步奏分为三大块进行，而不是硬靠自己瞎想想出来；
- 其次，我应该明确写出状态及状态之间的关系，并且在状态位数不多的情况下完全可以真值表生成没必要自己搭一个组合逻辑电路解决；
- 最后，这个题明显是Mealy型有限状态机，一定要看清楚题目，分清楚两种状态机之间的关系。

### Lofisim_P0_CRC
---
- 这个题目感觉没有太大难度，只需要认真审题，弄清楚题目的意思，学会程序设计，根据题目意思找到合适的能够使题目明显简单的子电路即可。这个题目有意思在除法即为异或。

### Lofisim_P0_GRF
---
- 这个题目也没有太大难度，更多的是重复工作太多。
- 值得注意的一点是关于==DMX的three-state问题==，当DMX多路分配器没有选择的路应当保持之前的值不变时，需要采用three-state使得达到高电阻，让原来输入的值保持不变即可。

### Logisim_P0_ftoi
---
- 这个题目就是典型的Logisim选择语句，如果能够理清楚选择语句之间的关系，并且耐心把题目读明白，那么这道题虽为附加题，但是毫无难度。

### Logisim_P0_navigation
---
- 这个题目就是典型的Input为两位，State也为两位，需要用分离器将其分为input1, input0,pre_state1, pre_state0，再根据真值表得到output, now_state1, now_state0，一定不要搞混淆这几个值，真值表一定要写清楚，那么这道题也没有什么难度。
- 其次，这个题目需要还需要注意的就是达到终点之后等待一周期可以用一个寄存器来储存到达的状态，然后用寄存器自带的Enable即可。

### Logisim_P0_FSM
---
- 这个题目也不算难，关键在于同步复位的处理，要弄清楚同步复位和异步复位的异同。