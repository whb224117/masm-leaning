assume ds:datasg , cs:codesg              

;demo23的优化 把cx的暂存放在内存当中 不放在dx中                       
datasg  segment                                                               
             db 'file            '
             db 'edit            '
             db 'sear            '
             db 'view            '
             db 'opti            '
             db 'help            '
             db ' '
datasg ends

codesg segment                                                                         
start :                                                                                      
            mov ax,datasg                                                            
            mov ds,ax
            mov bx,0
            mov cx,6
            mov si,0
s0 :   
          
           mov ds:[60h],cx
           mov cx,4
           mov bx,0
s1:  
            mov al,[bx+si]
            and al,11011111b
            mov [bx][si],al
            inc bx
            
            loop s1  ;在此处寄存器cx才会减一
            
            mov cx,ds:[60h]  ;把外层循环的cx的计数器的数据放在内存中 防止内层起冲突
            
            add si,16
            
            loop s0
            
            mov ax,4c00h
            int 21h
            
codesg ends

end start 