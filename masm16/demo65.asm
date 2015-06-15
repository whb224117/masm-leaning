assume cs:codesg
;编程 安装7ch的中断例程
;功能 求一word型数据的平方
;参数：（ax）等于要计算的数据
;返回值：dx，ax中存放结果的高16位和低16位
codesg segment

start:
             mov ax,cs                                                             
             mov ds,ax                                                              ;段寄存器之间不能直接传递 只能通过通用寄存器传递
             mov si,offset sqr                                                   ;设置ds:si指向源地址
             mov ax,0
             mov es,ax                                                               ;段寄存器不能传入立即数 也只能通过通用寄存器传入
             mov di,200h                                                         ;设置es:di指向目的地址
             mov cx,offset sqrend - offset sqr                       ;设置cx为传输长度
             cld                                                                           ;设置传输方向为正
             
             rep movsb                                                          ;先拷贝代码到安全内存地区
             
             mov ax,0
             mov es,ax
             mov word ptr es:[7ch*4],200h                     ;设置中断向量表地址
             mov word ptr es:[7ch*4+2],0
             
             ;中断和跳转 int  iret 和call  ret的最大区别就是中断指令会让标志寄存器入站 相应的iret会让flag registr 出战
             int 7ch                                                             ;会自动将cs ip fr压栈
             mov ax,4c00h
             int 21h
             
sqr:
            mul ax
            iret           ;将cs ip fr出栈
            ;如果处出现7ch中断则执行此子程序并跳回原程序
sqrend:
           nop
codesg ends

end start

             
             
             