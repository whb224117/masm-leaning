assume cs:codesg            ;各种栈的伪命名   可以省略 
;assume ds:datasg的准确意义是将data段与段寄存器ds关联起来
;也就是用ds来存储data段的地址（段地址），当然这个关联是给编译器看的，
;而且由于assume写到了最前面，编译器一开始就能够看到，那么它在编译时，遇到有关data的标号，
;需要其段地址就会默认使用ds寄存器

;demo 13 的优化代码 
                           
a segment                                                                      ; 数据段                   
            db 1,2,3,4,5,6,7,8
a ends

b segment                                                                        ;栈段
            db 1,2,3,4,5,6,7,8
b ends
   
c segment                                                                        ;栈段
            db 1,2,3,4,5,6,7,8
c ends                                                                                          ;DW  定义一个字 define word 两个字节
                                                                                                      ;DB  定义一个字节 define byte 一个字节 
codesg segment                                                                         ;DD  定义一个双字 define double world 四个字节
start :                                                                                         ;ip指向的位置 程序的入口点
            mov ax,a                                                            ;栈段地址传递
            mov es,ax
            mov ax,c                                                             ;数据段地址传递
            mov ds,ax
            mov bx,0
            mov cx,8
s0 :            
            mov [bx],es:[bx]
            add bx,1      
            
            loop s0
            
            mov bx,0
            mov cx,8
s1 :   
            mov ax,b
            mov es,ax
            mov dx,es:[bx]
            add [bx],dx    
            add bx,1
            
             loop s1
             
            mov ax,4c00h
            int 21h
;p结束程序 也可以结束循环loop即后台完成 前台不单步显示
codesg ends ;段结束

end start 
;程序结束  编译器先找end end即是程序的结束位置 也从end出找到程序的开始部分 因为start可以修改为任何值只是一个标识