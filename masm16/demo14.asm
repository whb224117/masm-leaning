assume ds:datasg , cs:codesg , ss:stacksg                   ;各种栈的伪命名   

;demo 13 的优化代码 
                           
datasg  segment                                                                      ; 数据段                   
            dw 0123h,0456h,0789h,0abch,0defh,0fedh,0cbah,0987h
datasg ends

stacksg segment                                                                        ;栈段
            dw 0,0,0,0,0,0,0,0
stacksg ends
                                                                                                     ;DW  定义一个字 define word 两个字节
                                                                                                      ;DB  定义一个字节 define byte 一个字节 
codesg segment                                                                         ;DD  定义一个双字 define double world 四个字节
start :                                                                                         ;ip指向的位置 程序的入口点
            mov ax,stacksg                                                            ;栈段地址传递
            mov ss,ax
            mov ax,datasg                                                             ;数据段地址传递
            mov ds,ax
            mov bx,0
            mov sp,16     ;栈共占16个字节  0~15 16表示栈为空
            mov cx,8
s0 :            
            push [bx]  
            add bx,2       
            
            loop s0
            
            mov bx,0
            mov cx,8
s1 :   
            pop [bx]     
            add bx,2
            
             loop s1
             
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends ;段结束

end start 
;程序结束  编译器先找end end即是程序的结束位置 也从end出找到程序的开始部分 因为start可以修改为任何值只是一个标识