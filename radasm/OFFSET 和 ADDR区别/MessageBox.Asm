;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; MessageBox.asm
; 一个标准的MASM模版，只有一个对话框示例
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.386
		.model flat,stdcall
		option casemap:none
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; Include 文件定义
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
include		windows.inc
include		user32.inc
includelib	user32.lib
include		kernel32.inc
includelib	kernel32.lib
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 数据段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.const

szCaption	db	'标题',0
szText		db	'这里是要显示的内容!',0

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
; 代码段
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
		.code
start:
		invoke	MessageBox,0,addr szText,addr szCaption,MB_OK
		invoke	ExitProcess,0
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
end	start

;OFFSET 和 ADDR 的异同:
;　　1、offset 不能获取局部变量的地址;
;　　2、addr 只能用于调用函数(invoke)时, 不能用于赋值操作;
;　　3、addr 面对局部变量时会转换为 lea 等指令, addr 面对全局变量时则直接调用 offset;
;　　4、在 invoke 中应尽量使用 addr, 其他只用 offset.		


;offset 在编译时由编译器解释。
;addr   先检查处理的是全局还是局部变量，若是全局变量则把其地址放到目标文件中，这一点和offset相同，
;若是局部变量，就在执行   invoke   语句前产生如下指令序列：     
;  lea   eax，   LocalVar   
;  push   eax 
;lea指令能够在运行时决定标号的有效地址，所以有了上述指令序列，就可以保证   invoke   的正确执行了。
;lea是cpu的指令，而mov   ax,offset   xxx   只是我们利用编译器的offset自动计算的功能  

  
;比如你用local在栈上定义了一个局部变量LocalVar，你知道实际的指令是什么么？一般都差不多像下面的样子：   
;  push   ebp   
;  mov   esp,   ebp   
;  sub   esp,   4   
;  现在栈上就有了4各字节的空间，这就是你的局部变量。   
;  接下来，你执行mov   LocalVar,   4，那么实际的指令又是什么？是这样：   
;  mov   dword   ptr   [ebp-4]，   4   
;  于是，这个局部变量的“地址”就是ebp-4——显然，它不是一个固定的地址。现在需要将它的“地址”作为参数传给某个函数，你这样写：   
;  invoke/call   SomeFunc,   addr   LocalVar   
;  实际生成的指令是：   
;  lea   eax,   [ebp-4]     没有mov eax ebp-4 指令
;  push   eax   
;  call   SomeFunc   
;  当然，你也可以写成：   
;  mov   eax,   ebp   
;  sub   eax,   4   
;  push   eax   
;  call   SomeFunc   
;  看到了，这里多了一条指令。这就是lea的好处。于是，lea又多了一个非常美妙的用途：作简单的算术计算，特别是有了32位指令的增强寻址方式，更是“如虎添翼”：   
;  比如你要算EAX*4+EBX+3，结果放入EDX，怎么办？   
;  mov   edx,   eax   
;  shl   edx,   2   
;  add   edx,   ebx   
;  add   edx,   3   
;  现在用lea一条指令搞定：   
;  lea   edx,   [ebx+eax*4+3]      右值可以做简单的数学运算后直接赋值 不然用mov要好多条指令 

