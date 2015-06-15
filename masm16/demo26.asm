assume ds:datasg , cs:codesg , ss:stacksg             

                           
datasg  segment                                                               
             db '1. file         '
             db '2. edit         '
             db '3. search       '
             db '4. view         '
             db '5. options      '
             db '6. help         '
datasg ends

stacksg segment
            dw 0,0,0,0,0,0,0,0
stacksg ends    

codesg segment  
                                                               
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov ax,stacksg
            mov ss,ax
            mov sp,16
            mov si,0
            mov cx,6
            
s0 :       
            push cx  ;返回上面 立刻将cx减一的值压入栈保存起来 防止内层循环cx被覆盖
            mov cx,4
            mov bx,0            
s1:     
            mov al,[bx+si+3]
            and al,11011111b
            mov [bx+si+3],al
            inc bx
            
            loop s1
            
            add si,16
            pop cx
            loop s0   ;执行此语句 cx减一
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start    