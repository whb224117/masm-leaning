assume cs:codesg                                 ;codesg为代码段
codesg segment                                   ;段开始cs 表示代码段 以下的数据均编译放在代码段
            dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
            dw 0,0,0,0,0,0,0,0
                                                                    ;DW  定义一个字 define word 两个字节
                                                                      ;DB  定义一个字节 define byte 一个字节 
                                                                        ;DD  定义一个双字 define double world 四个字节
start:                                                                          ;ip=32
            mov ax,codesg                                    ;cs == codesg  编译器会将codesg编译成cs
            mov ss,ax                                            ;段寄存器之间不能直接赋值 只能通过通用寄存器赋值
            mov bx,0
            mov sp,32                                          ;0~31为数据存储单元 sp指向32表示栈为空
            mov cx,8
s0 :            
            push cs:[bx]  
            add bx,2       
            
            loop s0
            
            mov bx,0
            mov cx,8
s1 :   
            pop cs:[bx]     
            add bx,2
            
             loop s1
             
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends ;段结束

end start 
;程序结束  编译器先找end end即是程序的结束位置 也从end出找到程序的开始部分 因为start可以修改为任何值只是一个标识