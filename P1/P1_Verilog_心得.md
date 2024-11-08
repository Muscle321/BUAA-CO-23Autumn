# Verilog
---
Verilog在我看来，本质上还是一种编程语言，只不过是一种硬件描述语言，可以通过仿真在FPGA上面运行实际电路。但是其大致语法和C语言基本上是一致的，结构也是几乎相同，我再次就简单介绍与C语言不相同的一些点。

## Verilog结构
---
大致与C相同，我仅介绍不同点。
### assign语句
---
在我看来assign就是一个组合电路，如果仅仅只是`assign out = in;` 那就相当于有一根导线连接着in和out，这两个部分的值无时无刻都是相同的。

### 运算符
---
#### 位拼接符号{}
需要注意的是，{}中的数据一定要显示==位宽==，例如{{16{1}},out}，如果是这样的话，相当于只有一个1拼在out的前面，必须为{{16{1b'1}},out}，才能够表示有16个1进行拼接。

#### 算术右移>>>和逻辑右移>>
顾名思义，不多解释。

#### 非阻塞赋值<=和阻塞赋值=
- 非阻塞赋值通常用于时序电路always块中；
- 阻塞赋值常用于组合电路中；
- 需要注意的是两种赋值方式一定不要同时出现，否则会出现意料之外的错误。

####  缩减运算符
`&`,`|`,`^`这三个位运算符可以作为单目运算符，例如`reg [31:0] B`来说，`|B`就相当于把B的三十二位或起来得到最终的结果。（这个过程常用于[奇偶校验](https://blog.csdn.net/weixin_42256557/article/details/123224897?ops_request_misc=%257B%2522request%255Fid%2522%253A%2522169735563116800222889259%2522%252C%2522scm%2522%253A%252220140713.130102334..%2522%257D&request_id=169735563116800222889259&biz_id=0&utm_medium=distribute.pc_search_result.none-task-blog-2~all~top_click~default-2-123224897-null-null.142^v96^pc_search_result_base7&utm_term=%E5%A5%87%E5%81%B6%E6%A0%A1%E9%AA%8C&spm=1018.2226.3001.4187)）


### always块
---
always块常用于做时序逻辑，如果是组合逻辑，大都可以用assign解决（if-else if语句，如果为循环可以加个函数），此处不再多写。


### 函数
---
Verilog中函数的模板为
``` Verilog
function [width-1:0] function_id;
	input_declaration 
	other_declarations 
	procedural_statement 
endfunction
```
函数中一定是组合逻辑电路，而不能包含always块和时序逻辑。

### 同步复位和异步复位
---
- 同步复位
``` Verilog
always@(posedge clk) begin
if(reset) begin
	statement;
end
else begin
	statement;
end
```
- 异步复位
``` Verilog
always@(posedge clk or posedge reset) begin
if(reset) begin
	statement;
end
else begin
	statement;
end
```

## Verilog题目心得
---
### P1_L0_splitter
---
这个题目毫无难度；

### P1_L0_ALU
---
也是没有难度，只是在涉及到有符号数的运算的时候我们可以新定义一个变量，然后将有符号的那一行运算结果赋值给他，就可以保证结果的正确性。参考代码:
``` Verilog
assign D = $signed(A) >>> B;
assign C = () ? A + B :
		   () ? A - B :
		   () ? A & B :
		   () ? A | B :
		   () ? A >> B :
		   () ? D : 0;
```

### P1_L0_ext
---
这个题目需要注意的就是位拼接符号了，我得到了以下结论：
- `{16{1},imm}`语法是错误的，需要在`16{1}`外再加一层{}；
- `{{16{1}},imm}`不能够正确拼接，只能补1位1，因为这个1没有显示位宽，所以编译器不知道16个1是多少位的，于是就默认按一位算；
- `{{16{1'b1}},imm}`和`{16'hffff,imm}`是正确的。

### P1_L0_gray
---
这个题目给我最大的收获就是，一定要看清楚==题目给的信号名字（注意大小写）==

### P1_L0_表达式状态机
---
这个题目可谓是一波三折，我在学习了P1的一段式状态机之后可谓是跃跃欲试，十分想把它应用到现在所学，无可奈何没有理解清楚就上手导致了错误的产生。
- 首先，非必要不再用一段式；
- 其次，一段式中要求他的out要提前一个状态，也就是说，比如state为2'b11时需要输出1，那么out就需要在state能达到1的状态进行赋值，而不是在达到1之后进行赋值，否则就慢了一步，导致出错。
~~难倒是不难，只是以后我再也不会用教程给的方法了~~

### P1_L1_BlockChecker
---
这个题目非常的考验耐心，第一次写的代码可以说bug百出，犯了许多他想让我犯的错误，这里我就一一列出。
- 在最开始，我把begin和end检测分开检测，这样看似有好处，实则容易出许多意料之外的错误，并且不好debug。于是我又改成两者和为一个状态。
- 我觉得最难就难在，我如果在输入了end之后下一个字符是`' '` 还是其他普通字符的检验，并且在检验到这个end不合法之后不仅需要把stack＋1，还需要让之前的flag再次归为0；比方说，如果第一个是end，那么之后所有的输入都不在看了，果断全部为0，那么这个时候就需要一个flag来表示，如果检测到第一个end，flag置为1；但是如果第一个end不合法，那么flag需要重新归为0。这就会出现一个隐形错误，也就是说flag可能在end begin endx后重新归为0，为了避免这样，就需要新定义一个Flag将状态锁住，永远不再进入这个状态转移，直至复位。
- 这个错误的本质，我认为还是由于flag是0还是1的判断的布尔表达式可能在其他情况下导致flag进行改变，而自己却没有注意到。其次就是endx的检测
（这个题目有个大佬还有个思路，就是用五个寄存器寄存前五个字符的数值，然后在第六个字符到来的时候进行检测，这样首先避免了endx检测各种flag的bug，还能避免很多错误，~~主要是我还没尝试这种方法，也不敢乱下定义~~）

### P1_L2_intcheck
---
这个题目也是让我受苦良久啊！
- 首先，Verilog中一定不要出现中文字符，尤其是：这类不易看出来的字符，报错为compile 806;
- 其次，对于`(expression) ? statement1 : statement2` 这种三目运算符，是if-elseif语句，也就是说，如果之前出现了判断后边就不会再重复；我把字母的判断写在了前边，那么后边默认就跳过i，n，t三个字母的判断了；还有就是我在这样修改之后的letter是去除了i，n，t三个小写字母的letter，那么我在进行判断i的时候letter一定要加上n，t否则也会出错（也就是这个letter不是所有的字母，是去除了i，n，t的剩下的字母）。
- 再者，对于每一个状态，我都要判断输入`;`和`,`导致的结果的不同，==每一个都要判断==，每一个状态都要考虑完备，我是在i，n，t三个状态的`;`检测没有考虑完备，因为分号就代表着从头开始，而不是进入`rubbish`。

## Verilog踩雷点总结
---
### 名称
---
- 一定要注意题目中给的名称是否和你写的一样，大小写是否一致。（为了debug方便，可以将output中加入state和char_type）
- 其次一定要注意不要有中文符号。

### 有无符号数的处理方法
---
在Verilog中，所有的数据都会被看做无符号数，如果想要有符号数，那就必须加上`$signed()`，并且如果一条语句中有多个数据，一旦有一个无符号数，那么就会被默认看作无符号处理，所以建议对有符号数的处理==单独定义一个变量写一行==考虑，否则会出现灵异事件。

### 位宽
---
在Verilog中，没有了int，char，longlong等不同大小的数据类型，只有`reg`(用于时序逻辑)，`wire`(用于组合逻辑)，`integer`(用于for循环)，所以就需要我们主动给数据加上位宽。如果没有位宽会出现很多灵异事件，无法debug，下面列举几个简单的例子：
- 不同位宽的值可以相加，但是最终的result一定保证不会使结果溢出；
- 对于函数，一定要加上位宽，否则不知道函数返回值是多大；
- 对于拼接符号{}，里面的数据如果为常数也一定要加上位宽；
- 对于加减常数，也是要加上位宽`3'b001`等。

### 组合逻辑
---
对于多个三目表达式，一定要注意后边的部分不会包括前边的部分。如果前边的部分是大小写字母，那么后边再判断i，n，t等字母就无效全部归为前边那一类；如果前边的部分是i，n，t，那么后边的大小写字母部分就不包括i，n，t这三个字符。

### 状态
---
- 状态的规定一定要提前写好，并且状态要尽可能少，但是也不能过于少。
- 对于一个状态，要确定好是检测==一个==字符例如空格或者其他符号，还是==不定长==的字符串例如数字或者空格或者字母。通常检测==一个==字符和检测==不定长==字符的state==不能==合并！
- 对于每个state，输入可能输入的任何结果都要想好他的去向。例如输入a可能进入rubbish，输入b可能重新开始；
- 总之，不要紧张，不要急躁，多多考虑其他情况，希望能一次写对！加油！