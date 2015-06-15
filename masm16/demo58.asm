assume cs:codesg

;demo56的改进版

datasg segment

db 'Welcome to masm!'
db 16 dup(0)

datasg ends

codesg segment

start:
      mov ax,datasg;
      mov ds,ax
      mov si,14
      mov di,30
      mov es,ax
      mov cx,8
      
      std         ;cld clear diretion 清楚方向标志  让df diretion flag为0 正向传送           std set direction 置方向标志   让df diretion flag为1 反向向传送    
      ;清除方向标志，在字符串的比较，赋值，
      ;读取等一系列和rep连用的操作中，
      ;di或si是可以自动增减的而不需要人来加减它的值，
     ; cld即告诉程序si，di向前移动，
     ; std指令为设置方向，告诉程序si，di向后移动
     
     rep movsw     ;传送字指令 每次把ds:[si]传送到ds:[di]中 并且cx减一
     
     ;MOVSB（MOVe String Byte）：即字符串传送指令，这条指令按字节传送数据。 一个字节
     ;MOVSW（MOVE String Word）：即字串传送指令，这条指令按字传送数据。      两个字节
     ;通过SI和DI这两个寄存器控制字符串的源地址和目标地址，
     ;比如DS:SI这段地址的N个字节复制到ES:DI指向的地址，
     ;复制后DS:SI的内容保持不变
     
     ;REP（REPeat）指令就是“重复”的意思，
     ;术语叫做“重复前缀指令”，因为既然是传递字符串，
     ;则不可能一个字（节）一个字（节）地传送，
     ;所以需要有一个寄存器来控制串长度。
     ;这个寄存器就是CX，指令每次执行前都会判断CX的值是否为0
     ;（为0结束重复，不为0，CX的值减1），以此来设定重复执行的次数。
     ;因此设置好CX的值之后就可以用REP MOVSB了
     
     mov ax,4c00h
     int 21h
     
codesg ends

end start